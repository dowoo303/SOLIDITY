// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Mapping {
    mapping (uint => uint) a;
    mapping (string => uint) b; // string을 넣으면 uint라는 value가 나옴
    mapping (bytes => uint) c;

    function setB(string memory _s, uint _n) public {
        b[_s] = _n;     // _s라는 string에다가 _n라는 값을 넣어줘
    }

    function getB(string memory _key) public view returns(uint) {
        return b[_key];
    }

    function setC(bytes memory _key, uint _value) public {
        c[_key] = _value;
    }

    function getC(bytes memory _key) public view returns(uint) {
        return c[_key];
    }


    struct Student {
        uint number;
        string name;
        string[] classes;
    }

    // 선생님을 입력하면 학생이 나오도록 mapping
    mapping(string => Student) Teacher_Student;

    function setTeacher_Student(string memory _Teacher, uint _number, string memory _name, string[] memory _classes) public {
        Teacher_Student[_Teacher] = Student(_number, _name, _classes);
    }

    function getTeacher_Student(string memory _Teacher) public view returns(Student memory) {
        return Teacher_Student[_Teacher];
    }


}

contract note {
    struct Student {
        uint number;
        string name;
        string[] lecture;
    }

    mapping (string => Student) Teacher;
    

    function setTeacher_Student(string memory _teacher, uint _number, string memory _name, string[] memory _lecture) public {
        Teacher[_teacher] = Student(_number, _name, _lecture);
    }

    function getTeacher_Student(string memory _teacher) public view returns(Student memory) {
        return Teacher[_teacher];
    }


    // array 형태
    mapping (string => Student[]) Teacher_class;

    function setTeacher_Class(string memory _teacher, uint _number, string memory _name, string[] memory _lecture) public {
        Teacher_class[_teacher].push(Student(_number, _name, _lecture));
    }

    function getTeacher_Class(string memory _teacher) public view returns(Student[] memory) {
        return Teacher_class[_teacher];
    }

}


contract For {
    function forLoop() public pure returns(uint){
        uint a;

        for(uint i=1; i<6; i++ /*시작점; 끝점; 변화방식*/) {
            a = a+i; // a+=i
        }

        return a;
    }

    function forLoop2() public pure returns(uint, uint){
        uint a;
        uint i;

        for(i=1; i<6; i++ /*시작점; 끝점; 변화방식*/) {
            a = a+i;
        }

        return (a,i);
    }

    function forLoop3() public pure returns(uint, uint) {
        uint a;
        uint i;

        for(i=1;i<=5; i++) {
            a=a+i;
        }

        return (a,i);
    }

    uint[4] c;
    uint count;

    function pushA(uint _n) public {
        c[count++] = _n;
    }

    function getA() public view returns(uint[4] memory) {
        return c;
    }

    function forLoop4() public view returns(uint) {
        uint a;
        for(uint i=0;i<4;i++) {
            a += c[i];
        }

        return a;
    }

    function forLoop5() public view returns(uint) {
        uint a;
        for(uint i=0; i<c.length;i++) {
            a=a+c[i];
        }

        return a;
    }

    uint[] d;
    
    function pushd(uint _n) public {
        d.push(_n);
    }

    function getD() public view returns(uint[] memory) {
        return d;
    }

    function forLoop6() public view returns(uint) {
        uint a;
        for(uint i=0;i<d.length;i++) {
            a=a+d[i];
        }

        return a;
    }


}

contract fixedArray {
    /*
    실습 가이드
    0. getALength(), getA(), getBLength(), getB() 결과 확인하기
    1. 1 -> pushA, 2 -> pushA, 3,4 진행
    2. getA(), getALength() 해보기
    3. 1 -> pushB2, 3-> pushB2, 5,7, 진행
    4. getB(), getBLength() 해보기

    ----------------------
    초기화 한 후,
    0. getBLength(), getB() 해보기
    1. 1 -> pushB2() 한 후에, getBLength(), getB() 해보기
    2. 초기화 후, 1 -> pushB3() 한 후에, getBLength(), getB() 해보기
    3. 1번 결과 2번 결과 비교해보기
    */

    
    uint[] a;
    uint[4] b;  // fixed array: array 길이제한

    function getALength() public view returns(uint) {
        return a.length;
    }

    function pushA(uint _n) public {
        a.push(_n);
    }

    function getA() public view returns(uint[] memory) {
        return a;
    }

    function getBLength() public view returns(uint) {
        return b.length;
    }

    // 길이가 정해진 array(fixed array)인 경우 push를 사용하여 값을 입력시킬 수 없다
    // n+1번째에 _n값 입력
    function pushB(uint n, uint _n) public {
        b[n] = _n;
    }

    
    function getB() public view returns(uint[4] memory) {   // 길이가 정해진 fixed array임에도 memeory 붙여야됨
        return b;
    }

    uint count;

    function pushB2(uint _n) public {
        b[count++] = _n;
    }

}

