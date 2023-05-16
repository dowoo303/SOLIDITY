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

    uint public wallet=100; // 공개한 지갑 잔액
    uint internal crypto=1000; // 메모장에 private key가 있는 크립토 잔액
    uint private emergency=10000; // 진짜 비상금

    function getMsgSender() public view returns(address) {
        return msg.sender;  // 현재 내 지갑 주소가 나옴
    }
}

contract MOM {
    DAD husband = new DAD();
    
    function husGetMsgSender() public view returns(address) {
        return husband.getMsgSender();      // 현재 지갑 주소가 아닌 MOM 컨트랙트 주소가 나옴
    }
}

contract CHILD is DAD {

    function dadGetMsgSender() public view returns(address) {
        return super.getMsgSender();    // 현재 내 지갑 주소가 나옴
    }

    DAD daddy = new DAD();
    DAD daddy2 = new DAD();

    function daddyGetMsgSender() public view returns(address) {
        return daddy.getMsgSender();    // 현재 지갑 주소가 아닌 CHILD 컨트랙트 주소가 나옴
    }  
}