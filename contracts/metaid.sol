//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.6;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ValidProjectsInterface {
  function ownerOf(uint256 tokenId) external view returns (address owner);
}

contract MetaId is ERC721, Ownable, ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  string public metadataFolderURI;
  mapping(address => uint256) public minted;
  bool public mintActive;
  uint256 public mintsPerAddress;
  string public openseaContractMetadataURL;
  address[] public validProjectsMint;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _metadataFolderURI,
    uint256 _mintsPerAddress,
    string memory _openseaContractMetadataURL,
    bool _mintActive,
    address[] memory _validProjectsMint
  ) ERC721(_name, _symbol) {
    metadataFolderURI = _metadataFolderURI;
    mintsPerAddress = _mintsPerAddress;
    openseaContractMetadataURL = _openseaContractMetadataURL;
    mintActive = _mintActive;
    validProjectsMint = _validProjectsMint;
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

  function checkValidProjectOwnership(address projectContract, uint256 projectTokenId) internal view returns (bool) {
    bool isValidProject = false;
    for (uint j = 0; j < validProjectsMint.length; j++) {
      if(validProjectsMint[j] == projectContract) {
        isValidProject = true;
      }
    }

    if(isValidProject) {
      return ValidProjectsInterface(projectContract).ownerOf(projectTokenId) == msg.sender;
    }
    
    return false;
  }

  function mint(address validProjectContract, uint256 validProjectTokenID) public nonReentrant {
    require(mintActive == true, "mint is not active rn..");
    require(minted[msg.sender] < mintsPerAddress, "only 1 mint per wallet address");
    require(checkValidProjectOwnership(validProjectContract, validProjectTokenID), "must own NFT in valid project");

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

  function addValidProject(address validProject) public onlyOwner {
    // For a project to be added to this list, it must include the ownerOf function in its contract
    // This is standard for ERC721 contracts
    validProjectsMint.push(validProject);
  }
}