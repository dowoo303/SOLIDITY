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

    function who() virtual public pure returns(string memory) {
        return "dad from DAD";
    }

    function name() internal pure returns(string memory) {
        return "David";
    }

    function password() private pure returns(uint) {
        return 1234;
    }

    function character() external pure returns(string memory) {
        return "not good";
    }

    function getAddress() public view returns(address) {
        return address(this);       // 이 컨트랙트의 주소
    }
}

contract MOM {
    DAD husband = new DAD();
    function who() virtual public pure returns(string memory) {
        return "mom from MOM";
    }

    function getHusbandChar() public view returns(string memory) {
        return husband.character();
    }

    function getWallet() public view returns(uint) {
        return husband.wallet();
    }

    function husbandAddress() public view returns(address) {
        return address(husband);
    }

    function husbandAddress2() public view returns(address) {
        return husband.getAddress();
    }

    /*
    Visibility에서 차단
    function getCrypto() public view returns(uint) {
        return husband.crypto();
    }

    function getEmergency() public view returns(uint) {
        return husband.emergency();
    }
    */
}

contract CHILD is DAD {
    function who() override public pure returns(string memory) {
        return super.who();
        // return "child from CHILD";
    }

    function fathersName() public pure returns(string memory) {
        return super.name();
    }

    function fathersWallet() public view returns(uint) {
        return DAD.wallet;      // 상속받은 컨트랙트의 변수 접근은 괄호가 필요없음
    }

    function fathersCrypto() public view returns(uint) {
        return DAD.crypto;
    }

    function fathersAddress() public view returns(address) {
        return DAD.getAddress();        // 상속받았을 경우 자기 주소
    }

    function fathersAddress2() public view returns(address) {
        return super.getAddress();
    }

    DAD daddy = new DAD();
    DAD daddy2 = new DAD();

    /*function fathersName2() public pure returns(string memory) {
        return daddy.name();
    }*/

    function fathersWallet2() public view returns(uint) {
        return daddy.wallet();      // 인스턴스화 시킨 변수 접근은 괄호 필요
    }

    /*function fathersCrypto2() public view returns(uint) {
        return daddy.crypto();
    }*/

    function getDaddyAddress() public view returns(address) {
        return address(daddy);          // daddy 컨트랙트 주소
    }

    function getDaddyAddress2() public view returns(address) {
        return daddy.getAddress();      // daddy 컨트랙트 주소
    }

    function getDaddy2Address() public view returns(address) {
        return address(daddy2);         // daddy2 컨트랙트 주소
    }

    function getDaddy2Address2() public view returns(address) {
        return daddy2.getAddress();     // daddy2 컨트랙트 주소
    }

    /*
    Visibility - private 막힘
    function fathersEmergency() public view returns(uint) {
        return DAD.emergency;
    }
    */

    /*
    오류 발생 상속받은 아이는 external 접근 불가능
    function fathersChar() public pure returns(string memory) {
        return super.character();
    }
    */

    /*
    오류 발생 password는 private 함수
    function password_Dad() public pure returns(uint) {
        return super.password();
    }
    */
}