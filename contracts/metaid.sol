//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.6;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MetaId is ERC721, Ownable, ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  string public metadataFolderURI;
  mapping(address => uint256) public minted;
  bool public mintActive;
  uint256 public mintsPerAddress;
  string public openseaContractMetadataURL;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _metadataFolderURI,
    uint256 _mintsPerAddress,
    string memory _openseaContractMetadataURL,
    bool _mintActive
  ) ERC721(_name, _symbol) {
    metadataFolderURI = _metadataFolderURI;
    mintsPerAddress = _mintsPerAddress;
    openseaContractMetadataURL = _openseaContractMetadataURL;
    mintActive = _mintActive;
  }

  function setMetadataFolderURI(string calldata folderUrl) public onlyOwner {
    metadataFolderURI = folderUrl;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721URIStorage: token DNE");
    return string(abi.encodePacked(metadataFolderURI, Strings.toString(tokenId)));
  }

  function contractURI() public view returns (string memory) {
    return openseaContractMetadataURL;
  }

  function mint() public nonReentrant {
    require(mintActive == true, "mint is not active rn..");
    require(minted[msg.sender] < mintsPerAddress, "only 1 mint per wallet address");

    _tokenIds.increment();

    minted[msg.sender]++;

    uint256 tokenId = _tokenIds.current();
    _safeMint(msg.sender, tokenId);
  }

  function mintedCount() external view returns (uint256) {
    return _tokenIds.current();
  }

  function setMintActive(bool _mintActive) public onlyOwner {
    mintActive = _mintActive;
  }
}