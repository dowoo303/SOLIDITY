// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

// 시험시간: 30분

/*여러분은 검색 엔진 사이트에서 근무하고 있습니다. 
고객들의 ID와 비밀번호를 안전하게 관리할 의무가 있습니다. 
따라서 비밀번호를 rawdata(있는 그대로) 형태로 관리하면 안됩니다. -> 케칵256
비밀번호를 안전하게 관리하고 로그인을 정확하게 할 수 있는 기능을 구현하세요. -> key-value로 mapping?

아이디와 비밀번호는 서로 쌍으로 관리됩니다.
비밀번호는 rawdata가 아닌 암호화 데이터로 관리되어야 합니다.
(string => bytes32)인 mapping으로 관리

value인 bytes32는 ID와 PW를 같이 넣은 후 나온 결과값으로 설정하기
abi.encodePacked() 사용하기

* 로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
* 회원가입 기능 - 새롭게 회원가입할 수 있는 기능
---------------------------------------------------------------------------
* 회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지 
-> key값인 id를 넣었을 때 0x0000... 인 값이 아닌 다른 값이 나오면 이미 존재하는 것
* 비밀번호 5회 이상 오류시 경고 메세지 기능 - 비밀번호 시도 회수가 5회되면 경고 메세지 반환
* 회원탈퇴 기능 - 회원이 자신의 ID와 PW를 넣고 회원탈퇴 기능을 실행하면 관련 정보 삭제*/

contract TEST2 {

    struct account {
        string id;
        bytes32 pw;
    }

    mapping(string => bytes32) enData;
    mapping(string => account[]) accounts;

    // * 로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
    function login(string memory _id, bytes32 _pw) public returns(string memory) {
        // return accounts[_id] 
    }

    // * 회원가입 기능 - 새롭게 회원가입할 수 있는 기능
    // value인 bytes32는 ID와 PW를 같이 넣은 후 나온 결과값으로 설정하기
    function join(string memory _id, bytes32 _pw) public {
        // enData[_id] = keccak256(bytes(_id))+keccak256(_pw);
    }

}


contract TEST2_Answer {
    struct User {
        bytes32 hash;
        uint attempts;
    }

    mapping(string => bytes32) ID_PW;   // db라고 생각하면 됨

    // * 로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
    function logIn(string memory _ID, string memory _PW) public view returns(bool) {
        // id와 비밀번호가 쌍으로 관리
        return ID_PW[_ID] == keccak256(abi.encodePacked(_ID, _PW)); // 2개 이상 넣을 때는 bytes로는 힘들기 때문에 abi.encodePacked() 사용한다.


        // * 비밀번호 5회 이상 오류시 경고 메세지 기능 - 비밀번호 시도 회수가 5회되면 경고 메세지 반환

    }

    function logIn2(string memory _ID) public view returns(bytes32){
        return ID_PW[_ID];
    }

    // * 회원가입 기능 - 새롭게 회원가입할 수 있는 기능
    function signIn(string memory _ID, string memory _PW) public {
        // * 회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지
        require(ID_PW[_ID] == 0x0000000000000000000000000000000000000000000000000000000000000000, "Provided ID is already being used.");
        ID_PW[_ID] = keccak256(abi.encodePacked(_ID, _PW));
    }

    // * 회원탈퇴 기능 - 회원이 자신의 ID와 PW를 넣고 회원탈퇴 기능을 실행하면 관련 정보 삭제
    function signOut(string memory _ID, string memory _PW) public {
        require(logIn(_ID, _PW) == true);
        delete ID_PW[_ID];
    }

}


contract REQUIRE {
    function Require1(uint _n) public pure returns(uint) {
        require(_n<10, "input should be lower than 10");
        return _n*3;
    }

    function getName(string memory _name) public pure returns(bytes32) {
        return keccak256(abi.encodePacked((_name)));
    }
    // getName(alice): 0x9c0257114eb9399a2985f8e75dad7600c5d89fe3824ffa99ec1c3eb8bf3b0501

    function onlyAlice(string memory _name) public pure returns(bool) {
        require(getName(_name) == 0x9c0257114eb9399a2985f8e75dad7600c5d89fe3824ffa99ec1c3eb8bf3b0501);
        // 무조건 결과값이 1개로 고정된다(true만 나옴) - 어짜피 위 require에서 다 끊어버리기 때문
        return true;
    }

}



