// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;


// VISIBILITY 4가지 선언 이해하기
contract VISIBILITY {

    function privateF() private pure returns(string memory) {
        return "private";
    }

    function testPrivateF() public pure returns(string memory) {
        return privateF();
    }

    function testPrivateF2() internal pure returns(string memory) {
        return privateF();
    }

    function internalF() internal pure returns(string memory) {
        return "internal";
    }

    function testInternalF() public pure returns(string memory) {
        return internalF();
    }

    function publicF() public pure returns(string memory) {
        return "public";
    }

    function externalF() external pure returns(string memory) {
        return "external";
    }
}

contract Child3 is VISIBILITY {

    function testPrivateF_1() public pure returns(string memory) {
        return testPrivateF();
    }

    function testPrivateF_2() public pure returns(string memory) {
        return testPrivateF2();
    }

    function testInternal2() public pure returns(string memory) {
        return internalF();
    }

    function testPublic() public pure returns(string memory) {
        return publicF();
    }
    /*
    function testPrivate() public pure returns(string memory) {
        return privateF();
    }
    
    function testExternal() public pure returns(string memory) {
        return externalF();
    }
    */
}
// 컨트랙트 인스턴스화
contract Outsider {
    VISIBILITY vs = new VISIBILITY();

    function getExternalFromVS() public view returns(string memory) {
        return vs.externalF();
    }

    function getPublicFromVS() public view returns(string memory) {
        return vs.publicF();
    }
}




// 상속
contract Parent {
    uint test;

    function add(uint a, uint b) public pure returns(uint) {
        return a+b;
    }
}
// is를 통해 Parent 함수 상속
contract Child is Parent {
    function mul(uint a, uint b) public pure returns(uint) {
        return a*b;
    }
}


// 상속 - 함수이름 겹칠 때 virtual, override
contract Child2 {
    function mul2(uint a, uint b) virtual public pure returns(uint) {
        return a*b;
    }
}
contract GrandChild is Child2 {
    function mul2(uint a, uint b) override public pure returns(uint) {
        return a*a*b;
    }
}



// 다중 상속인 부모들의 함수 이름이 같을 경우
contract DAD1 {
    function who() virtual public pure returns(string memory) {
        return "dad from DAD";
    }
}
contract MOM1 {
    function who() virtual public pure returns(string memory) {
        return "mom from MOM";
    }
}
contract CHILD1 is DAD1, MOM1 {
    function who() override(DAD1, MOM1) public pure returns(string memory) {
        return "child from CHILD";
    }
}




// external과 private 상속가능? -> internal과 public만 가능
// external은 외부인 접근 or 인스턴스 변수화 시킨걸로만 접근 가능
contract DAD {
    uint a;
    address public b;

    uint public wallet=100; // 공개한 지갑 잔액
    uint internal crypto=1000; // 메모장에 private key가 있는 크립토 잔액
    uint private emergency=10000; // 진짜 비상금

    function changeWallet(uint _n) internal {
        wallet = _n;
    }

}

contract MOM {
    DAD husband = new DAD();
    DAD realHusband;
    
    constructor(address _a) {
        realHusband = DAD(_a);  // 시작부터 DAD의 지갑주소를 설정하고 시작
    }

    function getWallet() public view returns(uint) {
        return husband.wallet();    // DAD의 wallet 값이 변경되도 쫓아가지 못함
    }

    function getRealWallet() public view returns(uint) {
        return realHusband.wallet();        // DAD의 wallet 값 변화를 감지할 수 있음
    }

    function setDad(address _a) public view returns(uint) {
        DAD copyDad = DAD(_a);
        return copyDad.wallet();
    }
}

contract CHILD is DAD {
    function dadChangeWallet(uint _a) public {
        super.changeWallet(_a);     // 상속받은 자녀도 변수 접근 가능
    }
    
    DAD daddy = new DAD();
    DAD daddy2 = new DAD();

     
}





/*
contract B에서는 새롭게 A를 선언하니 A 선언에 필요한 input 값 2개를 넣어주고
contract B2에서는 기존의 A를 참조하려고 하니 A 선언에 필요한 input 값 2개가 아닌, contract의 주소를 넣어주어야 함.
*/
// 상속+생성자
contract A {
    uint public a;
    uint public b; 
    constructor(uint _a, uint _b) {
        a = _a;
        b = _b;
    }
}

contract B {
    A a = new A(1,2);
    A b;

    constructor(uint _a, uint _b) {
        b = new A(_a, _b);      // new를 쓸 경우 A의 생성자 매개변수 다 입력해줘야함
    }
}

contract B2 {
    A b;

    constructor(address _a) {
        b = A(_a);      // 따라가는 함수는 주소를 매개변수로 받으면 됨
    }
}