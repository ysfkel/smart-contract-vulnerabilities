pragma solidity 0.7.5; 

import {SafeMath} from "./SafeMath.sol";



contract TimeLockOverFlow {
    using SafeMath for uint;
   
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

       /* 
          Prevent Overflow by using add function of SafeMath library
        */
    function safeDeposit() public payable {
        balances[msg.sender].add(msg.value);
        //
        lockTime[msg.sender] = block.timestamp.add(1 weeks);
    }
      function safeIncreaseLockTime(uint _secondsToIncrease) public {
     
        lockTime[msg.sender].add(_secondsToIncrease);
    }
}

contract TokenBalanceUnderFlow {

    mapping(address => uint) balances;
    uint public totalSupply; 

    constructor(uint _intialSupply) {
      totalSupply = _intialSupply;
       balances[msg.sender] = _intialSupply;
    }

    /**
      Vulnerability ALERT!!
      The require statement can be bypassed by using an underflow 
      A user with 0 balance can call the function with a _value greater than 0 
      the subtraction will underflow and result in a value greater than 0, bypassing the require statemet.
      (balance is a uint256 and value is 0)
     */
    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balancesOf(address _owner) public view returns(uint balance) {
        return balances[_owner];
    }
}