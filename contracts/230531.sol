// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Mint1_1 is ERC721Enumerable {
    string public URI;

    constructor(string memory _uri) ERC721("LikeLion721", "LL721_1") {
        URI = _uri;
    }

    // 만약 이 함수에 payable을 추가하면 돈을 받고 nft 민팅 가능해짐
    function mintNFT(uint _tokenID) public {
        _mint(msg.sender, _tokenID);            
    }

    function tokenURI(uint _tokenID) public override view returns(string memory) {
        return string(abi.encodePacked(URI, '/', Strings.toString(_tokenID), '.json'));     // 공통적인 부분 /, 숫자, .json 붙여주기
    }
}


// json: https://gateway.pinata.cloud/ipfs/QmdJqN3uRXqJHJSEcoBh9HQLsZNY83HFB4MN6nmgz5F6Am