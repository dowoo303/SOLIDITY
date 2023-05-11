// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

// 저번시간 복습

contract Mapping {
    mapping(uint => uint) setNum;
    mapping(string => uint) strToNum;

    struct account {
        string name;
        uint number;
        address wallet;
    }

    // 이름을 넣으면 계정을 받을 수 있도록
    mapping(string => account) Account;

    account[] accounts;


    // accounts에 새로운 account를 추가하는 함수
    function setAccount(string memory _name, uint _number, address _wallet) public {
        accounts.push(account(_name, _number, _wallet));
    }

    // 특정 번호의 account 받아오기
    function getAccount(uint _n) public view returns(account memory) {
        return accounts[_n-1];
    }

    // 특정 지갑주소 반환
    function getWallet(uint _n) public view returns(address) {
        return accounts[_n-1].wallet;
    }

    // 모든 계정 배열 반환
    function getAccounts() public view returns(account[] memory) {
        return accounts;
    }

}


contract note {

    // 고정 배열, 무한 배열
    uint[10] ten;
    uint[] a;


    // 고정 배열의 원하는 자리에 숫자넣기
    function setTen(uint _num, uint _n) public {
        ten[_num-1] = _n;
    }

    uint count;

    // 고정 배열의 원하는 자리에 숫자넣기
    function setTen2(uint _n) public {
        ten[count++] = _n;
    }



    // 무한 배열에 숫자넣기
    function setA(uint _n) public {
        a.push(_n-1);
    }

    // 특정 번째 숫자 바꾸기
    function changeA(uint _n, uint _num) public {
        a[_n-1] = _num;
    }

    // ten의 숫자 모두 더하기
    function allAddTen() public view returns(uint) {
        uint add;
        for(uint i =0; i<ten.length; i++) {
            add += ten[i];
        }
        return add;
    }



}