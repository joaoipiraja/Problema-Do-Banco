//
//  Model.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 23/09/22.
//

import Foundation


enum ATMState {
    case Sleeping
    case Attending
}

enum CustomerState{
    case Sleeping
    case BeingAttended
    case Attended
}

class ATMModel{
    
    
    var id: UUID
   
    var idString: String{
        get{
            return "\(self.id.uuidString.prefix(5))"
        }
    }
    
    var state:ATMState
    
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
    var clienteAtual: CustomerModel?
    
    init(){
        self.id = UUID()
        self.state = .Sleeping
        self.clienteAtual = nil
    }
}

class CustomerModel{
    
    var id: UUID
   
    var idString: String{
        get{
            return "\(self.id.uuidString.prefix(5))"
        }
    }
    
    var tempoAtendimento: Int
    var tempoAtual: Int
    var state:CustomerState
    
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
    
    static var DATAFORMOCK = CustomerModel(tempoAtendimento: 10)
}
