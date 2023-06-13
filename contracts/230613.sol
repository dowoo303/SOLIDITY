// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract A {
    function a() public view returns(address) {
        return msg.sender;      // 0번 지갑 주소
    }

    function b() public view returns(address) {
        return address(this);      // A컨트랙트 주소 
    }

    function c() public view returns(address) {
        return tx.origin;   // 가장 처음 동작시킨 사람 반환(0번 지갑 주소)
    }
}

contract B {
    A c_a;

    constructor(address _a) {
        c_a = A(_a);
    }

    function a() public view returns(address) {
        return c_a.a();     // B컨트랙트 주소
    }

    function b() public view returns(address) {
        return c_a.b();     // A컨트랙트 주소
    }

    function c() public view returns(address) {
        return c_a.c();     // 0번 지갑 주소
    }



}