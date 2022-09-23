//
//  ContentView.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 23/09/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewData:ViewData = ViewData()
    
    
    func runThread(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.global(qos:.background).asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
    
    var body: some View {
        
        VStack{
            Section(content: {
                
                List{
                    
                    ForEach(self.viewData.atms, id: \.id) { atms in
                        VStack(alignment: .leading){
                            Text(atms.idString)
                            Text(atms.stateDescription)
                        }
                        
                    }
                    
                    Button {
                        
                       
                        let model = ATMModel()
                        
                        DispatchQueue.main.async {
                            viewData.atms.append(model)
                        }
                        runThread(0.5) {
                            ATMThread(model: model, viewData: _viewData).run()
                        }
                       
                        
                    } label: {
                        Text("Adicionar")
                    }
                }
               
                
     
            }, header: {
                Text("Bancos - \(self.viewData.atms.count)")
            })
            
            Section(content: {
                
                List{
                    ForEach(self.viewData.customers, id: \.id) { customers in
                        VStack(alignment: .leading){
                            Text(customers.idString)
                            Text(customers.stateDescription)
                        }
                    }
                    
                    Button {
                        
                        
                        let model = CustomerModel(tempoAtendimento: 10)
                        
                        DispatchQueue.main.async {
                            viewData.customers.append(model)
                        }
                       
                        
                        runThread(0.5) {
                            CustomerThread(model: model, viewData: _viewData).run()
                        }
                        
                        
                    } label: {
                        Text("Adicionar")
                    }
                }
                
            }, header: {
                Text("Clientes - \(self.viewData.customers.count)")
            })
        }
        .padding().onAppear{
            DispatchQueue.global(qos:.background).async {
                while true{
                    
                    DispatchQueue.main.async {
                        viewData.customers = viewData.customers.filter{$0.state != .Atendido}
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
