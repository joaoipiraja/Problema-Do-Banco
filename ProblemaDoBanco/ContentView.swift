//
//  ContentView.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 23/09/22.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var viewData:ViewData = ViewData()
    @State private var showingSheet: Bool = false
    

    
    func runThread(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.global(qos:.background).asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
    
    var body: some View {
        
        List{
            Section(content: {
                
                
                    
                    ForEach(self.viewData.atms, id: \.id) { atms in
                        VStack(alignment: .leading){
                            Text(atms.idString)
                            Text(atms.stateDescription)
                        }
                        
                    }
                    
                    Button {
                        
                        
                        let model = ATM.Model()
                        
                        DispatchQueue.main.async {
                            viewData.atms.append(model)
                        }
                        runThread(0.5) {
                            ATM(model: model, viewData: _viewData)
                        }
                        
                          
      
                    } label: {
                        Text("Add new one")
                    }
                
               
                
     
            }, header: {
                Text("ATM Machines - \(self.viewData.atms.count)")
            })
            
            Section(content: {
                
                
                    ForEach(self.viewData.customers, id: \.id) { customers in
                        VStack(alignment: .leading){
                            Text(customers.idString)
                            Text(customers.stateDescription)
                        }
                    }
                    
                    Button {
                        
                        showingSheet = true

                    } label: {
                        Text("Add new one")
                    }
                
                
            }, header: {
                Text("Customers - \(self.viewData.customers.count)")
            })
        }
        .sheet(isPresented: $showingSheet) {
            NavigationView {
                
                Sheet { model in
                    if let model = model{
                        
                        DispatchQueue.main.async {
                            viewData.customers.append(model)
                        }
                        runThread(0.5) {
                            Customer(model: model, viewData: _viewData).run()
                        }
                       
                    }
                    showingSheet = false
                }
               
            }
            
        }
       .onAppear{
            DispatchQueue.global(qos:.background).async {
                while true{
                    
                    DispatchQueue.main.async {
                        
                        
                       
                        viewData.customers = viewData.customers.filter{$0.state != .Attended}
                        
                        
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
