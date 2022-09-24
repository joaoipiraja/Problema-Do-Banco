//
//  Thread.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 23/09/22.
//

import Foundation
import SwiftUI



let customerSempahore = DispatchSemaphore(value: 0)
let atmSemaphore = DispatchSemaphore(value: 0)
let mutex = DispatchSemaphore(value: 1)

var waitingQueues = Queue<CustomerThread>()
var atmMachines = Queue<ATMThread>()



protocol Thread{
    func run()
    func atualizarView()
    
}


class ViewData: ObservableObject{
    @Published var atms: Array<ATMModel> = []
    @Published var customers: Array<CustomerModel> = []
}



class ATMThread: Thread{
    func atualizarView() {
        DispatchQueue.main.sync {
            self.viewData.atms = atmMachines.elements.map{$0.model}
            //self.viewData.customers = waitingQueues.elements.map{$0.model}
        }
    }
    
    
    var model: ATMModel
    @ObservedObject var viewData:ViewData
    
    
    init(model: ATMModel, viewData: ObservedObject<ViewData>){
        self.model = model
        self._viewData = viewData
        atmMachines.enqueue(self)
    }
    
    func run() {
        while(true){
            customerSempahore.wait()
            mutex.wait()
            
            let client = waitingQueues.dequeue()
            
            model.clienteAtual = client?.model
            atmSemaphore.signal()
            mutex.signal()
            
            model.state = .Attending
            atualizarView()
            
            client?.cutting.wait()
            model.state = .Sleeping
            atualizarView()
        }
    }
    

}


class CustomerThread:Thread{
    
    
    
    var cutting = DispatchSemaphore(value: 0)
    var model: CustomerModel
    @ObservedObject var viewData: ViewData
    
    init(model: CustomerModel, viewData: ObservedObject<ViewData>){
        self.cutting = DispatchSemaphore(value: 0)
        self.model = model
        self._viewData = viewData
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func atualizarView() {
        
        DispatchQueue.main.sync {
            //self.viewData.atms = atmMachines.elements.map{$0.model}
            
            
            if let index = self.viewData.customers.firstIndex(where: {$0.id == waitingQueues.elements.first?.model.id}){
                self.viewData.customers[index ] = self.model
            }

        }
    }
    
    
    
    
    
    func run() {
        while(true){
            mutex.wait()
            if(waitingQueues.elements.count < atmMachines.elements.filter{$0.model.state == .Sleeping}.count){
                
                waitingQueues.enqueue(self)
                
                customerSempahore.signal()
                mutex.signal()
                atmSemaphore.wait()
                
                
                self.model.state = .BeingAttended
                
                atualizarView()
                
                
                for i in Range(0 ... self.model.tempoAtendimento){
                    
                        DispatchQueue.main.async {
                            self.model.tempoAtual =  self.model.tempoAtendimento - i
                        }
                    
                      sleep(1)
                   
                }
                
               
                
                 self.model.state = .Attended
                
                atualizarView()
                //do things
                cutting.signal()
                
                break
                
            }else{
                mutex.signal()
            }
        }
    }
}
