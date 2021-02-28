There are a number of ways of performing external calls i n Solidity. 
Sending ether to external accounts is commonly performed via the transfer method . However,
the send function can also be used, and for more versatile external calls the CALL opcode can be directly employed in Solidity.
The call and send functions return a Boolean indicating whether the call succeeded or failed. Thus, these functions have a simple caveat, in that the transaction that executes these functions will not revert ifthe external call (intialized by call or send) fails; rather,the functions will simply return false.A common error is thatthe developer expects a revert to occur ifthe external callfails,and does not check the return value.

<address>.transfer 
  sends given amount of wei to address .
  reverts (throws exeption) on failure , forwards 2300 gas stipend , not adjustable
  safe against re-entrancy
  should be used in most cases

<address>.send 
  sends given amount of wei to address .
  returns false on failure , forwards 2300 gas stipend , not adjustable
  safe against re-entrancy
  use when you want to handle failure in contract

  <address>.call 
 issues low level call with given payload
 returns success condition (true of false)
 forwards all available gas 
 not  safe against re-entrancy
 should be used when you want to control gas sent