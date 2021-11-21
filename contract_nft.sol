// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstate is ERC721, Ownable,ERC721URIStorage {
    uint256 public tokenCounter;
    
    mapping(string => bool) _propertyexists;
    mapping (uint256 => string) private _tokenURIs;

    constructor() ERC721("RealEstate", "RST") {
    tokenCounter = 0;
  }
  
 
  //Function to create the NFT token withs its metadata
  function createnft(string memory tokenUri )public onlyOwner returns (uint256) {
      require(!_propertyexists[tokenUri]);
    uint256 tokenId = tokenCounter;
    _safeMint(msg.sender, tokenId);
    _setTokenURI(tokenId, tokenUri);
    _propertyexists[tokenUri] = true;
    tokenCounter = tokenCounter + 1;
    return tokenId;
  }
  
//function tp set the metadta of tokens

// function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
//         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
//         _tokenURIs[tokenId] = _tokenURI;
//     }
    
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
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
