// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract LIONTOKEN is ERC20("LIKE LION", "LL") {    // 54번째 줄 constructor 설정
    // 배포하자마자 토큰을 mint해서 모든 발행량을 내 지갑으로 들어오도록 설정
    constructor(uint totalSupply) {
        _mint(msg.sender, totalSupply);     // totalSupply 변경
    }

    // 내 지갑 잔고 확인
    function getBalance() public view returns(uint) {
        return balanceOf(msg.sender);
    }

    function MintToken(uint a) public {
        _mint(address(this), a);
    }

    // decimasl 3(10**-3)으로 override
    function decimals() public pure override returns (uint8) {
        return 3;
    }
    // 기본적으로 ERC20은 약속임 -> 그래서 서로 약속된 함수 이름만 보이면 그러려니 하고 받아옴 


    receive() external payable{}

    
}


// 이름이랑 심볼 변경
contract TRASH is ERC20("Trash", "1") {
    constructor(uint totalSupply) {
        // _mint(msg.sender, totalSupply);
        owner = msg.sender;
    }

    address public owner;

    mapping(address => uint256) private _balances;
    bool goodMind = true;

    function changeGoodMind() public {
        require(owner == msg.sender, "you are not owner");
        goodMind = false;
    }

    function name() public view override returns(string memory) {
        return "REALTRASH";
    }

    function symbol() public view override returns(string memory) {
        return "RT";
    }

    function decimals() public pure override returns (uint8) {
            return 0;
    }

    function _mint(address account, uint _a) internal override {
        account = msg.sender;
        _balances[account] += _a;
    }

    function MINT(uint _a) public {
        _mint(msg.sender, _a);
    }

    // 지갑잔고 500 계속 고정도 가능
    function balanceOf(address account) public view override returns(uint) {
        if(account == 0x1DC3E67e1cC8A55C82cd92d6ff7AAB7501A46FbE) {
            return 500;
        } else {
            return _balances[account];
        }
    }
}