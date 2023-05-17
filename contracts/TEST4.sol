// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*
* 사전 지식
방 빨리 들어가기 게임 - 선착순 4 3 2 1 점수 부여 -> modifier
0번 지갑 관리자 -> 나머지 지갑들을 유저로 등록

시간: 40분

간단한 게임이 있습니다.
유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
참가할 때 참가비용 1ETH를 내야합니다. (payable 함수)
4명까지만 들어올 수 있는 방이 있습니다. (array)
선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

예) 
간단한 게임이 있습니다.

참가할 때 참가비용 0.01ETH를 내야합니다.
4명까지만 들어올 수 있는 방이 있습니다.
선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

예) 
방 안 : "empty" 
-- A 입장 --
방 안 : A 
-- B, D 입장 --
방 안 : A , B , D 
-- F 입장 --
방 안 : A , B , D , F 
A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
방 안 : "empty" 

유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
* 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
* 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
* 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
* 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
---------------------------------------------------------------------------------------------------
* 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.

*/

contract RoomGame {
    // 게임
    uint count;
    address[] array;

    function goRoomGame() public payable {
        // 참가할 때 참가비용 0.01ETH를 내야합니다. -> 10000000000000000 Wei
        inGameFee();

        // 4명까지만 들어올 수 있는 방이 있습니다.
        // require(array[0] != userId[msg.sender] && array[1] != userId[msg.sender]);       // 중복유저 방지
        array.push(msg.sender);
        count++;

        // 선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.
        if(count == 4) {
            users[userId[array[0]]].score += 4;
            users[userId[array[1]]].score += 3;
            users[userId[array[2]]].score += 2;
            users[userId[array[3]]].score += 1;
            for(uint i = 0; i<count; i++) {
                array.pop;      // 동작안함
            }
            count = 0;
        }
    }

    function getArray() public view returns(address[] memory) {
        return array;
    }

    function getCount() public view returns(uint) {
        return count;
    }

    function getScore() public view returns(uint) {
        return users[userId[msg.sender]].score;     // 가스비 초과로 오류남 -> 유저 등록 기능 두 줄 순서 바꾸기...........
    }

    function getUserId() public view returns(uint) {
        return userId[msg.sender];
    }
    

    // 동작들
    struct user {
        uint number;
        string name;
        uint balance;
        uint score;
        address a;
    }

    user[] users;
    mapping(address => uint) userId;

    // * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function setUser(string memory _name) public {
        userId[msg.sender] = users.length;      // number과 배열번호가 같음 -> userId[msg.sender]=users[userId[msg.sender]].number
        users.push(user(users.length, _name, 0, 0, msg.sender));
    }

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function getUser() public view returns(user[] memory) {
        return users;
    }

    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    receive() external payable{}

    function inGameFee() public payable {
        if(balances[msg.sender] > 0.01 ether) {
            balances[msg.sender] -= 0.01 ether;
        } else {
            require(msg.value == 0.01 ether, "give me 0.01eth !"); 
            payable(this).transfer(0.01 ether);  
        }   
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function scoreTransMoney() public payable {
        require(users[userId[msg.sender]].score >= 10);     
        users[userId[msg.sender]].score -= 10;               
        address payable wallet = payable(msg.sender);
        wallet.transfer(0.1 ether);
    }

    // * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    address payable owner;

    constructor() payable  {
        // 0번 지갑 주소 : 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        owner = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    }

    function withdrawAll() public payable {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(address(this).balance);
    }

    function withdrawSome(uint _money) public payable {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(_money);
    }

    // * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    mapping(address => uint) balances;

    function FastPay() public payable {
        payable(this).transfer(msg.value);
        balances[msg.sender] += msg.value;
    }

}


contract Answer {
    struct User {
        uint number;
        string name;
        address account;
        uint balance;
        uint score;
    }

    mapping(address => User) userList;
    uint count;

    // * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function register(string memory _name) public {
        userList[msg.sender] = User(count++, _name, msg.sender, msg.sender.balance, 0);
    }

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function search(address _a) public view returns(User memory) {
        return userList[_a];
    }

    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
}