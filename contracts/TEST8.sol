// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
시험시간: 35분

자리수랑 숫자가 같아야함

로또 프로그램을 만드려고 합니다. 숫자와 문자는 각각 4개 2개를 뽑습니다. 
6개가 맞으면 1이더, 5개의 숫자 혹은 문자가 순서와 함께 맞으면 0.75이더, 4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

참가 금액은 0.05이더이다.

기준 숫자 : 1,2,3,4,A,B
-----------------------------------------------------------------
기준 숫자 설정 기능 : 5개의 사람이 임의적으로 4개의 숫자와 2개의 문자를 넣음. 5명이 넣은 숫자들의 중앙값과 알파벳 순으로 따졌을 때 가장 가운데 문자로 설정
예) 숫자들의 중앙값 : 1,3,6,8,9 -> 6 // 2,3,4,8,9 -> 4
예) 문자들의 중앙값 : a,b,e,h,l -> e // a,h,i,q,z -> i 

*/


contract lotto {
    function lottoGame(uint a, uint b, uint c, uint d, string memory e, string memory f) public payable returns(string memory) {
        require(msg.value == 0.05 ether, "give me 0.05eth !");

        a += 48;
        b += 48;
        c += 48;
        d += 48;

        return string(abi.encodePacked(a,b,c,d,e,f));

        // 6개
        if(keccak256(bytes(string(abi.encodePacked(a,b,c,d,e,f)))) == keccak256(bytes("1234AB"))) {
            payable(msg.sender).transfer(1 ether);
        } 
        // 5개
        if(keccak256(bytes(string(abi.encodePacked(a,b,c,d,e)))) == keccak256(bytes("1234A")) && keccak256(bytes(string(abi.encodePacked(b,c,d,e,f)))) == keccak256(bytes("234AB"))) {
            payable(msg.sender).transfer(0.75 ether);
        }
        
    }
}