pragma solidity 0.7.5;

library SafeMath {

     function add(uint256 a,uint256  b) public pure returns(uint256) {
         uint256 c = a + b;
         assert(c >= a);
         return c;
     }

}