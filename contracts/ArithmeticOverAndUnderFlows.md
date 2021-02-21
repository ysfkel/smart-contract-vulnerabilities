Ethereum, Solidity and integer overflows: programming blockchains like 1970
(https://randomoracle.wordpress.com/2018/04/27/ethereum-solidity-and-integer-overflows-programming-blockchains-like-1970/)

Anover/underflowoccurswhenanoperationisperformedthatrequiresafixed size variable to store a n u m b e r (or piece of data) that is outside the range of the variable’s data type

For example , subtracting 1 from a uint8 (unsigned integer of 8 bits; i.e., non negative) variable whose value is 0 will result in the number 255. This is a n underflow.

Adding numbers larger than the data type’s range results in an overflow. For
clarity, adding 257 to a uint8 that currently has a value of 0 will result in the number1

These kinds of numerical gotchas allow attackers to misuse code and create unexpected logic flows.
