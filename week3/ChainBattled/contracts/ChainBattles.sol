// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => Warrior) public tokenIdToWarrior;

    struct Warrior {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }
   

    
    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function random(uint256 number) public view returns(uint256[4] memory){
        uint256[4] memory  numbers;
        for (uint256 i = 0; i < 4; i++){
            numbers[i] =uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number; 
        }
        return numbers; 
    }

    function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    uint256[4] memory rns = random(20);
    tokenIdToWarrior[newItemId].level = 1;
    tokenIdToWarrior[newItemId].speed = 40 + rns[0];
    tokenIdToWarrior[newItemId].strength = rns[2];
    tokenIdToWarrior[newItemId].life = rns[1]*2;
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
    Warrior memory currentWarrior = tokenIdToWarrior[tokenId];
    //tokenIdToWarrior[tokenId] = currentWarrior +1 ;
    _setTokenURI(tokenId, getTokenURI(tokenId));
}

function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed ",getSpeed(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength ",getStrength(tokenId),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life ",getLife(tokenId),'</text>','</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }

function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToWarrior[tokenId].level;
    return levels.toString();
}
function getSpeed(uint256 tokenId) public view returns (string memory) {
    uint256 speed = tokenIdToWarrior[tokenId].speed;
    return speed.toString();
}
function getStrength(uint256 tokenId) public view returns (string memory) {
    uint256 strength = tokenIdToWarrior[tokenId].strength;
    return strength.toString();
}
function getLife(uint256 tokenId) public view returns (string memory) {
    uint256 life = tokenIdToWarrior[tokenId].life;
    return life.toString();
}



function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #2', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

}