Race Conditions / Front running

The combination of external calls to other contracts and the multiuser nature of the underlying blockchain gives rise to a variety of potential Solidity pitfalls whereby users race code execution to obtain unexpected states. Reentrancyis one example of such a race condition. In this sectionwe willdiscussotherkindsofraceconditionsthatcanoccuron the Ethereum blockchain. There are a variety of good posts on this subject, including “RaceConditions”ontheEthereumWiki,#7ontheDASPTop10of2018,andthe Ethereum Smart Contract Best Practices.

As with most blockchains,Ethereum nodes pool transactions and form them in to blocks. The transactions are only considered valid once a miner has solved a consensus mechanism (currently Ethash PoW for Ethereum).
The miner who solves the block also chooses which transactions from the pool will be included in the block, typically ordered by the gasPrice of each transaction. Here isa potential attack vector. A n attacker can watch the transaction pool for transactions that may contain solutions to problems,and modify or revoke the solver’s permissions or change state in a contract detrimentally to the solver. The attacker can then get the data from this transaction and create a transaction of their own with a higher gas Price so their transaction is included in a block before the original. #MasteringEthereum