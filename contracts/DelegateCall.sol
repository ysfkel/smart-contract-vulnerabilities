pragma solidity 0.7.5; 


/**
  You may have noticed that the state variable start is used in both the library and them a in calling contract. 
  In the library contract, start is used to specify the beginning of the Fibonacci sequence and isset to 0,whereas 
  itisset to 3 in thecallingcontract.You may alsohavenoticedthatthefallbackfunctioninthe FibonacciBalance contract 
  allows all calls to be passed to the library contract, which allows for the setStart function of the library contract to be called.
  Recalling that we pre serve the state of the contract ,it may seem that this function would allow you to change the state of the start 
  variable in the local Fibonnacci Balance contract . If so, this would allow one to withdraw more ether, as the resulting calculated 
  Fib Number is dependent on the start variable (as seen in the library contract). the setStart function does not
   (and cannot) modify the start variable in the FibonacciBalance contract (different slots in both contracts). 
   The underlying vulnerability in this contract is significantly worse than just modifying the start variable.

   Incorrect State variables mapping between FibonacciBalance and Fibonacci

   The Fibonacci has two state variables , start and calculatedFibNumber.The first variable,start,is stored in th econtract’s storageatslot[0]
   (i.e.,the first slot).The secondvariable, calculatedFibNumber, is placed in the next available storage slot, slot[1]

    FibonacciBalance contract.Storage slot[0] now corresponds to the fibonacci contract address, 
   and slot[1] corresponds to calculatedFibNumber. It is in this incorrect mapping that the vulnerability occurs

   Preventive Techniques:
   provides the library keyword for implementing library contracts (see the docs for further details). 
   This ensures the library contract is stateless a n d non-self-destructable.
    Forcing libraries to be stateless mitigates the complexities of storage context demonstrated in this section. Stateless libraries also prevent attacks wherein attackers modify the state of the library directly in order to affect the contracts that depend on the library’s code. As a general rule of thumb, w h e n using DELEGATECALL pay careful attention to the possible calling context of both the library contract and the calling contract, and whenever possible build stateless libraries.

 */

contract Fibonacci {

    uint public start; 
    uint public calculatedFibNumber;

    function setStart(uint _start) public {
        start = _start;
    }

    function setFibonacci(uint n) public  {
         calculatedFibNumber = fibonacci(n);
    }

    function fibonacci(uint n) internal returns(uint) { 
        if(n==0) return start;
        else if(n==1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n -2 );
    }
}

contract FibonacciBalance {
   address public fibonacci;

   uint public calculateFibNumber;
   /* 
     vulnerability ALERT
     the callee contract places start in the first storage slot slot[0]
     while here it is the third storage slot[2]
   */
   uint public start = 3;

   uint public withdrawCunter;
   bytes4 constant fibSig = bytes4(keccak256("setFibonacci"));

   constructor(address _fibonacci)  {
       fibonacci = _fibonacci;
   }

   function withdraw() {
       withdrawCunter += 1;
       require(fibonacci.delegatecall(fibSig,withdrawCunter ));
       msg.sender.transfer(calculatedFibNumber * 1 ether);
   }

   receive() external payable {
       /**
         VULNERABILITY ALERT!!
         Any one can call any function on fibonacci
        */
       require(fibonacci.delegatecall(msg.data));
   }


}


// 2 VULNERABLE WALLET 

contract WalletLibrary {
     address owner;

     // called by constructor
     function initWallet(address _owner) {
         owner = _owner;
         // ... more setup ...
     }

     function changeOwner(address _new_owner) external {
         if (msg.sender == owner) {
             owner = _new_owner;
         }
     }

     function () payable {
         // ... receive money, log events, ...
     }

     function withdraw(uint amount) external returns (bool success) {
         if (msg.sender == owner) {
             return owner.send(amount);
         } else {
             return false;
         }
     }
}

contract Attack  { 
    uint storageSlot0; 
    uint storageSlot1;

    function() public { 
        storageSlot1 = 0;
        //<attacker_address>.transfer(this.balance);
    }
    

}
