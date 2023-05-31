// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
시험시간: 35분

자리수랑 숫자가 같아야함

로또 프로그램을 만드려고 합니다. 숫자와 문자는 각각 4개 2개를 뽑습니다. 
6개가 맞으면 1이더, 5개의 숫자 혹은 문자가 순서와 함께 맞으면 0.75이더, 4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

참가 금액은 0.05이더이다.

기준 숫자 : 1,2,3,4,A,B
-----------------------------------------------------------------
기준 숫자 설정 기능 : 5개의 사람이 임의적으로 4개의 숫자와 2개의 문자를 넣음. 5명이 넣은 숫자들의 중앙값과 알파벳 순으로 따졌을 때 가장 가운데 문자로 설정
예) 숫자들의 중앙값 : 1,3,6,8,9 -> 6 // 2,3,4,8,9 -> 4
예) 문자들의 중앙값 : a,b,e,h,l -> e // a,h,i,q,z -> i 

*/


contract lotto {
    function lottoGame(uint a, uint b, uint c, uint d, string memory e, string memory f) public payable returns(string memory) {
        require(msg.value == 0.05 ether, "give me 0.05eth !");

        a += 48;
        b += 48;
        c += 48;
        d += 48;

        return string(abi.encodePacked(a,b,c,d,e,f));

        // 6개
        if(keccak256(bytes(string(abi.encodePacked(a,b,c,d,e,f)))) == keccak256(bytes("1234AB"))) {
            payable(msg.sender).transfer(1 ether);
        } 
        // 5개
        if(keccak256(bytes(string(abi.encodePacked(a,b,c,d,e)))) == keccak256(bytes("1234A")) && keccak256(bytes(string(abi.encodePacked(b,c,d,e,f)))) == keccak256(bytes("234AB"))) {
            payable(msg.sender).transfer(0.75 ether);
        }
        
    }
}






contract Q8 {
    uint[] numbers = [1,2,3,4];
    string[] letters = ["a", "b"];

    // 로또 번호 입력, 맞추는기능 - 유저가 로또 번호를 입력하는 기능, 로또 번호를 맞추는 기능
    function setLotto(uint[] calldata _numbers, string[] calldata _letters) public payable {
        require(msg.value==0.05 ether);
        uint fit = isSameNumber(_numbers) + isSameLetter(_letters);
        getPrize(fit);
    }
    
    function getPrize(uint _n) private /*public으로 하면 자선사업가*/ {
        if(_n==6) {
            payable(msg.sender).transfer(1 ether);
        } else if(_n==5) {
            payable(msg.sender).transfer(0.75 ether);
        } else if(_n==4) {
            payable(msg.sender).transfer(0.25 ether);
        } else if(_n==3) {
            payable(msg.sender).transfer(0.1 ether);
        }
    }

    // 숫자배열 비교하기 - 각 자리 for돌려서 count 세기기
    function isSameNumber(uint[] calldata _myNumber) public view returns(uint) {
        uint count;
        for(uint i=0; i<numbers.length; i++) {
            if(numbers[i]==_myNumber[i]) {
                count++;
            }
        }
        return count;
    }

    function isSameLetter(string[] calldata _myLetter) public view returns(uint) {
        uint count;
        for(uint i=0; i<letters.length; i++) {
            if(letterCompare(letters[i], _myLetter[i])) {
                count++;
            }
        }
        return count;
    }

    // 문자배열 비교하기 - keccak256(abi.encodePacked(문자열)) 이용해서 비교 후 위와 같이 for돌려서 count 갱신
    function letterCompare(string memory _a, string calldata _b) public pure returns(bool) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }
}





contract Q8_2 {
    string[] public letters;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // 숫자랑 문자랑 섞여있으니까 차라리 숫자를 문자로 바꿔서 한번에 처리하는것이 좋음(solidity로 자료를 넘기기전에 js에서 처리 후 받았다고 가정)
    function setTargetNumber(string[] memory _letters) public {
        require(owner == msg.sender);
        letters = _letters;
    }

    // 로또 번호 입력, 맞추는기능 - 유저가 로또 번호를 입력하는 기능, 로또 번호를 맞추는 기능
    function setLotto(string[] calldata _letters) public payable {
        require(msg.value==0.05 ether);
        uint fit = isSameLetter(_letters);
        getPrize(fit);
    }

    function getPrize(uint _n) private /*public으로 하면 자선사업가*/ {
        if(_n==6) {
            payable(msg.sender).transfer(1 ether);
        } else if(_n==5) {
            payable(msg.sender).transfer(0.75 ether);
        } else if(_n==4) {
            payable(msg.sender).transfer(0.25 ether);
        } else if(_n==3) {
            payable(msg.sender).transfer(0.1 ether);
        }
    }

    function isSameLetter(string[] calldata _myLetter) public view returns(uint) {
        uint count;
        for(uint i=0; i<letters.length; i++) {
            if(letterCompare(letters[i], _myLetter[i])) {
                count++;
            }
        }
        return count;
    }

    function letterCompare(string memory _a, string calldata _b) public pure returns(bool) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }
}




// string을 input으로 받아서 bytes1배열로 변경 후 순서를 sorting해주고 중간값을 구하여 a라는 string배열에 넣는다.
contract Q8_3 {
    // 로또 번호 설정 기능
    string[6] targetLetters;

    function setLotto(string[] memory _set1, string[] memory _set2, string[] memory _set3, string[] memory _set4, string[] memory _set5, string[] memory _set6) public {
        targetLetters[0] = string(abi.encodePacked(getMedian_Number(stringArrayToBytes1Array(_set1))));
        targetLetters[1] = string(abi.encodePacked(getMedian_Number(stringArrayToBytes1Array(_set2))));
        targetLetters[2] = string(abi.encodePacked(getMedian_Number(stringArrayToBytes1Array(_set3))));
        targetLetters[3] = string(abi.encodePacked(getMedian_Number(stringArrayToBytes1Array(_set4))));
        targetLetters[4] = string(abi.encodePacked(getMedian_Number(stringArrayToBytes1Array(_set5))));
        targetLetters[5] = string(abi.encodePacked(getMedian_Number(stringArrayToBytes1Array(_set6))));
    }

    function stringArrayToBytes1Array(string[] memory _a) public pure returns(bytes1[] memory) {
        uint _n = _a.length;
        bytes1[] memory _b = new bytes1[](_n);
        for(uint i=0; i<_n;i++) {
            _b[i] = abi.encodePacked(_a[i])[0];
        }
        return _b;
    }

    function bytesAverage(bytes1 a, bytes1 b) public pure returns(bytes1) {
        return bytes1((uint8(a) + uint8(b))/2);
    }
 
    function getMedian_Number(bytes1[] memory numbers) public pure returns(bytes1){
        uint _l = numbers.length;
        for(uint i=0;i<_l-1;i++) {
            for(uint j=i+1; j<_l ;j++) {
                if(numbers[i] < numbers[j]) {
                    (numbers[i], numbers[j]) = (numbers[j], numbers[i]);
                }
            }
        }
        if(_l %2 ==0) {
            return bytesAverage(numbers[_l/2-1], numbers[_l/2]);
        } else {
            return (numbers[_l/2]);
        }
    }

    // 로또 번호 입력, 맞추는기능 - 유저가 로또 번호를 입력하는 기능, 로또 번호를 맞추는 기능
    function setLotto(string[] calldata _letters) public payable {
        require(msg.value==0.05 ether);
        uint fit = isSameLetter(_letters);
        getPrize(fit);
    }

    function getPrize(uint _n) private /*public으로 하면 자선사업가*/ {
        if(_n==6) {
            payable(msg.sender).transfer(1 ether);
        } else if(_n==5) {
            payable(msg.sender).transfer(0.75 ether);
        } else if(_n==4) {
            payable(msg.sender).transfer(0.25 ether);
        } else if(_n==3) {
            payable(msg.sender).transfer(0.1 ether);
        }
    }

    function isSameLetter(string[] calldata _myLetter) public view returns(uint) {
        uint count;
        for(uint i=0; i<targetLetters.length; i++) {
            if(letterCompare(targetLetters[i], _myLetter[i])) {
                count++;
            }
        }
        return count;
    }

    function letterCompare(string memory _a, string calldata _b) public pure returns(bool) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }
}


contract BytesCompare {
    bytes1 a = 0x12;
    bytes1 b = 0x23;

    function compare() public view returns(bool) {
        return b>a;
    }

    function compare2(bytes1 _a, bytes1 _b) public pure returns(bool) {
        return _b>_a;
    }
    // bytes1들끼리는 비교가 가능하다

    // bytes는 동적이리서 비교 불가!
    // function compare3(bytes memory _a, bytes memory _b) public pure returns(bool) {
    //     return _b>_a;
    // }

    // bytes1은 uint8로 변환가능능
    function bytes1ToUint(bytes1 _a) public pure returns(uint8) {
        return uint8(_a);
    }

    function uintToBytes1(uint8 _a) public pure returns(bytes1) {
        return bytes1(_a);
    }

    function bytesAdd() public view returns(bytes1) {
        return bytes1((uint8(a) + uint8(b))/2);
    }

}