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

    // 점수에 따른 학점 물어보기
    function setGrade(uint _score) public pure returns(string memory) {     // 모든것을 지역변수로 커버가 가능하기 떄문에 prue
        if(_score >=50) {
            return "P";
        } else {
            return "F";
        }
    }

    // 점수가 70점 이상이면 A, 50점 이상이면 B, 아니면 C반
    function setGrade2(uint _score) public pure returns(string memory) {
        if(_score >= 70) {
            return "A";
        } 
        else if(_score >= 50) {
            return "B";
        } else {
            return "C";
        }
    }


    // 짝수면 even array에, 홀수면 odd array에 넣어보기
    uint[] even;
    uint[] odd;

    function evenOrOdd(uint _n) public {        // 상태변수를 변조시킴(public)
        if(_n % 2 == 0) {
            even.push(_n);
        } else {
            odd.push(_n);
        }
    }

    function getEvenAndOdd() public view returns(uint[] memory, uint[] memory) {
        return (odd, even);
    }


    // 3으로 나누었을 때 나머지가 1이면 A, 2이면 B, 0이면 C
    uint[] A;
    uint[] B;
    uint[] C;

    function ternary(uint _n) public {
        if(_n % 3 == 1) {
            A.push(_n);
        } else if(_n % 2 == 2) {
            B.push(_n);
        } else {
            C.push(_n);
        }
    }

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

    function getStudents() public view returns(student[] memory) {
        return Students;
    }

    function setGrades(uint _score) public pure returns(string memory _credit) {
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