// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
시험시간: 30분

흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

입력값을 받으면 그 입력값 안에 대문자, 소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 알려주는 함수를 구현하세요.

*/


contract TEST10 {

    function passWord(string memory _a) public pure returns(bool) {
        bool bigWord;
        bool smallWord;
        bool number;

        bytes memory a = bytes(_a);
        
        for(uint i=0; i<a.length; i++) {
            if(65 <= uint8(bytes1(a[i])) && uint8(bytes1(a[i])) <= 90) {
                bigWord = true;
            }
            if(97 <= uint8(bytes1(a[i])) && uint8(bytes1(a[i])) <= 122) {
                smallWord = true;
            }
            if(48 <= uint8(bytes1(a[i])) && uint8(bytes1(a[i])) <= 57) {
                number = true;
            }
        }

        return (bigWord && smallWord && number);  
    }

}