// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract repeat {
    struct student {
        string name;
        uint number;
        string[] classes;
    }

    student[] students;

    function setStudents(string memory _name, uint _number, string[] memory _classes) public {
        students.push(student(_name, _number, _classes));
    }

    function getStudents(uint _n) public view returns(student memory) {
        return students[_n-1];
    }

    function getStudentName(uint _n) public view returns(string memory) {
        return students[_n-1].name;
    }


    mapping (string => student[]) Teacher;

    function setTeacher(string memory _teacher, string memory _name, uint _number, string[] memory _classes) public {
        Teacher[_teacher].push(student(_name, _number, _classes));
    }

    function set2(string memory _teacher, uint _n, uint _number) public {
        Teacher[_teacher][_n-1].number = _number;
    }

    function get(string memory _teacher) public view returns(student[] memory) {
        return Teacher[_teacher];
    }
}

contract IF {
    struct student {
        uint number;
        string name;
        uint score;
        string credit;
    }

    student a;
    student b;
    student c;

    student[] Students;

    // 학생 정보 중 번호, 이름, 점수를 입력하면 학점이 자동 계산해주는 함수
    // 점수가 90점 이상이면 A, 80점 이상이면 B, 70점 이상이면 C, 나머지는 F
    function setAlice(uint _number, uint _score) public {
        string memory _credit;
        if(_score>= 90) {
            _credit = "A";
        } else if(_score >= 80) {
            _credit = "B";
        } else if(_score >= 70) {
            _credit = 'C';
        } else {
            _credit = 'F';
        }

        a = student(_number, "Alice", _score, _credit);
    }


    function setBob(uint _number, string memory _name, uint _score) public {
        string memory _credit;
        if(_score>= 90) {
            _credit = "A";
        } else if(_score >= 80) {
            _credit = "B";
        } else if(_score >= 70) {
            _credit = 'C';
        } else {
            _credit = 'F';
        }

        b = student(_number, _name, _score, _credit);
    }


    function setCharlie(uint _number, string memory _name, uint _score) public {
        string memory _credit;
        if(_score>= 90) {
            _credit = "A";
        } else if(_score >= 80) {
            _credit = "B";
        } else if(_score >= 70) {
            _credit = 'C';
        } else {
            _credit = 'F';
        }

        c = student(_number, _name, _score, _credit);
    }

    function getStudent() public view returns(student memory, student memory, student memory) {
        return (a, b, c);
    }


    function pushStudent(uint _number,string memory _name, uint _score) public {
        string memory _credit;
        if(_score>= 90) {
            _credit = "A";
        } else if(_score >= 80) {
            _credit = "B";
        } else if(_score >= 70) {
            _credit = 'C';
        } else {
            _credit = 'F';
        }

        Students.push(student(_number, _name, _score, _credit));
    }

    // setGrade 사용해서 간단히 구성해보기
    function pushStudents2(uint _number, string memory _name, uint _score) public {
        Students.push(student(_number, _name, _score, setGrade(_score)));
    }


    function getStudents() public view returns(student[] memory) {
        return Students;
    }

    function setGrade(uint _score) public pure returns(string memory _credit) {
        if(_score>= 90) {
            return 'A';
        } else if(_score >= 80) {
            return 'B';
        } else if(_score >= 70) {
            return 'C';
        } else {
            return "F";
        }
    }

}

contract IF2 {

    // and or 실습
    function setNumber(uint _n) public pure returns(string memory) {
        if(_n >= 50 || _n<=10) {
            return "A";
        } else if(_n>=50 && _n%3==0) {
            return "B";
        } else {
            return "C";
        }

        
    }
}


contract ENUM {
    enum Food { // enum 변수명 {변수1, 변수2, 변수3, 변수4}
        Chicken,    // - 결과값: 0, 디폴트 값
        Suish,      // - 결과값: 1
        Bread,      // - 결과값: 2
        Coconut     // - 결과값: 3
    }

    Food a;     // Food형 변수 선언
    Food b;
    Food c;

    function setA() public {
        a = Food.Chicken;
    }

    function setB() public {
        b = Food.Suish;
    }
    
    function setC() public {
        c = Food.Bread;
    }

    // 번호로도 부여가 가능하다
    function setC2(uint _n) public {
        c = Food(_n);
    }

    function getABC() public view returns(Food, Food, Food) {
        return(a,b,c);
    }

}

// ENUM 응용
contract ENUM2 {
    enum Status {
        neutral,
        high,
        low
    }
    Status st;

    uint a=5;

    function higher() public {
        a++;
        setA();
    }

    function lower() public {
        a--;
        setA();
    }

    function setA() public {
        if(a >= 7) {
            st = Status.high;
        } else if(a<= 3) {
            st = Status.low;
        } else {
            st = Status.neutral;
        }
    }


    function getA() public view returns(uint) {
        return a;
    }

    function getSt() public view returns(Status) {
        return st;
    }

}

