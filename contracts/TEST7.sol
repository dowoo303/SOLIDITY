// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*
시험시간: 35분

숫자를 시분초로 변환하세요.
예) 100 -> 1분 40초, 600 -> 10분, 1000 -> 16분 40초, 5250 -> 1시간 27분 30초

*/

contract hourMinSec {

    modifier limit(uint _time) {
        require(_time<86400, "Time cannot exceed 86400");
        _;
    }

    function trans(uint time) public limit(time) pure returns(uint, uint, uint) {
        uint hour = time / 60 / 60;
        uint min = time / 60 % 60;
        uint sec = time % 60;

        return (hour, min ,sec);
    }

    
}