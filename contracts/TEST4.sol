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


contract Answer1 {
    struct User {
        uint number;
        string name;
        address account;
        uint balance;
        uint score;
    }

    mapping(address => User) userList;
    uint count;
    User[] public top4;     // 일단 Dynamic(동적) 배열로 선언
    User[4] public top4_2;


    address payable owner;

    constructor() payable  {
        // 0번 지갑 주소 : 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        owner = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    }

    // * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function register(string memory _name) public {
        userList[msg.sender] = User(count++, _name, msg.sender, msg.sender.balance, 0);
    }

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function search(address _a) public view returns(User memory) {
        return userList[_a];
    }

    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    // 동적배열
    function gameIn() public payable {
        require((userList[msg.sender].balance >= 10**16 && msg.value==0) || msg.value == 0.01 ether);

        if(msg.value==0) {
            userList[msg.sender].balance -= 10**16;
        }

        if(top4.length ==4) {
            for(uint i=4;i>0;i--) {
                userList[top4[i-1].account].score += 5-i;
            }
            delete top4;
        }
        
        top4.push(userList[msg.sender]);
    }


    // 고정(fixed)배열
    function gameIn2() public payable {
        require((userList[msg.sender].balance >= 10**16 && msg.value==0) || msg.value == 0.01 ether);

        if(msg.value==0) {
            userList[msg.sender].balance -= 10**16;
        }

        if(getLengthOfTop4()==4) {
            for(uint i=4;i>0;i--) {
                userList[top4[i-1].account].score += 5-i;
            }
            delete top4_2;
        }
        top4_2[getLengthOfTop4()] = userList[msg.sender];
        
    }

    /*
		위의 gameIn2()를 modifier를 사용해본 버전
		modifier isitFour {
        if(getLengthOfTop4()==4) {
            delete top4_2;
            _;
        }
        _;
    }

    function gameIn2_2() public payable isitFour {
        require((userList[msg.sender].balance >= 10**16 && msg.value==0) || msg.value == 0.01 ether);

        if(msg.value==0) {
            userList[msg.sender].balance -= 10**16;
        }

        top4_2[getLengthOfTop4()] = userList[msg.sender];
        
    }*/

    function getLengthOfTop4() public view returns(uint) {
        // 고정배열의 초기값이 0인 것을 이용한다
        for(uint i=0; i<4; i++) {
            if(top4_2[i].account == address(0)) {
                return i;
            }
        }
        return 4;
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function withdraw(uint _n) public {
        // 10점 단위로 넣는다고 가정
        require(_n%10==0 && userList[msg.sender].score >= _n);
        userList[msg.sender].score -= _n;
        payable(msg.sender).transfer(_n%10*0.1 ether);
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전 (최대 금액 자동 환전)
    function withdraw_All() public {
        require(userList[msg.sender].score >= 10);
        uint a = userList[msg.sender].score /10;
        userList[msg.sender].score = userList[msg.sender].score%10;
        payable(msg.sender).transfer(a*0.1 ether);
    }

    // * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function ownerWithdraw(uint _n) public onlyOwner {
        owner.transfer(_n*1 ether);
    }

    function ownerWithdrawAll() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    // * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    function deposit() public payable {
        userList[msg.sender].balance += msg.value;
    }
}

contract FixedDynamic {
    uint[] public a;
    uint[4] public b;
    uint count;

    // 동적 배열과 고정 배열의 차이점
    function getAB() public view returns(uint[] memory, uint[4] memory) {
        return (a,b);
    }

    function pushA(uint _n) public {
        a.push(_n);
    }

    // 배열 자리를 입력하고 들어가는게 싫음
    function pushB(uint _a, uint _b) public {
        b[_a-1] = _b;
    }

    // 상태변수 써서 싫음(가스비)
    function pushB2(uint _a) public {
        b[count++] = _a;
    }

    // 자리도 자동으로 앞부터 들어가고, 가스비도 아낄 수 있는 방법
    function pushB3(uint _a) public {
        require(_a !=0);
        if(getLengthB()==4) {
            delete b;           // 자리가 다 차면 비우기
        }
        b[getLengthB()] = _a;   // 함수를 집어넣음
    }

    function getLengthB() public view returns(uint) {
        for(uint i=0; i<4; i++) {
            if(b[i]==0) {
                return i;
            }
        }
        return 4;
    }


}

contract POPvsDELETE {
    
    // gas-실제요금과 관련, execuiton cost-실질 사용 요금은 아님(컴퓨팅 비용)

    uint[] public a;
    uint[4] b;

    function pushA(uint _n) public {
        a.push(_n);
    }

    function returnA() public view returns(uint[] memory) {
        return a;
    }

    function popA() public {
        a.pop(); // gas - 41551, 26531, 10267 / 41551, 26531, 10267 / 41551, 26531, 10267 / 47071, 25065, 10267
    }

    /*
    pop과 delete 비교
    array를 초기화 시키기 위해서 delete는 한번만 수행, pop은 여러번 수행해야하는 차이가 있음.
    pop은 같은 양의 cost를 요구하지만 맨 마지막 번에는 추가적인 gas를 요구함

    delete는 단일 수행이므로 요구하는 gas가 높으나, 총액으로 환산하면 더 경제적임.
    */

    function deleteA() public {
        delete a; // gas - 81202, 37288, 25546 (4),   149266, 61597, 55932(10)
    }

    /*
    delete와 renew 비교
    delete와 renew 둘다 내부 요소의 개수가 많아질수록 cost가 증가한다.
    4개의 경우 그리고 10개의 경우 모두 delete가 gas, transaction, execution cost 모두 낮다.
    uint[]의 경우에는 delete가 renew 보다 (현재 상황에서는) 효과적으로 보임
    */

    function renewA() public {
        a = new uint[](0);
    }   // 81358, 37397, 25682 (4),    149372, 61671, 56024(10)
}