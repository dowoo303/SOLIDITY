// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*
실습가이드
1. 1번 지갑 준비(주소 복붙) -> setOwner, 2번 지갑 준비(주소 복붙) -> setA
2. deploy 후 1번 지갑으로 10eth -> deposit()
3. contract 잔액 변화 확인
4. 1번 지갑 넣고, 1000000000000000000 transferTo() -> 1번지갑, contract 잔액 변화 확인
5. 2번 지갑, 1000000000000000000, transferTo() -> 2번 지갑, contract 잔액 변화 확인

0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
*/

contract morning {
    address a;              // 2번 지갑(payable 아님 -> 그럼에도 transfer을 하면 돈을 받을 수 있다 -> 그것이 가능한 이유는 transferTo의 인풋값에 payable 있기 떄문
    address payable owner;  // 1번 지갑(payable)

    function deposit() public payable returns(uint){    // 특정 스마트 컨트랙트가 돈을 받을 수 있게 해줌. 내가 함수를 실행시켜서 돈을 보냄
        return msg.value;
    } 


    receive() external payable{}    // 받는 사람이 컨트랙트면 실행되는 함수(돈을 받는 함수) - 함수의 이름이 붙어서옴(결과값 To앞에) -> 만약 없는 함수 호출이면 fallback으로

    fallback() external payable{}   // 오류가 발생했을 때 부르는 함수(예외처리)

    function setOwner() public {
        owner = payable(msg.sender);        // msg.sender: 거래를 일으키는 사람
    }

    function getOwner() public view returns(address payable) {
        return owner;
    }

    function setA() public {
        a = payable(msg.sender);
    }

    function getA() public view returns(address) {
        return a;
    }

    function transferTo(address payable _to, uint _amount) public {
        _to.transfer(_amount); // 지갑주소.transfer(규모)
    }

    function transferToOwner(uint _amount) public {
        owner.transfer(_amount);
    }

    /*function transferToA(uint _amount) public {
        a.transfer(_amount);
    }*/
}


// 핵심: 스마트 컨트랙트가 돈을 가지고 있을 수 있다
// 컨트랙트지갑(CA), 일반계정(EOA)
