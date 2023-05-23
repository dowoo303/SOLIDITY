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
        uint[] memory m;    // 지역변수 배열은 push 불가능!
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
        string[] memory a;
        bytes memory len = bytes(s);    // 먼저 문자열의 길이를 구한다.
        
        a = new string[](len.length);

        for(uint i=0; i<len.length; i++) {                  
            a[i] = string(abi.encodePacked(bytes(s)[i]));   // abi.encodePacked(bytes(s)[i]) -> bytes !TEST1참고!
        }
        return (len.length, a);
    }  

}


contract Answer {
    function dividenNumber(uint _n) public pure returns(uint, uint[] memory) {
        uint a = getLength(_n);
        uint[] memory b = new uint[](a);        // fixed한 상태로 만들기

        uint i=a;
        while(_n != 0) {
            b[--i] = _n%10;
            _n = _n/10;
        }
        return (a,b);
        
    }

    function getLength(uint _n) public pure returns(uint) {
        uint a;
        while(_n > 10**a) {
            a++;
        }
        return a;
    }

}


// 조건문을 설정하기 애매할 때 while을 사용 -> 특정조건을 만족할 때까지 반복해야할 경우
contract While {
    function while1(uint _n) public pure {
        uint ab;
        while(_n < ab) {
            ab++;
        }
    }

    uint[] public a;
    function while_2(uint _n) public returns(uint[] memory) {
        while(a.length <_n) {
            a.push(a.length+1);
        }
        return a;
    }

    function while_3(uint _n) public pure returns(uint) {
        uint _a;
        while(_n > 10**_a) {
            _a++;
        }
        return _a;
    }
}


contract ReversArray {
    function reverse(uint[] calldata numbers) public pure returns(uint[] memory) {
        uint[] memory _reverse = new uint[](numbers.length);
        for(uint i=0; i<numbers.length; i++) {
            _reverse[i] = numbers[numbers.length-i-1];
        }
        return _reverse;
    }


    // 동시스왑으로 reverse하기
    function reverse2(uint[] memory numbers) public pure returns(uint[] memory) {
        for(uint i=0; i<numbers.length/2; i++) {
            (numbers[i], numbers[numbers.length-i-1]) = (numbers[numbers.length-i-1], numbers[i]);
        }
        return numbers;
    }
}


contract Bytes_Length {
    // 1
    function getLength1(bytes1 a) public pure returns(uint) {
        return a.length;
    }

    // 2
    function getLength2(bytes2 a) public pure returns(uint) {
        return a.length;
    }

    // 3
    function getLength3(bytes3 a) public pure returns(uint) {
        return a.length;
    }

    // 넣는 만큼
    function getLength4(bytes memory a) public pure returns(uint) {
        return a.length;
    }

    // 정적인 bytes1을 동적인 string으로 변환하는법
    function bytes1ToString(bytes1 a) public pure returns(string memory) {
        string memory _a = string(abi.encodePacked(a));     
        return _a;
    }

    // bytes배열을 쪼개서 각 bytes1의 배열로 나누기
    function bytestoBytesArray(bytes memory _bytes) public pure returns(bytes1[] memory) {
        bytes1[] memory _bytes1 = new bytes1[](_bytes.length);
        for(uint i=0; i<_bytes1.length; i++) {
            _bytes1[i] = _bytes[i];     // bytes는 특별한 배열인걸 잊지말자
        }
        return _bytes1;
    }

    // 문자열을 입력하고 문자열을 각각 쪼개서 받아보기
    function stringToBytes1Array(string memory _a) public pure returns(uint, string[] memory, string memory) {
        bytes1[] memory a = new bytes1[](bytes(_a).length);     // 길이만큼 자리 배정
        a = bytestoBytesArray(bytes(_a));
        
        string[] memory s_array = new string[](a.length);

        for(uint i=0; i<s_array.length; i++) {
            s_array[i] = string(abi.encodePacked(a[i]));
        }

        return (s_array.length, s_array, string(abi.encodePacked(a)));  
    }
    // 위 abi.encodePacked(a)를 이용하면 1bytes들을 입력받아서 하나의 단어 묶음으로 낼 수도 있다
}


