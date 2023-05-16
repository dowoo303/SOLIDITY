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
    struct user {
        uint number;
        string name;
        uint balance;
        uint score;
    }

    mapping(address => user[]) array;

    // * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    uint count;

    function setUser(string memory _name) public {
        array[msg.sender].push(user(count++, _name, 0, 0));
    }

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function getUser() public view returns(user[] memory) {
        return array[msg.sender];
    }

    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    receive() external payable{}

    function inGameFee() public payable {
        if(balances[msg.sender] > 0.01 ether) {
            balances[msg.sender] -= 0.01 ether;
        } else {
            require(msg.value == 0.01 ether); 
            payable(this).transfer(0.01 ether);  
        }   
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function scoreTransMoney() public payable {
        require(array[msg.sender][0].score >= 10);      // 번호 어케알아냄?
        array[msg.sender][0].score -= 10;               // 번호 어케알아냄?
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
    uint balance;
    mapping(address => uint) balances;

    function FastPay() public payable {
        payable(this).transfer(msg.value);
        balance = msg.value;
        balances[msg.sender] += balance;
    }

}