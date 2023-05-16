// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;
/*
시험시간: 25분
사용 함수: ENUM, require, if, payable


자동차를 운전하려고 합니다.
자동차의 상태에는 정지, 운전중, 시동 끔, 연료없음 총 4가지 상태가 있습니다.

정지는 속도가 0인 상태, 운전 중은 속도가 있는 상태이다. 

* 악셀 기능 - 속도를 1 올리는 기능, 악셀 기능을 이용할 때마다 연료가 2씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 70이상이면 악셀 기능은 더이상 못씀
* 브레이크 기능 - 속도를 1 줄이는 기능, 속도가 0인 상태, 브레이크 기능을 이용할 때마다 연료가 1씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
* 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
* 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
* 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨

지불은 smart contract에게 함.
----------------------------------------------------------------------------------------
* 주유소 사장님은 2번 지갑의 소유자임, 주유소 사장님이 withdraw하는 기능
* 지불을 미리 하고 주유시 차감하는 기능
*/


contract CarDrive {
    enum Status {
        stop,
        driving,
        noStart,
        noFuel
    }
    Status st;

    uint speed;
    uint Fuel;

    // * 악셀 기능 - 속도를 1 올리는 기능, 악셀 기능을 이용할 때마다 연료가 2씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 70이상이면 악셀 기능은 더이상 못씀
    function goDrive() public {
        require(Fuel > 30);
        require(speed < 70);
        speed++;
        Fuel -= 2;
        st = Status.driving;
    }

    // * 브레이크 기능 - 속도를 1 줄이는 기능, 속도가 0인 상태, 브레이크 기능을 이용할 때마다 연료가 1씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function Break() public {
        require(speed != 0);
        speed--;
        Fuel--;
        if(speed == 0) {
            st = Status.stop;
        }
    }

    // * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function Stop() public {
        require(speed == 0);
        st = Status.noStart;
    }

    // * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function Start() public {
        require(st == Status.noStart);
        st = Status.stop;
    }

    // * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    receive() external payable{}
    
    function fillFuel() public payable {
        if(tokens[msg.sender] > 0) {
            tokens[msg.sender]--;
            Fuel=100;
        } else {
            require(msg.value == 1 ether);      // 지금 지갑에서 지불할 VALUE로 1을 설정하라고 요구
            payable(this).transfer(1 ether);    // 스마트 컨트랙트로 1이더를 보냄
            Fuel=100;   
        }    
    }

    function getFuel() public view returns(uint) {
        return Fuel;
    }

    
    // * 주유소 사장님은 2번 지갑의 소유자임, 주유소 사장님이 withdraw하는 기능
    function withdraw() public payable {
        address payable wallet2 = payable(msg.sender);  // wallet2 주소는 현재 거래를 일으키는 사람(버튼 누른 지갑 주소)라고 명명해줌 
        require(msg.sender == 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "only owner can transfer asset");
        wallet2.transfer(address(this).balance);
    }


    // * 지불을 미리 하고 주유시 차감하는 기능
    uint token;
    mapping(address => uint) tokens;    // 각 지갑별로 토큰 관리

    function FastPay() public payable {
        payable(this).transfer(msg.value);  // 이 스마트 컨트랙트에 지금 버튼 누른 주인이 입력한 원하는 값(msg.value)을 입금
        token = msg.value / 1 ether;        // 넣은 만큼 토큰으로 줌
        tokens[msg.sender] += token;        // 각 지갑별로 토큰 적립
    }

    function getToken() public view returns(uint) {
        return tokens[msg.sender];
    }

}


contract answer {
    enum carStatus {
        stop,
        driving,
        turnedOff,
        outOfFuel
    }

    struct car {
        carStatus status;
        uint fuelGauage;
        uint speed;
    }

    car myCar;

    // * 악셀 기능 - 속도를 1 올리는 기능, 악셀 기능을 이용할 때마다 연료가 2씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 70이상이면 악셀 기능은 더이상 못씀
    function accel() public {
        require(myCar.fuelGauage > 30 && myCar.speed < 70 && myCar.status != carStatus.turnedOff);
        if(myCar.status != carStatus.driving) {
            myCar.status = carStatus.driving;
        }
        myCar.speed++;
        myCar.fuelGauage -= 2;
    }

    // * 브레이크 기능 - 속도를 1 줄이는 기능, 속도가 0인 상태, 브레이크 기능을 이용할 때마다 연료가 1씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function breakCar() public {
        require(myCar.speed !=0 && myCar.status != carStatus.turnedOff && myCar.status != carStatus.stop);
        myCar.speed--;
        myCar.fuelGauage --;
        if(myCar.speed == 0) {
            myCar.status = carStatus.stop;
        }

        if(myCar.fuelGauage == 0) {
            myCar.status = carStatus.outOfFuel;
        }
    }


    // * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function turnOff() public {
        require(myCar.speed == 0 && myCar.status != carStatus.turnedOff);
        myCar.status = carStatus.turnedOff;
    }


    // * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function turnOn() public {
        require(myCar.status == carStatus.turnedOff && myCar.fuelGauage > 0);
        myCar.status = carStatus.stop;
    }


    // * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function fillFuel() public {

    }

}

/* 내가 한 것과 정답 차이점
car라는 구조체를 따로 선언해서 사용(차상태, 속도)


*/