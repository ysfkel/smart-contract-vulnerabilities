pragma solidity 0.7.5;

contract UncheckedCallReturn {
   
   bool public payedOut = false;
   address public winner;
   uint public winAmount;
   function sendToWinner() public {
       require(!payedOut);
       //VULNERABILITY ALERT!
       //Send fail is not handled
       /**
       Whenever possible, use the transfer function 
       rather than send, as transfer will revert if the external transaction reverts.
        If send is required, always check the return value.

        A more robust recommendation is to adopt awithdrawal pattern.
        */
       winner.send(winAmount);
       payedOut = true;
   }

   function withdrawLeftOver() public {
       require(payedOut);
       msg.sender.send(this.balance);
   }

}