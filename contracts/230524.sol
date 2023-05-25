// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract ABC {
    function currentTime() public view returns(uint) {
        return block.timestamp;
    }

    function getTime() public view returns(uint) {
        return block.timestamp + 100;
    }

    function getTime2() public view returns(uint) {
        return block.timestamp + 10 seconds;
    }

    function getTime3() public view returns(uint) {
        return block.timestamp + 10 minutes;
    }

    function getTime4() public view returns(uint) {
        return block.timestamp + 1 hours;
    }

    function getTime5() public view returns(uint) {
        return block.timestamp + 1 days;
    }

    function getTime6() public view returns(uint) {
        return block.timestamp + 1 weeks;
    }

    /*function getTime7() public view returns(uint) {
        return block.timestamp + 1 years; //0.5.0부터 없어짐
    }*/
}


contract ADDRESS {
    function getBalance(address _a) public view returns(uint) {
        return _a.balance;
    }

    function getCode(address _a) public view returns(bytes memory) {
        return _a.code;
    }

    function getCodeHash(address _a) public view returns(bytes32) {
        return _a.codehash;
    }

    function transferAsset(address payable _a) public {
        _a.transfer(100);
    }

    function sendAsset(address payable _a) public returns(bool) {
        return _a.send(100);
    }
}