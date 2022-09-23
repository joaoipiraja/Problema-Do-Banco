//
//  Model.swift
//  ProblemaDoBanco
//
//  Created by João Victor Ipirajá de Alencar on 23/09/22.
//

import Foundation


enum ATMState {
    case Dormindo
    case Atendendo
}

enum CustomerState{
    case Dormindo
    case SendoAtendido
    case Atendido
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
                case .Atendendo:
                return "Atendendo - Cliente(\(self.clienteAtual?.idString)) - \(self.clienteAtual?.tempoAtual)s"
            case .Dormindo:
                return "Dormindo"
            }
        }
    }
    var clienteAtual: CustomerModel?
    
    init(){
        self.id = UUID()
        self.state = .Dormindo
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
                
            case .Dormindo:
                return "Dormindo"
            case .SendoAtendido:
                return "Sendo Atendido - \(tempoAtual)s - \(tempoAtendimento)s"
            case .Atendido:
                return "Atendido"
            }
        }
    }
    
    init(tempoAtendimento: Int){
        self.id  = UUID()
        self.state = .Dormindo
        self.tempoAtendimento = tempoAtendimento
        self.tempoAtual = 0
    }
}
