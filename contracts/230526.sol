/**
 *Submitted for verification at Etherscan.io on 2023-05-23
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


// 이더스캔의 MethodID는 인풋값과 함수를 나타낸다
contract STUDENT {
    mapping(string => address) public walletList;

    function putMyWallet(string calldata _name, address _addr) public {
        walletList[_name] = _addr;
    }

    function showMyWallet(string calldata _name) public view returns(address) {
        return walletList[_name];
    }
}

// 함수를 구분하는 경우 3가지: 인풋값 갯수, 타입, 함수 이름
contract getFunctionID {
    function firstFourBytes(bytes20 _a) public pure returns(bytes4) {
        return bytes4(_a);
    }

    function getMethodID(string calldata _a) public pure returns(bytes4) {
        return bytes4(keccak256(bytes(_a))); // 앞뒤에 따옴표 이름(변수형,변수형)
    }
}