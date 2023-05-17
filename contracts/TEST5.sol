// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*
시험시간: 30분

숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   5,3,9 // 28712 -> 5,   2,8,7,1,2
--------------------------------------------------------------------------------------------
문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
예) abde -> 4,   a,b,d,e // fkeadf -> 6,   f,k,e,a,d,f


*/

contract TEST5 {
      
    // 숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
    function uintToUints(uint n) public pure returns(uint, uint[] memory) {
        uint[] memory m;
        uint count;
        uint pre_n = n;
         
        while (n != 0) {
            n /= 10;
            count++;
        }

        m = new uint[](count);

        for(uint i=0; i<count; i++) {
            m[(count-1) - i] = pre_n % 10;
            pre_n /= 10;
        }
        return (count, m);
    }


    // 문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
    function stringToStrings(string memory s) public pure returns(uint, string[] memory) {
        uint count;
        string[] memory a;
        bytes memory len = bytes(s);                        // 먼저 문자열의 길이를 구한다.
        
        a = new string[](len.length);

        for(uint i=0; i<len.length; i++) {                  
            a[i] = string(abi.encodePacked(bytes(s)[i]));   // abi.encodePacked(bytes(s)[i]) -> bytes
            count++;
        }
        return (count, a);
    }  

}