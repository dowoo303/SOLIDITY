// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
시험시간: 30분

흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

입력값을 받으면 그 입력값 안에 대문자, 소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 알려주는 함수를 구현하세요.

*/


contract TEST10 {

     function bytestoBytesArray(bytes memory _bytes) public pure returns(bytes1[] memory) {
        bytes1[] memory _bytes1 = new bytes1[](_bytes.length);
        for(uint i=0; i<_bytes1.length; i++) {
            _bytes1[i] = _bytes[i];
        }
        return _bytes1;
    }

    function passWord(string memory _a) public returns(bool) {
        bool bigWord;
        bool smallWord;
        bool number;

        bytes1[] memory a = new bytes1[](bytes(_a).length);     // 길이만큼 자리 배정
        a = bytestoBytesArray(bytes(_a));
        

        for(uint i=0; i<a.length; i++) {
            if(abi.encodePacked(a[i]) <= abi.encodePacked(a[i]) && abi.encodePacked(a[i])<= 90) {
                bigWord = true;
            }
            if(97 <= abi.encodePacked(a[i]) && abi.encodePacked(a[i])<= 122) {
                smallWord = true;
            }
            if(48 <= abi.encodePacked(a[i]) && abi.encodePacked(a[i])<= 57) {
                number = true;
            }
        }

        return (bigWord && smallWord && number);  
    }

}