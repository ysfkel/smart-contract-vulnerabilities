
1. Use the transfer function when sending ether 
   to external contracts. The transfer function only sends 2300 gas with external call
   which is not enogh for the desitination address / contract to reenter the sending contract

2. checks-effects-interactions pattern; Ensure All logic that changes state variables happens before external call , this is known as checks-effects-interactions pattern.
