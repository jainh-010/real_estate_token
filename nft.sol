// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstate is ERC721, Ownable {
    uint256 public tokenCounter;
    
    mapping(string => bool) _propertyexists;
    mapping (uint256 => string) private _tokenURIs;

    constructor() ERC721("RealEstate", "RST") {
    tokenCounter = 0;
  }
  
  //Function to create the NFT token withs its metadata
  function createnft(string memory tokenURI ) public onlyOwner returns (uint256) {
      require(!_propertyexists[tokenURI]);
    uint256 tokenId = tokenCounter;
    _safeMint(msg.sender, tokenId);
    _setTokenURI(tokenId, tokenURI);
    _propertyexists[tokenURI] = true;
    tokenCounter = tokenCounter + 1;
    return tokenId;
  }
  
//function tp set the metadta of tokens

function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
    
//function to transfer the token     
    function ttranfer(address to, uint256 tokenId) public payable {
        require(to != msg.sender);
        //require(msg.value > 0);
        _safeMint(to, tokenId);
    }
    
//function to transfer the amount of the contract to the deployer
    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Nil balance");
        payable(owner()).transfer(address(this).balance);
        
    }
}