// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract abc {
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