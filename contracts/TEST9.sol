// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// 은행에 입금을 하면 진짜 돈이 빠져나가는 case

contract APP {
    mapping(address=>uint) balance; // 개인 잔액
    // mapping(address=>mapping(address=>uint)) bankAccounts; // 은행 잔고
    receive() external payable{}    // 특정 함수를 통하지 않고 이 컨트랙트도 돈을 받을 일이 있음

    modifier balCheck(address _a, uint _amount) {
        balance[_a] >= _amount;
        _;
    }

    // app 이용 수수료 부과하기
    modifier Fee(uint _amount){
        require(msg.value == _amount*101/100);
        _;
    }


    // 입금 - 해당 App에게 얼만큼의 돈을 입금하겠다.
    function depositToApp() public payable {
        balance[msg.sender] += msg.value;
    }

    // 입금 - 특정 은행에게 얼만큼의 돈을 입금하겠다.
    function depositToBank(address payable _bank, uint _amount) public payable Fee(_amount) {
        Bank targetBank = Bank(_bank);
        require(balance[msg.sender] >= _amount);
        payable(targetBank).transfer(_amount);      // App에서 뱅크로 트랜스퍼
        balance[msg.sender] -= _amount;
        targetBank.Deposit(msg.sender, _amount);    // 특정 은행의 명령자의 계좌에 _amount만큼 입금
    }

    function _depositToBank(address payable _bank, address _to, uint _amount) public {
        Bank targetBank = Bank(_bank);
        require(balance[msg.sender] >= _amount);
        payable(targetBank).transfer(_amount);
        balance[msg.sender] -= _amount;
        targetBank.Deposit(_to, _amount);
    }


    // 인출 - 해당 App에게 얼만큼의 돈을 출금하겠다.
    function withdrawFromApp(uint _amount) public {
        balance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    // 인출 - 특정 은행에서 얼만큼의 돈을 출금하겠다.
    function withdrawFromBank(address payable _bank, uint _amount) public {
        Bank targetBank = Bank(_bank);
        targetBank.Withdraw(msg.sender, _amount);
        balance[msg.sender] += _amount;    
    }

    // 송금 - A가 B에게 돈을 보내는 것(직접)
    function transferTo(address _bAccount, uint _amount) public balCheck(msg.sender, _amount) {
        balance[msg.sender] -= _amount;
        balance[_bAccount] += _amount;
    }

    // 은행송금 - A의 은행에서 B의 은행에게 돈을 보내는 것(은행끼리)
    // 사용자의 A bank -> App -> B bank(받는사람)
    function transferWire(address payable _aBank, address _bAccount, address payable _bBank, uint _amount) public {
        withdrawFromBank(_aBank, _amount);
        _depositToBank(_bBank, _bAccount, _amount);
    }
}



contract Bank {
    mapping(address=>uint) private balance; // 보안을 위하여 mapping(address=>uint) public balance;를 프라이빗으로
    receive() payable external{}

    // 잔고확인
    function balanceOf() public view returns(uint) {
        return balance[msg.sender];       // 내 지갑주소만 확인 가능
    }


    // 입금 - 얼만큼의 돈을 입금하겠다.
    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }

    // 밑 타행송금에서 deposit을 하면 자기자신에게 돈을 입금하는 상황이 되므로 주소를 따로 받을 수 있는 _deposit생성
    function _deposit(address _account, uint _amount) internal {
        balance[_account] += _amount;
    }
    
    // 위 _deposit함수를 ERC20 형식으로 분리
    function Deposit(address _account, uint _amount) public {
        require(_amount != 0, "Amount should not be zero");
        _deposit(_account, _amount);
    }


    // 인출 - 얼만큼의 돈을 출금하겠다.
    function withdraw(uint _amount) public {
        balance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    // 밑 타행송금에서 withdraw을 하면 자기자신에게 돈을 입금하는 상황이 되므로 주소를 따로 받을 수 있는 _withdraw생성
    function _withdraw(address _account, uint _amount) internal {
        balance[_account] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
    function _withdraw2(address _account, uint _amount) internal {
        balance[_account] -= _amount;
        payable(_account).transfer(_amount);    // 위와 다르게 개인지갑으로 다이렉트
    }
    
    // 위 _withdraw함수를 ERC20 형식으로 분리
    function Withdraw(address _account, uint _amount) public {
        require(balance[_account] >= _amount, "Not enough money");
        _withdraw(_account, _amount);
    }



    // 송금 - A가 B에게 돈을 보내는 것(동행)
    function transferTo(address _bAccount, uint _amount) public {
        balance[msg.sender] -= _amount;
        balance[_bAccount] += _amount;
    }

    // 타행송금 - A가 B의 다른 은행에게 돈을 보내는 것(타행)
    function transferWire(address _bAccount, address payable anotherBank, uint _amount) public {
        Bank B = Bank(anotherBank);
        balance[msg.sender] -= _amount;
        payable(B).transfer(_amount);       // B뱅크 컨트랙트로 트랜스퍼하겠다
        B.Deposit(_bAccount,_amount);       // B뱅크의 b계좌에 _amount만큼 입금
    }
}





contract Msgsedner {
    function A() public view returns(address) {
        address a = msg.sender;
        return a;
    }

    function B() public view returns(address) {
        address b = A();
        return b;
    }
}


contract Msgsender2 {
    Msgsedner msgsender = new Msgsedner();

    // Msgsender2의 스마트 컨트랙트 주소 출력
    function C() public view returns(address) {
        address c = msgsender.A();
        return c;
    }

    // Msgsender2의 스마트 컨트랙트 주소 출력
    function D() public view returns(address) {
        address d = msgsender.B();
        return d;
    }
}

// msg.sender은 다른 함수를 불러도 컨트랙트가 아닌 사용자로 고정 !
contract Msgsender3 {
    address[] list;

    function push() public {
        list.push(msg.sender);
    }

    // 뭐가 나올까?
    function push2() public {
        push();
    }

    function getlist() public view returns(address[] memory){
        return list;
    }
}


// 3개 중에 2개만 받는법
contract AA {
    function numbers() public pure returns(uint, uint, uint) {
        return (1,2,3);
    }

    function numbers2() public pure returns(uint, uint, uint) {
        (uint a, uint b, uint c) = numbers();

        return (a,b,c);
    }

    function numbers3() public pure returns(uint, uint) {
        (uint a, , uint c) = numbers();

        return (a,c);
    }
}




// 생성자 상속 공부
contract A {
    uint public A;
    uint public B;

    constructor(uint a, uint b) {
        A = a;
        B = b;
    }
}

contract B is A(3, 4) {

}