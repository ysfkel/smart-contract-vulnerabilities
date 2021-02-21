pragma solidity 0.7.5;
contract VulnerabileEtherGame {
    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether;
    uint public finalReward = 5 ether;
    
    //for secure checks, use instead of this.balance
    uint public depositedWei;


    mapping(address => uint) redeemableEther;


    /**
      Vulnerability ALERT!
      The issues come from the poor Use of this.balance in the assignment to currentBalance
      and in the claimReward function. A mischievous attacker could forcibly send a 
      small amount of ether—say, 0.1 ether—via the selfdestruct (see the ForcingEtherOverFlow.md)
      function  to prevent any future players from reaching a milestone.
     */
    function vulnerablePlay() external payable {
        require(msg.value == 0.5 ether);
        uint currentBalance = address(this).balance + msg.value; 

        require(currentBalance <= finalMileStone);

        if(currentBalance == payoutMileStone1) {
            redeemableEther[msg.sender] += mileStone1Reward;

        } else if (currentBalance == payoutMileStone2) {
               redeemableEther[msg.sender] += mileStone2Reward;
        }
         else if (currentBalance == finalMileStone) {
               redeemableEther[msg.sender] += finalReward;
        }
        return;
    }

    function vulnerableClaimReward() public {
        require(address(this).balance == finalMileStone);
        require(redeemableEther[msg.sender] > 0);
        redeemableEther[msg.sender] = 0;
       // msg.sender.transfer(transferValue);

    }

      //
      function securePlay() external payable {
        require(msg.value == 0.5 ether);
        //replaced this.balance with depositedWei
        uint currentBalance = depositedWei + msg.value; 

        require(currentBalance <= finalMileStone);

        if(currentBalance == payoutMileStone1) {
            redeemableEther[msg.sender] += mileStone1Reward;

        } else if (currentBalance == payoutMileStone2) {
               redeemableEther[msg.sender] += mileStone2Reward;
        }
         else if (currentBalance == finalMileStone) {
               redeemableEther[msg.sender] += finalReward;
        }
        //new 
        depositedWei += msg.value;
        return;
    }

    function secureClaimReward() public {
        //replaced this.balance with depositedWei
        require(depositedWei == finalMileStone);
        require(redeemableEther[msg.sender] > 0);
        redeemableEther[msg.sender] = 0;
       // msg.sender.transfer(transferValue);

    }


}