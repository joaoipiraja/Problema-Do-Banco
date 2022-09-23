# Problema Do Banco
Trabalho para N1 da disciplina Sistemas Operacionais do Curso de Engenharia de Computação - 2022.2 

### Análise
Inspirado no clássico de sincronização com semáforos:  

#### Sleeping Barber com m customers and n barbers 

A barbershop consists of a waiting room with n chairs and the barbers room containing m barbers chairs. If there are no customers to be served, the barber goes to sleep. If a customer enters the barbershop and all chairs are occupied, then the customer leaves the shop. If the barber is busy but chairs are available, then the customer sits in one of the free chairs. If the barber is asleep, the customer wakes up the barber.


### Pseudocódigo

```

Fila de Thread de Barbers - fb
Fila de Thread de Customers - fc

Semaforo customers = 0
Semaforo barber = 0
Semaforo mutex = 1


class Barber {
    init{
       fb.enqueue(self)
    } 
    func run(){
        loop infinito{
        
            down(customer)
            down(mutex)
            
            client = waitingQueues.dequeue()
            
            up(barber)
            up(mutex)
            
            //espera o cliente finalizar 
            
            down(client.cutting)

        }
    }
}


class Customer{
 semaforo cutting = 1
 
 func run(){
 
 
 loop infinito{
 
 down(mutex);
        if(fc.size < fb.disponiveis.size){
        
            fc.enqueue(self)
            up(customers)
            up(mutex)
            down(barber)
            
            //Realiza a ação
            up(cutting)
            
        }else{
          up(mutex)
        }
   }
 }
 
}
````

### Particularidades de Swift
