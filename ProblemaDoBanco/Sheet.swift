//
//  Sheet.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 24/09/22.
//

import SwiftUI

struct Sheet: View {

    @State var model: Customer.Model = .init(tempoAtendimento: 0)
    @State var tempo: String = ""
    var completion: ((Customer.Model?) -> ())
    
    var body: some View {
        List{
            Section {
                
                HStack{
                    Text("ID:")
                    Text("\(self.model.idString)")
                }
                
                HStack{
                    Text("Service Time:")
                    TextEditor(text: $tempo).keyboardType(.numberPad)
                }
                
                
            } header: {
                Text("Data")
            }

            Section {
                Button("Register") {
                    let tempoSec = Int(tempo)
                    
                    if let tempoSec = tempoSec{
                        model.tempoAtendimento = tempoSec
                        completion(model)
                    }else{
                        completion(nil)
                    }
                }
            }
        }
    }
}

struct Sheet_Previews: PreviewProvider {
    static var previews: some View {
        Sheet(model: Customer.Model.DATAFORMOCK){ i in
            print(i)
        }
    }
}
