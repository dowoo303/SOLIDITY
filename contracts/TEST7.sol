// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*
시험시간: 35분

숫자를 시분초로 변환하세요.
예) 100 -> 1분 40초, 600 -> 10분, 1000 -> 16분 40초, 5250 -> 1시간 27분 30초

*/

contract hourMinSec {

    modifier limit(uint _time) {
        require(_time<86400, "Time cannot exceed 86400");
        _;
    }

    function trans(uint time) public limit(time) pure returns(uint, uint, uint) {
        uint hour = time / 60 / 60;
        uint min = time / 60 % 60;
        uint sec = time % 60;

        return (hour, min ,sec);
    }
}

contract CONCAT {
    // 문자열 두개 합쳐서 출력하기
    function concat1(string memory a, string memory b) public pure returns(string memory) {
        return string(abi.encodePacked(a,b));
    }

    // concat을 이용하면 문자열을 쉽게 붙일 수 있다.
    function concat2(string memory a, string memory b) public pure returns(string memory) {
        return string.concat(a,":",a,b,":",b);
    }

    // a는 아스키코드로 변환되어 출력된다
    function concat3(uint a, string memory b, string memory c) public pure returns(string memory) {
        return string(abi.encodePacked(a,b,c));
    }

    // bytes 출력 테스트
    function returnEncodePacked(uint a, string memory b) public pure returns(bytes memory, bytes memory) {
        return (abi.encodePacked(a), abi.encodePacked(b));      // bytes 뒤에 uint 붙음, 문자열은 16진수로 표현됨(아스키 코드)
    }

    // +48을 해서 숫자 한자리 수들 문자형으로 표현해보기
    function concat4(uint a, uint b, uint c) public pure returns(string memory) {
        a += 48;
        b += 48;
        c += 48;
        return string(abi.encodePacked(a,b,c));
    }


    Q5 q5 = new Q5();

    // 한자리수는 +48로 문자형 표현이 가능하지만 두자리 수 이상은 아스키코드 변환이 힘들기 때문에 
    // 각 자리 수를 쪼개서 +48을 해준 후 다시 숫자배열을 abi.encodePacked를 통해 통합 후 출력
    function concat5(uint a) public view returns(string memory) {
        uint b = q5.getLength(a);
        uint[] memory c = new uint[](b);
        c = q5.divideNumber(b);
        for(uint i=0; i<c.length; i++) {
            c[i] += 48;
        }
        return string(abi.encodePacked(c));
    }

    // 123, ab를 넣었을 때 123ab로 출력시켜보기
    function concat6(uint a, string memory b) public view returns(string memory) {
        return string(abi.encodePacked(concat5(a),b));
        
    }
}







contract Q7 {
    function setTime(uint _n) public pure returns(uint, uint, uint) {
        uint hour = _n/3600 ;
        uint minute = (_n%3600)/60 ; // min = (_n/60)%60;
        uint second = _n%60 ;
        return(hour, minute, second);
    }
}

contract Q5 {
    function divideNumber(uint _n) public pure returns(uint[] memory) {
        uint[] memory b = new uint[](getLength(_n));

        uint i=getLength(_n);
        while(_n !=0) {
            b[--i] = _n%10;
            _n = _n/10;
        }
        return (b);
    }

    function getLength(uint _n) public pure returns(uint) {
        if(_n==0) {
            return 1;
        }

        uint a;
        while(_n >= 10**a) {
            a++;
        }
        return a;
    }
}

contract CONCAT2 {
    Q5 q5 = new Q5();
    Q7 q7 = new Q7();

    function concat(uint a) public view returns(string memory) {
        uint b = q5.getLength(a);
        uint[] memory c = new uint[](b);
        c = q5.divideNumber(a);
        for(uint i=0; i<c.length; i++) {
            c[i] += 48;
        }
        return string(abi.encodePacked(c));
    }

    function getConcat(uint _n) public view returns(string memory) {
        return string(abi.encodePacked(concat(_n), "hours"));
    }

    function concat6(uint _n) public view returns(uint, uint, uint /*string memory*/) {
        (uint a, uint b, uint c) = q7.setTime(_n);
        return (a,b,c);
    }

    function concat7(uint _n) public view returns(string memory) {
        (uint a, uint b, uint c) = q7.setTime(_n);
        return string(abi.encodePacked(concat(a),"hours ", concat(b), "minutes ", concat(c), "seconds"));
    }
}