// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;


// 생성자
contract CONSTRUCTOR {
    uint a;
    uint b;

    constructor() {
        a = 7;
        b = 4;
    }

    function setA() public {
        a = 5;
    }

    function getA() public view returns(uint) {
        return a;
    }

    function getB() public view returns(uint) {
        return b;
    }
}

// 생성자 input
contract CONSTRUCTOR2 {
    uint a;

    constructor(uint _a) {
        a = _a;
    }

    function getA() public view returns(uint) {
        return a;
    }
        
    
}

// 생성자+구조체
contract CONSTRUCTOR3 {
    struct Student {
        string name;
        uint number;
    }

    Student s;

    constructor(string memory _name, uint _number) {
        s = Student(_name, _number);
    }

    function getStudent() public view returns(Student memory) {
        return s;
    }


}

// 생성자+if
contract CONSTRUCTOR4 {
    uint a;

    constructor(uint _a) {
        if(_a>5) {
            a = _a;
        } else {
            a = _a*2;
        }
    }

    function getA() public view returns(uint) {
        return a;
    }
}

// 생성자+payable
contract CONSTRUCTOR5 {
    /*
    1. 1번 지갑으로 배포, value는 10eth로
    2. 배포 후 지갑 잔고 확인
    3. 2번 지갑으로 deposit() 1eth // 3,4,5번 지갑으로 똑같이 실행
    4. 지갑 잔고 확인 후, 2번 지갑으로 transferTo 시도, _to의 지갑 주소는 6번 지갑 금액은 5eth 
    5. 1번 지갑으로 transferTo 시도, _to의 지갑 주소는 6번 지갑 금액은 5eth
    6. 2번 지갑으로 withdraw 함수 시도, 1번 지갑으로 withdraw 함수 시도
    0x17F6AD8Ef982297579C203069C1DbfFE4348c372
    */


    // 트랜잭션: from은 내 주소고, to는 컨트랙트 주소
    // msg.sender: 거래를 일으키는 사람


    address payable owner;

    // 해당 컨트랙트에 돈을 보내고 싶음 = 컨트랙트는 돈을 받고 싶음 -> payable
    constructor() payable  {
        payable(this).transfer(msg.value);      // 돈을받고싶음(이 컨트랙트주소로).돈을보낸다(value만큼)
        
        // 이 컨트랙트를 배포한 사람이 오너다
        owner = payable(msg.sender);    // 여기서 msg.sender는 컨트랙트 배포자를 말하며, owner에 이 컨트랙트 배포자를 넣어 고정값으로 만들어둔다.
    }

    // 받는 사람이 컨트랙트면 실행되는 함수 - 이게 있어야 위 코드가 작동함(컨트랙트가 돈을 받을 수 있음)
    receive() external payable{}    // 일반거래(별도의 호출되는 함수가 없는 거래)시 해당 contract가 돈을 받을 수 있게 해주는 함수



    function getOwner() public view returns(address) {
        return owner;
    }

    // 특정 지갑주소에 특정 금액만큼 보내는 함수
    // 컨트랙트로부터 돈을 받는 함수
    function transferTo(address payable _to, uint _amount) public {
        require(msg.sender == owner, "only owner can transfer asset");      // 이 지갑의 오너만이 이 컨트랙트의 자산을 이동(보낼수)시킬 수 있다
        _to.transfer(_amount);
    }

    // 특정 금액 만큼 돈을 받을 수 있는 함수
    // 특정 금액을 컨트랙트에 돈을 넣는 함수
    function deposit() public payable returns(uint) {
        return msg.value;
    }


    // 컨트랙트가 owner에게 잔고 전부를 돈을 보내는 함수 - 오너 입장에서는 전액 인출
    function withdraw1() public {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(address(this).balance);      // 이 컨트랙트 잔고를 모두 오너에게 보내라.
    }

    // 컨트랙트가 owner에게 _amount만큼 보내는 함수
    function withdraw2(uint _amount) public {
        require(msg.sender == owner, "only owner can transfer asset");
        // owner.transfer(address(this).balance);      // 이 컨트랙트 잔고를 모두 오너에게 보내라.
        owner.transfer(_amount  /* _amount *10**18 */);
    }

    // 컨트랙트가 owner에게 1이더 보내는 함수 
    function withdraw3() public {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(1 ether);      // 이 컨트랙트 잔고를 모두 오너에게 보내라.
    }

}


// MODIFIER 기초
contract MODIFIER {
    uint a;

    modifier lessThanFive() {
        require(a<5, "should be less than five");
        _;  // 함수가 실행되는 시점
    }

    function aPlus() public {
        a++;
    }

    function aMinus() public {
        a--;
    }

    function getA() public view returns(uint) {
        return a;
    }

    function doubleA() lessThanFive public {
        a = a*2;
    }

    function plusTen() lessThanFive public {
        a += 10;
    }
}

// MODIFIER의 실행 시점 알아보기
contract MODIFIER2 {
    /*
    실습가이드
    1. setAasTwo()로 a 값 2로 만들기
    2. setA() 실행 후 결과 확인, getA()로 A 값 확인
    3. setAasTwo()로 a 값 다시 2로 만들기
    4. setA2() 실행 후 결과 확인, getA()로 A 값 확인
    */

    uint a;
    
    modifier plusOneBefore() {
        a++;
        _;
    }
    
    modifier plusOneAfter() {
        _;
        a++;
    }

    // 결과 A
    function setA() public plusOneBefore returns(string memory) {
        if(a>=3) {
            return "A";
        } else {
            return "B";
        }
    }

    // 결과 B
    function setA2() public plusOneAfter returns(string memory) {
        if(a>=3) {
            return "A";
        } else {
            return "B";
        }
    }

    function getA() public view returns(uint) {
        return a;
    }

    function setAasTwo() public {
        a = 2;
    }

}
// 둘다 a값은 3으로 동일하지만 return 값은 다르다.


// `_` 여러개 사용
contract MODIFIER3 {
    /*
    실습가이드
    1. setAasTwo()로 a 값 2로 만들기
    2. setA() 실행 후, getB2() 실행해서 결과 보기
    */
    uint a;
    string b;
    string[] b2;

    modifier plusOneBefore() {
        _;
        a++;
        _;
    }

    function setA() public plusOneBefore  {
        if(a>=3) {
            b = "A";
            b2.push(b);
        } else {
            b = "B";
            b2.push(b);
        }
    }

    function getA() public view returns(uint) {
        return a;
    }

    function getB() public view returns(string memory) {
        return b;
    }

    function getB2() public view returns(string[] memory) {
        return b2;
    }

    function setAasTwo() public {
        a = 2;
    }
}

// modifier 실제 응용(물건 구매 제한 연령)
contract MODIFIER4 {
    struct Person {
        uint age;
        string name;
    }

    Person P;

    modifier overTwenty(uint _age, string memory _criminal) {
        require(_age >20, "Too young");
        require(keccak256(abi.encodePacked(_criminal)) != keccak256(abi.encodePacked("Bob")), "Bob is criminal. She can't buy it");
        _;
    }

    function buyCigar(uint _a, string memory _name) public pure overTwenty(_a, _name) returns(string memory) {
        return "Passed";
    }

    function buyAlcho(uint _a, string memory _name) public pure overTwenty(_a, _name) returns(string memory) {
        return "Passed";
    }

    function buyGu(uint _a, string memory _name) public pure overTwenty(_a, _name) returns(string memory) {
        return "Passed";
    }

    function setP(uint _age, string memory _name) public {
        P = Person(_age, _name);
    }

    function getP() public view returns(Person memory) {
        return P;
    }

    function buyCigar2() public overTwenty(P.age, P.name) view returns(string memory) {
        return "Passed";
    }

    function buyAlcho2() public overTwenty(P.age, P.name) view returns(string memory) {
        return "Passed";
    }

    function buyGu2() public overTwenty(P.age, P.name) view returns(string memory) {
        return "Passed";
    }

}


// modifier 실제 응용2(화장실 사용 체크)
contract MODIFIER5 {
    uint mutex=0;

    modifier m_check {
        mutex++;
        _;
        mutex--;
    }

    modifier shouldBeZero {
        require(mutex==0, "someone is using");
        _;
    }

    modifier shouldBeOne {
        require(mutex==1, "exist one");
        _;
    }

    function inAndOut() public m_check returns(string memory) {
        return "Done";
    }

    // 실행안됨
    function inAndOut2() public m_check shouldBeZero returns(string memory) {
        return "Done";
    }

    // 위와 다르게 실행 됨
    function inAndOut2_2() public m_check shouldBeOne returns(string memory) {
        return "Done";
    }

    // 방 빈것 확인하고 inAndOut Done하기
    function inAndOut3() public shouldBeZero m_check returns(string memory) {
        return "Done";
    }

    function occupy() shouldBeZero public {
        mutex++;
    }

    function vacancy() public {
        mutex--;
    }


}