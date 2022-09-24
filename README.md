# Problema Do Banco
Trabalho para N1 da disciplina Sistemas Operacionais do Curso de Engenharia de Computação - 2022.2 

### Análise
Inspirado no clássico de sincronização com semáforos:  

#### Sleeping Barber com m customers and n barbers 

Imagine a hypothetical barbershop with m barber chair and a waiting room with n chairs (n may be 0) for waiting customers. The following rules apply:

- If there are no customers, the barber falls asleep in the chair
- A customer must wake the barber if he is asleep
- If a customer arrives while all barbers is working, the costumers waits til one is avaible
- When the barber finishes a haircut, he inspects the waiting room to see if there are any waiting customers and falls asleep if there are none


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

#### DispatchQueue.global

```Swift

DispatchQueue.global(qos:).async{

}

```

- UserInteractive： System will give more resources for this setting, it should be used for the task which relates to UI, animation, etc.
- UserInitialed： This setting is for some time you want to prevent the user from actively using your app.
- Default： Have lower priority than UserInteractive and UserInitialed. if you have not set any QoS, then QoS will be this case.
- Utility： For some task that doesn’t need user to track.
- Background： When you need to maintain or clean up the task you create.


