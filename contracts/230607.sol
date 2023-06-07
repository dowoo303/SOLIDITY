// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


// 한 컨트랙트 안에서 여러개 토큰 관리해보기
contract RAINBOW is ERC1155 {
    // token ID 부여
    uint public constant Red = 1;
    uint public constant Yellow = 2;
    uint public constant Green = 3;
    uint public constant Blue = 4;
    uint public constant Purple = 5;
    string public baseUri;

    // https://gateway.pinata.cloud/ipfs/QmQy6FtvULG59vcddBaLVMC9PRyriZpseDQhJVB65PNtUN
    constructor(string memory _baseUri) ERC1155(_baseUri) {     // =constructor() ERC1155("https://gateway.pinata.cloud/ipfs/QmQy6FtvULG59vcddBaLVMC9PRyriZpseDQhJVB65PNtUN") 
        baseUri = _baseUri;
        // 263번째줄
        _mint(msg.sender, Red, 5, "");
        _mint(msg.sender, Yellow, 5, "");
        _mint(msg.sender, Green, 5, "");
        _mint(msg.sender, Blue, 5, "");
        _mint(msg.sender, Purple, 5, "");
    }

    // 토큰 ID에 맞는 json 경로 string 형태로 받아오기
    function uri(uint tokenId) override public view returns(string memory) {
        // 56번째 줄
        return string(abi.encodePacked(baseUri,"/", Strings.toString(tokenId), ".json"));
    }

    // 원하는 수량만큼 민팅 가능
    function mintToken(uint _id, uint _amount) public {
        _mint(msg.sender, _id, _amount, "");
    }

    // 내 지갑주소 복사
    function getBatchAddresses(uint a) public view returns(address[] memory) {
        address[] memory _list = new address[](a);
        for(uint i=0; i<a; i++) {
            _list[i] = msg.sender;
        }
        return _list;
    }

    // 수량을 보고 싶은 토큰 ID를 배열로 넣으면 가르쳐줌
    function getBalanceOfBatch(uint[] memory _tokenIds) public view returns(uint[] memory) {
        // 78번째 줄
        return balanceOfBatch(getBatchAddresses(_tokenIds.length), _tokenIds);
    }
}





// 변수 이름을 부여하지 않은 인풋 값을 넣는 이유? -> 만들때는 사용하지 않지만 나중에 상속받은 함수에서 사용이 필요할 경우를 대비하는 것이다
contract A {
    function getAB(uint _a, uint) public virtual pure returns(uint) {
        /*
        중요한 식
        */
        return _a;
    }
}
contract B is A {
    function getAB(uint _a, uint _b) public override pure returns(uint) {
        // _a와 _b의 대소비교
        /*
        중요한 식
        */
        return _b;
    }
}

// 아웃풋에 이름을 넣는 이유? -> 코드의 가독성이 좋아짐
contract C {
    function getAB() public pure returns(uint a, uint b) {
        a = 1;
        b = 2;
    }

    function getString(string memory _a) public pure returns(string memory) {
        string memory _b = "abc";
        string memory c = string.concat(_a, _b);
        return c;
    }

    function getString2(string memory _a) public pure returns(string memory c) {
        string memory _b = "abc";
        c = string.concat(_a, _b);
    }
}