// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract LIONTOKEN is ERC20("LIKE LION", "LL") {    // 54번째 줄 constructor 설정

    // 배포하자마자 토큰을 mint해서 모든 발행량을 내 지갑으로 들어오도록 설정
    constructor(uint _totalSupply) {
        _mint(msg.sender, _totalSupply);
    }

    // 내 지갑 잔고 확인
    function getBalance() public view returns(uint) {
        return balanceOf(msg.sender);
    }

}