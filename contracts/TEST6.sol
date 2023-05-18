// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*

안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
안건들을 모아놓은 자료구조도 구현하세요.

사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

* 사용자 등록 기능 - 사용자를 등록하는 기능
* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
* 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
* 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
* 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70% 그리고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각

*/


contract TEST6 {
    // 안건
    struct paper {      
        uint number;
        string title;
        string content;
        address proposer;
        uint agree;
        uint disagree;
    }

    // 안건들을 모아놓은 자료구조도 구현하세요. (array mapping)
    mapping(string => paper) paperList;

    // 투표할 유저들
    struct User {
        string name;
        address account;
        paper[] myPaper;      // 자신이 만든 안건
        paper[] complete;       // 자신이 투표한 안건
        mapping(string => bool) choiced;
    }

    // * 사용자 등록 기능 - 사용자를 등록하는 기능
    mapping(address => User) userList;

    function setUser(string memory name) public {
        userList[msg.sender].name = name;
        userList[msg.sender].account = msg.sender;
    }

    // * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function vote(string memory _title, bool _choice) public {
        if(_choice == true) {
            // 찬성에 투표를 했다면   
            paperList[_title].agree +=1;        // 안건 동의자수 1 증가
            userList[msg.sender].complete.push(paperList[_title]);      // 유저정보에 투표한 안건 추가
        } else {
            // 반대에 투표를 했다면
            paperList[_title].disagree +=1;
            userList[msg.sender].complete.push(paperList[_title]);    
        }
    }

    // * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    // * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    // * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능


}