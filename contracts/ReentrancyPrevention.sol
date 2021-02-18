pragma solidity 0.7.5;

contract PreventReentrancy{

    bool reEntrancyMutext = false ;
    uint256 public withdrawalKimit = 1 ether;
    mapping(address => uint256) public lastWithdrawalTime; 
    mapping(address => uint256) public balances; 

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }
}