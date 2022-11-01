//
//  Model.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 23/09/22.
//

import Foundation


extension ATM{
    enum State {
        case Sleeping
        case Attending
    }

}


extension Customer{
    enum State{
        case Sleeping
        case BeingAttended
        case Attended
    }
}



extension ATM{
    class Model{
        
        
        var id: UUID
       
        var idString: String{
            get{
                return "\(self.id.uuidString.prefix(5))"
            }
        }
        
        var state:ATM.State
        
        var stateDescription: String{
            get{
                switch state{
                    case .Attending:
                    if let clienteAtual = clienteAtual{
                        return "Attending - Customer(\(clienteAtual.idString)) - \(clienteAtual.tempoAtual)s"
                    }else{
                        return "Attending - Client(NOT DEFINED) "
                    }
                   
                case .Sleeping:
                    return "Sleeping"
                }
            }
        }
        var clienteAtual: Customer.Model?
        
        init(){
            self.id = UUID()
            self.state = .Sleeping
            self.clienteAtual = nil
        }
    }
}


extension Customer{
    
    class Model{
        
        var id: UUID
       
        var idString: String{
            get{
                return "\(self.id.uuidString.prefix(5))"
            }
        }
        
        var tempoAtendimento: Int
        var tempoAtual: Int
        var state:Customer.State
        
        var stateDescription: String{
            get{
                switch state{
                    
                case .Sleeping:
                    return "Sleeping - \(tempoAtendimento)s"
                case .BeingAttended:
                    return "Being Attended - \(tempoAtual)s"
                case .Attended:
                    return "Attended"
                }
            }
        }
        
        init(tempoAtendimento: Int){
            self.id  = UUID()
            self.state = .Sleeping
            self.tempoAtendimento = tempoAtendimento
            self.tempoAtual = 0
        }
        
        static var DATAFORMOCK = Customer.Model(tempoAtendimento: 10)
    }
}

