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

var waitingQueues = Queue<Customer>()
var atmMachines = Queue<ATM>()



protocol Thread{
    func run()
    func atualizarView()
    
}


class ViewData: ObservableObject{
    @Published var atms: Array<ATM.Model> = []
    @Published var customers: Array<Customer.Model> = []
}



class ATM: Thread{
    
    
    func run() {
        DispatchQueue.global(qos: .background).async {
                        
            while(true){
                customerSempahore.wait()
                mutex.wait()
                
                let client = waitingQueues.dequeue()
                
                self.model.clienteAtual = client?.model
                atmSemaphore.signal()
                mutex.signal()
                
                self.model.state = .Attending
                self.atualizarView()
                
                client?.cutting.wait()
                self.model.state = .Sleeping
                self.atualizarView()
            }
        }
        
    }
    
    
    
   
    func atualizarView() {
        DispatchQueue.main.async {
            self.viewData.atms = atmMachines.elements.map{$0.model}
            //self.viewData.customers = waitingQueues.elements.map{$0.model}
        }
    }
    
    
    var model: ATM.Model
    @ObservedObject var viewData:ViewData
    
    
    init(model: ATM.Model, viewData: ObservedObject<ViewData>){
        self.model = model
        self._viewData = viewData
        atmMachines.enqueue(self)
    }
    
    
    

}


class Customer:Thread{
    
    
    var cutting = DispatchSemaphore(value: 0)
    var model: Customer.Model
    
    
    @ObservedObject var viewData: ViewData
    
    init(model: Customer.Model, viewData: ObservedObject<ViewData>){
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
        
        DispatchQueue.main.async {
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
