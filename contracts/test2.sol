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
* 회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지 -> key값인 id를 넣었을 때 0x0000... 인 값이 아닌 다른 값이 나오면 이미 존재하는 것
* 비밀번호 5회 이상 오류시 경고 메세지 기능 - 비밀번호 시도 회수가 5회되면 경고 메세지 반환
* 회원탈퇴 기능 - 회원이 자신의 ID와 PW를 넣고 회원탈퇴 기능을 실행하면 관련 정보 삭제*/

contract TEST2 {

    mapping(string => bytes32) ID_PW;

    // * 로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
    function logIn(string memory _ID, string memory _PW) public returns(bool) {
        // id와 비밀번호가 쌍으로 관리
        return ID_PW[_ID] == keccak256(abi.encodePacked(_ID, _PW)); // 2개 이상 넣을 때는 abi.encodePacked() 사용한다.
    }

    // * 회원가입 기능 - 새롭게 회원가입할 수 있는 기능
    function signIn(string memory _ID, string memory _PW) public{
       ID_PW[_ID] == keccak256(abi.encodePacked(_ID, _PW)); // 2개 이상 넣을 때는 abi.encodePacked() 사용한다.
    }







}