// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract C {
    // 숫자를 문자형으로 표현
    function UtoS(uint _n) public pure returns(string memory) {     // 라이브러리는 pure 사용 가능
        return Strings.toString(_n);
    }
}