pragma solidity 0.7.5;

/**
 The user who can find the preimage 
 can submit the solution and retrieve the 1,000 ether. 
 Assuming some user figures out the solution is Ethereum!.
 They call solve with Ethereum! as the parameter.
 An attacker has been clever enough to
 watch the transaction pool for any one submitting a solution.

 They see this solution, check its validity, and then submitan equivalent transaction with a much higher gas Price than the 
 original transaction.The miner who solves the block will likely give the attacker preference due to the higher gasPrice,
 and mine their transaction before the originalsolver’s.The attacker will take the 1,000 ether,and the user who solved the problem 
 In mind that in this type of “front-running” vulnerability,
 miners are uniquely incentivized to run the attacks themselves (or can be bribed to run these attacks with extravagant fees).
  The possibility of the attacker being a miner themselves should not be underestimated.

  Preventive Techniques:
  There are two classes of actors who can perform these kinds offront-running attacks:
  users (who modify the gasPrice of their transactions) 
  and miners
  miners can only perform the attack when they solve a block , which is unlikely for any individual 
  miner targeting a specific block .

  1.One method is to place an upper bound on the gasPrice.This prevents users from increasing the gasPrice and getting
  preferential transaction ordering beyond the upper bound. This measure only guards against the first class of attackers (arbitrary users) .
  Miners in this scenario can still attack the contract, as they can order the transactions in their block however they like, 
  regardless of gas price.

  2. A more robust method is to use a commit–reveal scheme. Such a scheme dictates that users send transactions with hidden information
  (typically a hash). After the transaction has been included in a block, the user sends a transaction revealing the data that was 
  sent (the reveal phase). This method prevents both miners and users from front-running transactions, as they cannot determine the contents of the transaction.
  This method, however, cannot conceal the transaction value ( which in some cases is the valuable information that needs to be hidden). 
  The ENS smart contract allowed users to send transactions whose committed data included the amount of ether they were willing to spend.
  Users could then send transactions of arbitrary value. During the reveal phase, users were refunded the difference between 
  the amount sent in the transaction and the amount they were willing to spend. #MasteringEtheruem
 */
contract FindThisHash {

    bytes32 constant public hash =  0xb5b5b97fafd9855eec9b41f74dfb6c38f5951141f9a3ecd7f44d5479b630ee0a;

    constructor() {}

    function solve(string solution) external {
        require(hash == sha3(solution));
        msg.sender.transfer(100 ether);
    }
}