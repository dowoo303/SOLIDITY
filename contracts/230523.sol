// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import './230523_2.sol';       // import './위치/파일명';
import './d/dd.sol';

contract A {
    B_SmartContract b = new B_SmartContract();
    D_Conrtact d_con = new D_Conrtact();

    function add(uint _a, uint _b) public view returns(uint) {
        return b.add(_a,_b);
    }

    function multi(uint _a, uint _b) public view returns(uint) {
        return d_con.multiply(_a,_b);
    }
}