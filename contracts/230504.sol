// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*
실습가이드
1. 1 -> push, 2 -> push, 3 -> push, 4 -> push
2. getLength 해보기 -> 4 확인
3. getNumber -> 1,2,3,4 각각 해보기 -> 각각 1,2,3,4 확인
4. pop 해보기
5. getLength 해보기 -> 3확인
6. getNumber -> 1,2,3,4 각각 해보기 -> 각각 1,2,3, 오류 확인
7. deleteNum -> 2 해보기
8. getNumber -> 2 해보기 -> 0 확인
9. changeNum -> 2,5 해보기
10. getNumber -> 2 해보기 -> 5 확인 
*/

contract StringAndBytes {
    string a;

    function setString(string memory _a) public {
        a = _a;
    }

    function getString() public view returns(string memory) {
        return a;
    }

    // string을 bytes로 바꿔보기
    function stringToBytes() public view returns(bytes memory) {
        return bytes(a);
    }

    function stringToBytes2() public view returns(bytes1, bytes1, bytes1) {
        return (bytes(a)[0], bytes(a)[1], bytes(a)[2]);     // 61,62,63으로 bytes는 아스키코드 두자리씩 끊긴다
    }

    // bytes1은 용량이 정해진 정적변수고 string은 동적변수이기 때문에 맞춰주기 위해 bytes1대신 bytes사용
    function bytesToString(bytes memory _a) public pure returns(string memory) {
        return string(_a);
    }

    // _a의 첫번째 글자를 byte형태로 뽑아내기
    function bytesToString2(string memory _a) public pure returns(bytes1) {
        bytes memory _b = bytes(_a);    // _b에 _a의 bytes 형변환 정보 대입
        return _b[0];   // _b는 bytes로 동적이지만 _b[0]는 정적이기 때문에 위 returns의 반환은 bytes memory가 아니라 bytes1여야 한다.
    }

    // _a의 첫번째 글자를 string형태로 뽑아내기
    function bytesToString3(string memory _a) public pure returns(string memory) {
        bytes memory _b = new bytes(1);     // _b를 한자리짜리 bytes로 설정한다.
        _b[0] = bytes(_a)[0];
        return string(_b);
    }
    
    // _a의 n번째 글자를 string형태로 뽑아내기
    function bytesToString4(string memory _a, uint _n) public pure returns(string memory) {
        bytes memory _b = new bytes(1);
        _b[0] = bytes(_a)[_n-1];
        return string(_b);
    }

}

// uint array
contract Array {
    // array = 같은 자료형들이 들어있는 집합
    uint[] numbers;
    string[] letters;

    // 1. 넣기
    function push(uint _a) public { // 상태변수를 변경시키기때문에 view or pure 사용안함
        numbers.push(_a);
    }

    // 2. 빼기
    function pop() public {
        numbers.pop();
    }

    // 3. 보기
    function getNumber(uint _a) public view returns(uint) { // 상태변수를 변경시키지는 않지만 보고는 옴
        return numbers[_a-1]; // 배열이름(n번째)
    }


    // 4. 길이
    function getLength() public view returns(uint) {
        return numbers.length;
    }
    

    // 5. 바꾸기
    function changeNum(uint _k, uint _z) public {
        numbers[_k-1] = _z;
    }

    // 6. 삭제
    function deleteNum(uint _n) public {
       delete numbers[_n]; // 삭제된 숫자는 사라지는 것이 아니라 0으로 변경됨 -> 길이는 유지됨
    }

    // 7. 전체 array 반환
    function returnArray() public view returns(uint[] memory) {
        return numbers;
    }
}


// string array
contract Array_s {
    // array = 같은 자료형들이 들어있는 집합
    string[] letters; // 자료형 [] array 이름

    // 1. 넣기
    function push(string memory _a) public {
        letters.push(_a); // 배열이름.push(변수)
    }

    // 2. 빼기
    function pop() public {
        letters.pop(); // 배열이름.pop(), 맨뒤의 숫자를 날림
    }

    // 3. 보기
    function getLetter(uint _n) public view returns(string memory) {
        return letters[_n-1]; // 배열이름[_n번째]
    }

    // 4. 길이
    function getLength() public view returns(uint) {
        return letters.length; //배열이름.길이
    }

    // 5. 바꾸기
    function changeLet(uint _k, string memory _z) public {
        letters[_k-1] = _z; //배열이름[_k번째] = _z -> _k번째를 _z로 바꿔
    }

    // 6. delete 
    function deleteLet(uint _n) public {
        delete letters[_n-1]; // delete 배열이름[_n번째] = _n번째 숫자를 없애줘
    }

    //7. 전체 array 반환
    function returnArray() public view returns(string[] memory) {
        return letters;
    }
}


// Struct: 여러 타입의 자료들을 모음
contract Struct {
    // struct Student {
    //     string name;
    //     uint number;
    // }   // 구조체 선언: struct 구조체명 {}

    // Student s;      // Student형 변수 s 선언

    // function setStudent(string memory _name, uint _number) public {
    //     s = Student(_name, _number);
    // }

    // function getStudent() public view returns(Student memory) {
    //     return s;
    // }

    // 퀴즈: 이름, 성별, 번호, 생년월일을 가진 학생 구조체를 만들고 학생형 s라는 변수를 선언하시오. 
    // 그 후에, s에 값을 넣는 함수와 s의 값을 반환하는 함수를 만드세요.
    struct Student {
        string name;
        string gender;
        uint number;
        uint birth;
    }

    Student s;
    Student[] students; // Student형 변수들의 array -> students

    function setStudent(string memory _name, string memory _gender, uint _number, uint _birth) public {
        s = Student(_name, _gender, _number, _birth);
    }

    function getStudent() public view returns(Student memory) {
        return s;
    }

    function pushStudent(string memory _name, string memory _gender, uint _number, uint _birth) public {
        students.push(Student(_name, _gender, _number, _birth));        // 배열명.push(구조체명(구조체 정보들))
    }

    function popStudent() public {
        students.pop();
    }

    function getLength() public view returns(uint) {
        return students.length;
    }

    function getStudent(uint _n) public view returns(Student memory) {
        return students[_n-1];
    }

    function getStudents() public view returns(Student[] memory) {
        return students;
    }

}

// 함수의 이름이 같아도 되는 경우는 input의 갯수가 다를때 뿐이다
contract Errors {
    uint a;

    function add(uint _a, uint _b) public pure returns(uint) {
        return _a+_b;
    }

    /*
    function add(uint _a, uint _b) public returns(uint) {
        a = a + _a + _b;
        return a;
    }

    function add(uint _a, uint _b) public view returns(uint) {
        return a+_a+_b;
    }

    function add(uint _a, uint _c) public pure returns(uint) {
        return _a+_c;
    }

    function add(uint _a, uint _b) public pure returns(uint, uint) {
        return (_a+_a, _a+_b);
    }
    */

    function add(uint _a, uint _b, uint _c) public pure returns(uint) {
        return _a+_b+_c;
    }

    function add2() public pure returns(uint) {
        uint c = 5;
        uint d = 7;
        return c+d;
    }

}


contract repeat {
    // 이름, 번호, 생년월일을 담은 student라는 구조체와 제목, 번호, 날짜를 담은 class라는 구조체를 선언하시오.
    struct student {
        string name;
        uint number;
        uint birth;
    }
    
    struct class {
        string title;
        uint number;
        uint date;
    }

    // student형 변수 s 와 class형 변수 c를 선언하시오.
    student s;
    class c;

    // s에 값을 부여하는 함수 setS와 c에 값을 부여하는 함수 setC를 각각 구현하시오
    function setS(string memory _name, uint _number, uint _birth) public {
        s = student(_name, _number, _birth);
    }

    function setC(string memory _title, uint _number, uint _date) public {
        c = class(_title, _number, _date);
    }


    // 변수 s의 값을 반환받는 함수 getS와 c의 값을 반환받는 함수 getC를 각각 구현하시오.
    function getS() public view returns(student memory) {
        return s;
    }

    function getC() public view returns(class memory) {
        return c;
    }


    // student형 변수들이 들어가는 array students와 class형 변수들이 들어가는 array classes를 선언하시오.
    student[] students;
    class[] classes;


    // students에 student 구조체를 넣는 pushStudent 함수를 구현하세요.
    function pushStudent(string memory _name, uint _number, uint _birth) public {
        students.push(student(_name, _number, _birth));
    }
    // classes에 class 구조체를 넣는 pushClass 함수를 구현하세요.
    function pushClass(string memory _title, uint _number, uint _date) public {
        classes.push(class(_title, _number, _date));
    }



}


contract repeat2 {
    // 숫자형 변수 a, 문자형 변수 b, bytes2형 변수 c를 담은 구조체 D를 선언하세요.
    struct D {
        uint a;
        string b;
        bytes2 c;
    }

    // D형 변수 dd를 선언하세요.
    D dd;

    // dd에 값을 부여하는 setDD함수를 구현하세요.
    function setDD(uint _a, string memory _b, bytes2 _c) public {
        dd = D(_a, _b, _c);
    }


    // D형 변수들이 들어가는 array Ds를 선언하세요.
    D[] Ds;


    // Ds에 새로운 D형 변수를 넣는 pushD 함수를 구현하세요.
    function pushD(uint _a, string memory _b, bytes2 _c) public {
        Ds.push(D(_a, _b, _c));
    }


    function pushD2() public {
        Ds.push(dd);
    }


    // dd의 값을 반환하는 getDD 함수를 구현하세요
    function getDD() public view returns(D memory) {
        return dd;
    }
    
    // Ds array의 n번째 요소를 반환받는 getN이라는 함수를 구현하세요.
    function getN(uint _n) public view returns(D memory) {
        return Ds[_n-1];
    }

}