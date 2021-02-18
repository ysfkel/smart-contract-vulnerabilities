pragma solidity 0.7.5;

contract PreventReentrancy{

    bool reEntrancyMutext = false ;
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawalTime; 
    mapping(address => uint256) public balances; 

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint _weiToWithdraw) public {
        require(!reEntrancyMutext);
        require(balances[msg.sender] >= _weiToWithdraw);

        require(_weiToWithdraw <= withdrawalLimit);

        require(block.timestamp >= lastWithdrawalTime[msg.sender] + 1 weeks);

        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawalTime[msg.sender] = block.timestamp;

        reEntrancyMutext = true;
        msg.sender.transfer(_weiToWithdraw);
        reEntrancyMutext = false;
    }
}