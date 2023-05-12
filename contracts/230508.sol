// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Address {
    // address는 20byte짜리 정적변수
    // address라는 형의 변수가 따로 존재
    address a;      

    function getAddress() public view returns(address) {    
        return address(this);       // 컨트랙트 주소
    }


    function getMyAddress() public view returns(address) {
        return address(msg.sender);     // 내 지갑 주소
    }

    function getMyBalance() public view returns(uint) {
        return address(msg.sender).balance;     // 실제 잔고와 약간 차이가 존재함
    }

    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }


    function setA(address _a) public {
        a = _a;
    }

    // bytes20으로 선언시 길이만 같을 뿐 형이 다르기 때문에 오류 발생
    // function setA2(bytes20 _a) public {
    //     a = _a;
    // }

    function getA2() public view returns(bytes20) {
        return bytes20(a);
    }

    function getA() public view returns(address) {
        return a;
    }
}


contract Mapping {
    mapping(uint => uint) a;    // key-value 쌍이 숫자-숫자로 연결되어 있는 mapping a
    mapping(uint => string) b;  // string이 알고 싶음
    mapping(string => address) c;   // address가 알고 싶음


    // 이중 mapping(ex) 3반에 있는 alice의 점수)
    mapping(uint => mapping(string => uint)) score;


    // 이름을 검색하면 그 아이의 키를 반환받는 contract를 구현
    mapping(string => uint) height;


    // mapping에 정보 넣기(이름과 키 입력)
    function setHeight(string memory _name, uint _h) public {
        height[_name] = _h; // mapping이름[key 값] = value값
    }

    // mapping에 정보 가져오기(이름을 입력하면 키 불러오기)
    function getHeight(string memory _name) public view returns(uint) {
        return height[_name];   // mapping이름[key값]
    }

    // 정보 삭제
    function deleteHeight(string memory _name) public {
        delete height[_name];
    }
}