// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;


contract A {
  function myAddress() public view returns(address) {
    return address(this);
  }

  uint public a;

  function setA(uint _a) public {
    a = _a;
  }

  function input(uint _a, uint _b, uint _c) public pure returns(uint) {
    return _a*_b*_c;
  }
}


contract EVENT_EMIT {

    struct User {
        uint number;
        string name;
    }

    User[] Users;

    event newUser(uint _number, string _name);
    event userPush(string _message);

    function setUser(uint _number, string memory _name) public {
        Users.push(User(_number, _name));
        emit newUser(_number, _name);
        emit userPush("New User");
    }
}



contract EVENT_EMIT2 {
    event ADD(string add, uint result);
    event SUB(string sub, uint result);
    event MUL(string mul, uint result);
    event DIV(string div, uint result);

    function add (uint _a, uint _b) public returns(uint _c) {
        _c = _a + _b;
        emit ADD("Plus", _c);
    }

    function sub(uint _a, uint _b) public returns(uint _c) {
        _c = _a - _b;
        emit SUB("Minus", _c);
    }

    function mul(uint _a, uint _b) public returns(uint _c) {
        _c = _a * _b;
        emit MUL("Times", _c);
    }

    function div(uint _a, uint _b) public returns(uint _c) {
        _c = _a / _b;
        emit DIV("Divided", _c);
    }
}