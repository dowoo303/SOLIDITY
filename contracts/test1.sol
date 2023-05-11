// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

// 시험시간: 40분

// 여러분은 선생님입니다. 학생들의 정보를 관리하려고 합니다. 
    // 학생의 정보는 이름, 번호, 점수, 학점 그리고 듣는 수업들이 포함되어야 합니다.

    // 번호는 1번부터 시작하여 정보를 기입하는 순으로 순차적으로 증가합니다.

    // 학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.

    // 필요한 기능들은 아래와 같습니다.

    // * 학생 추가 기능 - 특정 학생의 정보를 추가
    // * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    // * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    // * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    // * 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    // * 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    // * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    // * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    // * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    // -------------------------------------------------------------------------------
    // * S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)

    // 기입할 학생들의 정보는 아래와 같습니다.

    // Alice, 1, 85
    // Bob,2, 75
    // Charlie,3,60
    // Dwayne, 4, 90
    // Ellen,5,65
    // Fitz,6,50
    // Garret,7,85
    // Hubert,8,90
    // Isabel,9,100
    // Jane,10,70


// 번호 1번부터 부여

contract test {
    struct student {
        string name;
        uint number;
        uint score;
        string grade;
        string[] classes;
    }

    student[] teacher;


    function grade(uint _n) public pure returns(string memory) {
        if(_n >= 90) {
            return "A";
        } else if (_n >= 80) {
            return "B";
        } else if (_n >= 70) {
            return "C";
        } else if (_n >= 60) {
            return "D";
        } else {
            return "F";
        }
    }

    // 추가
    function setStudnet(string memory _name, uint _score, string[] memory _classes) public {
        teacher.push(student(_name, teacher.length+1, _score, grade(_score), _classes));
        name_student[_name] = student(_name, teacher.length, _score, grade(_score), _classes);
    }

    // 조회1
    function getStudent(uint _n) public view returns(student memory) {
        // for(uint i=0; i<teacher.length; i++) {
        //     if(teacher[i].number == _n) {
        //         return teacher[i];
        //     }
        // }

        return teacher[_n-1];   // 번호가 1번부터 부여됨

    }



    mapping(string => student) name_student;

    // * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    function getStudent2(string memory _name) public view returns(student memory) {
        // for(uint i=0; i<teacher.length; i++) {
        //     if(keccak256(bytes(teacher[i].name)) == keccak256(bytes(_name))) {
        //         return teacher[i];
        //     }
        // }
        return name_student[_name];
    }

    // * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    function getNameScore(string memory _name) public view returns(uint) {
        // for(uint i=0; i<teacher.length; i++) {
        //     if(keccak256(bytes(teacher[i].name)) == keccak256(bytes(_name))) {
        //         return teacher[i].score;
        //     }
        // }
        return name_student[_name].score;
    }


    // 학생 전체 숫자 조회 기능
    function getNumber() public view returns(uint) {
        // for(uint i=0; i<teacher.length; i++) {
        //     return teacher[i].number;
        // }
        return teacher.length;
    }

    // 학생 전체 정보 조회
    function getStudentAll() public view returns(student[] memory) {
        return teacher;
    }

    // 학생들의 전체 평균 점수 반환
    function averageScore() public view returns(uint) {
        uint av;
        for(uint i=0; i<teacher.length; i++) {
            av += teacher[i].score;
        }
        return (av/teacher.length);
    }

    // 선생 지도 평가
    function teacherEvaluation() public view returns(bool) {
        uint ev;
        for(uint i=0; i<teacher.length; i++) {
            ev += teacher[i].score;
        }

        if(ev/teacher.length >=70) {
            return true;
        } else {
            return false;
        }
    }


    // 보충반 - 배열로 출력 어케함
    function getF() public view returns(uint, student memory) {
        for(uint i=0; i<teacher.length; i++) {
            if(keccak256(bytes(teacher[i].grade)) == keccak256(bytes("F"))) {
                return(teacher[i].score, teacher[i]);
            }
        }
    }

    // S반 조회 기능
    function s() public view returns(student[4] memory) {
        student[4] memory s_class;

        for(uint i=0; i<teacher.length; i++) {
            for(uint z=0; z < s_class.length; z++) {
                if(teacher[i].score > s_class[z].score) {
                    for (uint k = 3; k > z; k--) s_class[k] = s_class[k-1] ;
                    s_class[z] = teacher[i] ;
                    break;
                }
            }
        }
        return s_class;

    }


}


// 선생을 뭘로 선언해야하는거지 ? mapping? 배열? -> 둘 다 사용해야됨
// 여러개 반환 어케함 ? -> 당연히 배열로 return 해주면 된다




contract QUIZ1_answer {
    // 학생의 정보는 이름, 번호, 점수, 학점 그리고 듣는 수업들
    struct Student {
        string name;
        uint number;
        uint score;
        string credit;
        string[] classes;
    }

    Student[] students;

    // 학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.
    function setCredit(uint _score) public pure returns(string memory) {
        if(_score >=90) {
            return "A";
        } else if(_score >=80) {
            return "B";
        } else if(_score >=70) {
            return "C";
        }else if(_score >=60) {
            return "D";
        }else {
            return "F";
        }
    } 

    // * 학생 추가 기능 - 특정 학생의 정보를 추가
    // 번호는 1번부터 시작하여 정보를 기입하는 순으로 순차적으로 증가합니다.
    function pushStudent(string memory _name, uint _score, string[] memory _classes) public {
        students.push(Student(_name, /*count++*/ students.length+1, _score, setCredit(_score), _classes));
        name_Student[_name] = Student(_name, students.length, _score, setCredit(_score), _classes);
    }

    //* 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    function getStudentsNumber() public view returns(uint) {
        return students.length;
    }

    //* 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    function getAllStudents() public view returns(Student[] memory) {
        return students;
    }

    // * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    function getStudent(uint _number) public view returns(Student memory) {
        return students[_number-1];
    }

    mapping(string => Student) name_Student;
    // * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    function getStudent2(string memory _name) public view returns(Student memory) {
        return name_Student[_name];
    }

    // * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    function getStudentScore(string memory _name) public view returns(uint) {
        return name_Student[_name].score;
    }

    // * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    function getAverage() public view returns(uint) {
        uint totalScore;
        for(uint i=0; i<students.length; i++) {
            totalScore = totalScore + students[i].score; // totalScore += students[i].score
        }

        return totalScore / students.length; // totalScore / getStudentsNumber() -> 똑같이 작동하는지 확인
    }

    // * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    function selfEva() public view returns(bool) {
        if(getAverage() >= 70) {
            return true;
        } else {
            return false;
        }
    }

    // * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    function FClass() public view returns(uint, Student[] memory) {
        uint num;   // F학점 학생수

        // F_studetns를 지역변수가 아니라 밖에다 선언하면 이런 번거러운 과정을 피할 수는 있지만 가스비가 증가한다.
        Student[] memory F_students = new Student[](num);  // num만큼의 크기 할당      

        for(uint i=0; i<students.length; i++) {
            if(keccak256(bytes(students[i].credit)) == keccak256(bytes("F"))) {
                // F_students[num] = students[i];  // 사이즈를 정해주지않으면 push가 불가능 -> 근데 또 사이즈를 정해주면(fixed array) 당연히 push를 못함
                num++;
            }
        } // num 구하는 for loop

        uint _num;
        for(uint i=0; i<students.length; i++) {
            if(keccak256(bytes(students[i].credit)) == keccak256(bytes('F'))) {
                F_students[_num] = students[i];
                _num++;
            }
        }
    }
    // 목표는 두번 갔다오는거 ok 근데 둘다 못하는 이유는 뭐냐 첫번째로 애시당초 선언을 했을 때 길이가 몇인지를 몰라서 동적으로 적어줌 
    // 근데 길이를 동적으로 적었기때문에 동적인 길이가 정확히 몇인지 알기 전까지는 선언 불가능 
    // 그래서 그 안에 넣고 빼고를 못해
    // 그러면 우리가 할 수 있는건 두가지 방법인데
    // 1. 아무길이 설정하고 그 길이에 도달하면 길이를 늘려주는거
    // 2. 새로운애가 생길 때마다 하나씩 하나씩 늘려주는거 
    // 2.1에서 중요한건 길이를 늘려주면 어떤게 문제일까(new선언하고나서) 가장 큰 문제는 기존에 있는 정보들이 날라가버림(new로 해버리면) 
    // 그럼 기존에 있던 애들을 잠시 어디에 뒀다가 가져와야한다.
    // 그런 다음에 길이를 늘렸다가 저장해둔 아이를 새롭게 길이를 늘린 애한테 다시 봔환해주면 됨.





    // * S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)


}



contract  String_Compare {
    // encodePacked
    function keccak1(string memory s1) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(s1));
    }

    function keccak2(string memory s1) public pure returns(bytes32) {
        return keccak256(bytes(s1));
    }

    // 문자열 비교방법
    function compare1(string memory s1, string memory s2) public pure returns(bool) {
        return keccak256(bytes(s1)) == keccak256(bytes(s2));
    }

    // encodePacked 한 것도 자료형이 bytes임
    function compare2(string memory s1) public pure returns(bytes memory, bytes memory) {
        return (abi.encodePacked(s1), bytes(s1));
    }
}