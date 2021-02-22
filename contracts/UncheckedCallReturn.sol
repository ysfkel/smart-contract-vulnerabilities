pragma solidity 0.7.5;

contract UncheckedCallReturn {
   
   bool public payedOut = false;
   address public winner;
   uint public winAmount;
   function sendToWinner() public {
       require(!payedOut);
       //VULNERABILITY ALERT!
       //Send fail is not handled
       winner.send(winAmount);
       payedOut = true;
   }

   function withdrawLeftOver() public {
       require(payedOut);
       msg.sender.send(this.balance);
   }

}