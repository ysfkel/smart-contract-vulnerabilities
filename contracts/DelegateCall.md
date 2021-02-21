# CALL and DELEGATE call 
Both used for external calls to smart contract. 
Call runs in the context of the called contract 
DELEGATECALL opcode runs in the contexts of the CALLER (preserves context) contract
therefore msg.sender and msg.value remain unchanged .

DELEGATECALL enables implmentation of library contracts 

DELEGATECALL can lead to unexpected code execution.

The code in libraries themselves can be secure and vulnerability-free; however,when runin the context ofanother app lication new vulnerabilities canarise. Let’s see a fairly 
complex example of this, using Fibonacci numbers.
