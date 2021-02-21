pragma solidity 0.7.5; 

contract TimeLockOverFlow {
   
    mapping(address => uint) public balances; 
    mapping(address => uint) public lockTime;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        //
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        /* 
          vulnerability alert! 
          Attacker can determine the current time and call this function 
          with a value for _secondsToIncrease equal 2 ^ 256 
          causing an overflow in the users locktTime resetting it to 0
          then call withdraw to withdraw the money 
        */
        lockTime[msg.sender] += _secondsToIncrease;
    }
}