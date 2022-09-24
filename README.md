
# The ATM Problem
Project for N1 - Operatinal Systems taught by [Prof.Dr.Fernando Parente Garcia](http://lattes.cnpq.br/2634131135774711) - Computer Engineering 2nd year - [Federal Institute of Science & Technology of Ceará - Fortaleza Campus](https://ifce.edu.br/fortaleza) - 2022.2


## Analysis
Inspired by the classic semaphores synchronization problem

### Sleeping Barber com m customers and n barbers 

Imagine a hypothetical barbershop with m barber chair and a waiting room with n chairs (n may be 0) for waiting customers. The following rules apply:

- If there are no customers, the barber falls asleep in the chair
- A customer must wake the barber if he is asleep
- If a customer arrives while all barbers is working, the costumers waits til one is avaible
- When the barber finishes a haircut, he inspects the waiting room to see if there are any waiting customers and falls asleep if there are none


### Pseudocode

```

Barbers Thread Queue  - fb
Customers Thread Queue - fc

Semaphore customers = 0
Semaphore barber = 0
Semaphore mutex = 1


class Barber {
    init{
        fb.enqueue(self)
    }
    func run(){
        loop infinito{
            
            down(customer)
            down(mutex)
            
            client = waitingQueues.dequeue() //pick a client 
            
            up(barber)
            up(mutex)
            
            // wait for the client to finish
            
            down(client.cutting)
            
        }
    }
}


class Customer{
    semaforo cutting = 1
    
    func run(){
        
        
        loop infinito{
            
            down(mutex);
            if(fc.size < fb.disponiveis.size){ /
                
                fc.enqueue(self)
                up(customers)
                up(mutex)
                down(barber)
                
                //realize the action
                
                up(cutting) //send a signal to barber to finish
                
            }else{
                up(mutex)
            }
        }
    }
    
}




````
## Solution

[VIDEO] 


### IOS particularities

#### DispatchQueue.global

Returns the global system queue with the specified quality-of-service class.

```Swift

DispatchQueue.global(qos:).async{

}

DispatchQueue.global(qos:).asyncAfter(deadline:){ //execute after a delay

}

```

- UserInteractive： 
System will give more resources for this setting, it should be used for the task which relates to UI, animation, etc.
- UserInitialed： 
This setting is for some time you want to prevent the user from actively using your app.
- Default： 
Have lower priority than UserInteractive and UserInitialed. if you have not set any QoS, then QoS will be this case.
- Utility： 
For some task that doesn’t need user to track.
- Background： 
When you need to maintain or clean up the task you create.

#### DispatchQueue.main

The dispatch queue associated with the main thread of the current process. Used to updates the view content in background

```Swift

/*
function returns control to the current queue only after the task is finished. It blocks the queue and waits until the task is finished.
*/

DispatchQueue.main.async{

}

/*
Function returns control to the current queue right after task has been sent to be performed on the different queue. It doesn't wait until the task is finished. It doesn't block the queue.
*/

DispatchQueue.main.sync{ 

}

```
#### DispatchSemaphore

An object that controls access to a resource across multiple execution contexts through use of a traditional counting semaphore.

```Swift

let semaphore = DispatchSemaphore(value: 3)

semaphore.wait()
semaphore.signal()

```

## Resources

- [Sleeping barber problem on Wikipedia](https://en.wikipedia.org/wiki/Sleeping_barber_problem#:~:text=In%20computer%20science%2C%20the%20sleeping,are%20multiple%20operating%20system%20processes.)
- [http://lasdpc.icmc.usp.br/](http://lasdpc.icmc.usp.br/~ssc640/grad/ec2015/sleeping_barber/code.html)
- [http://www.cs.csi.cuny.edu/](http://www.cs.csi.cuny.edu/~yumei/csc718/homework2/homework2solution.pdf)
- [The Beauty of Semaphores in Swift by Roy Kronenfeld](https://medium.com/@roykronenfeld/semaphores-in-swift-e296ea80f860)
- [DispatchSemaphore by Apple Developer Documentation](https://developer.apple.com/documentation/dispatch/dispatchsemaphore)
- [iOS-Introducing DispatchQueue in Swift by Gordon Feng](https://towardsdev.com/ios-introducing-dispatchqueue-in-swift-e9c6fbf8be1d)
- [Difference between DispatchQueue.main.async and DispatchQueue.main.sync? on Stackoverflow](https://stackoverflow.com/questions/44324595/difference-between-dispatchqueue-main-async-and-dispatchqueue-main-sync)




