pragma solidity ^0.8.6;

/* SPDX-License-Identifier: MIT */

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Character is ERC721Enumerable, ReentrancyGuard, Ownable {
  // Define minting rules
  bool public _mintActive = true;
  uint256 private _price = 0.04 ether;
  uint256 private _publicIssued = 0;

  // Define owner address
  address ownerAddress = 0xa27999aEE6d546004fA37CfDf372a922aB1C7Eff;

  // Define address for GiveDirectly
  // https://www.givedirectly.org/crypto/
  address giveDirectlyAddress = 0x750EF1D7a0b4Ab1c97B7A623D7917CcEb5ea779C;

  // Define token components
  string[] private raceLegendary = [
    "Fairy",
    "Djinn",
    "Demon",
    "Angel"
  ];

  string[] private raceRare = [
    "Dark Elf",
    "Centaur",
    "Giant",
    "Halfling",
    "Vampire",
    "Alien"
  ];

  string[] private raceUncommon = [
    "Elf",
    "Dwarf",
    "Gnome",
    "Goblin",
    "Robot"
  ];

  string[] private raceCommon = [
    "Human",
    "Orc",
    "Undead",
    "Ape Folk",
    "Cat Folk",
    "Lizard Folk"
  ];
  
  string[] private role = [
    "Artist",
    "Bard",
    "Dancer",
    "Influencer",
    "Chef",
    "Sculptor",
    "Explorer",
    "Scout",
    "Pirate",
    "Astronaut",
    "Pilot",
    "Mage",
    "Healer",
    "Enchanter",
    "Necromancer",
    "Summoner",
    "Martial Artist",
    "Monk",
    "Yogi",
    "Merchant",
    "Investor",
    "Patron of the Arts",
    "Telepath",
    "Telekinetic",
    "Shapeshifter",
    "Ranger",
    "Beast Master",
    "Hunter",
    "Detective",
    "Rogue",
    "Thief",
    "Assassin",
    "Ninja",
    "Spy",
    "Tech",
    "Alchemist",
    "Engineer",
    "Inventor",
    "Scientist",
    "Hacker",
    "Blacksmith",
    "Warrior",
    "Paladin",
    "Knight",
    "Samurai",
    "Demon Slayer",
    "Berserker"
  ];

  string[] private elementsCommon = [
    "Fire",
    "Wind",
    "Earth",
    "Water"
  ];

  string[] private elementsUncommon = [
    "Lightning",
    "Metal",
    "Poison"
  ];

  string[] private elementsRare = [
    "Light",
    "Dark"
  ];

  string[] private elementsLegendary = [
    "Chaos",
    "Gravity",
    "Time"
  ];

  function mintPublic(uint256 numToMint) public payable nonReentrant {
    require(_mintActive, "Public minting is paused.");
    require(_publicIssued + numToMint < (block.number / 10) + 1, "No Characters to mint now.");
    require(msg.value >= _price * numToMint, "Not enough ether sent" );

    for (uint256 index = 0; index < numToMint; index++) {
      _publicIssued += 1;
      _safeMint( msg.sender, _publicIssued );
    }
  }
  
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }
  
  function getRace(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("RACE", toString(tokenId))));
    uint256 tokenIdProbScore = (rand % 10000);

    // The probability of minting legendary and rare races decreases over time until
    // tokenId 50,000 has been minted. At that point, the probability stabilizes.
    // The probability of uncommon races stay constant, and as a result, the probability
    // of a common race increases over time and also stabilizes after 50,000.
    uint256 stabilizingPop = 50000;
    uint256 legendaryProb;
    uint256 rareProb;
    uint256 uncommonProb = 3500;

    if (tokenId < stabilizingPop) {
      legendaryProb = (stabilizingPop - tokenId + 999) / 100;
      rareProb = ((4 * (stabilizingPop - tokenId)) + 49000) / 100;
    } else {
      legendaryProb = 10;
      rareProb = 490;
    }

    if (tokenIdProbScore > legendaryProb + rareProb + uncommonProb) {
      return raceCommon[rand % raceCommon.length];
    } else if (tokenIdProbScore > legendaryProb + rareProb) {
      return raceUncommon[rand % raceUncommon.length];
    } else if (tokenIdProbScore > legendaryProb) {
      return raceRare[rand % raceRare.length];
    } else {
      return raceLegendary[rand % raceLegendary.length];
    }
  }

  function getRole(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("ROLE", toString(tokenId))));
    uint8 firstRolePosition = uint8(rand % role.length);

    // 10% chance of having a second role
    if ((rand % 20) > 17) {
      uint256 rand2 = random(string(abi.encodePacked("SECONDROLE", toString(tokenId))));
      uint8 secondRolePosition = uint8(rand2 % role.length);
      if (firstRolePosition != secondRolePosition) {
        return string(abi.encodePacked(role[firstRolePosition], " + ", role[secondRolePosition]));
      }
    }

    return role[firstRolePosition];
  }

  function getElementName(uint8 probScore, uint256 rand) internal view returns (string memory) {
    if (probScore < 65) {
      return elementsCommon[rand % elementsCommon.length];
    } else if (probScore < 90) {
      return elementsUncommon[rand % elementsUncommon.length];
    } else if (probScore < 99) {
      return elementsRare[rand % elementsRare.length];
    } else {
      return elementsLegendary[rand % elementsLegendary.length];
    }
  }

  function getElement(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("ELEMENT", toString(tokenId))));
    uint8 firstProbScore = uint8(rand % 100);

    // 10% probability of having two element affinities
    if ((rand % 20) > 17) {
      uint256 rand2 = random(string(abi.encodePacked("SECONDELEMENT", toString(tokenId))));
      uint8 secondProbScore = uint8(rand2 % 100);
      return string(abi.encodePacked(getElementName(firstProbScore, rand), " + ", getElementName(secondProbScore, rand2)));
    } 

    return getElementName(firstProbScore, rand);
  }

  function tokenURI(uint256 tokenId) override public view returns (string memory) {
    string memory charRace = getRace(tokenId);
    string memory charRole = getRole(tokenId);
    string memory charElement = getElement(tokenId); 

    // Create SVG image for tokenURI
    string[10] memory parts;
    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
    parts[1] = '<style>.text { fill: white; font-family: serif; font-size: 14px; } .header-text { font-weight: bold; } .header-background { fill: #333; height: 30px; width: 100%; }</style>';
    parts[2] = '<rect width="100%" height="100%" fill="black" />';
    parts[3] = '<rect y="0" class="header-background" /><text x="10" y="20" class="text header-text">Race</text><text x="10" y="50" class="text">';
    parts[4] = charRace;
    parts[5] = '</text><rect y="80" class="header-background" /><text x="10" y="100" class="text header-text">Role</text><text x="10" y="130" class="text">';
    parts[6] = charRole;
    parts[7] = '</text><rect y="160" class="header-background" /><text x="10" y="180" class="text header-text">Element</text><text x="10" y="210" class="text">';
    parts[8] = charElement;
    parts[9] = '</text></svg>';
    string memory svg = string(
      abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8], parts[9])
    );

    // Create full tokenURI with name, description, attributes, and svg
    return string(
      abi.encodePacked(
        'data:application/json;base64,',
        Base64.encode(
          bytes(
            string(
              abi.encodePacked(
                '{"name": "Character #',
                toString(tokenId),
                '", "attributes": [{ "trait_type": "Race", "value": "', 
                charRace,
                '" }, { "trait_type": "Role", "value": "',
                charRole,
                '" }, { "trait_type": "Element", "value": "',
                charElement,
                '" }], "description": "Character is a randomized RPG identity generated and stored on chain. Identity is composed of race, role, and element affinity. Maximum supply of Characters is dynamic, increasing at 1/10th the block rate of Ethereum. Feel free to use Character in any way you want.", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(svg)),
                '"}'
              )
            )
          )
        )
      )
    );
  }

  function setPrice(uint256 _newPrice) public onlyOwner() {
    _price = _newPrice;
  }

  function getPrice() public view returns (uint256) {
    return _price;
  }

  function setMintStatus(bool newMintStatus) public onlyOwner() {
    _mintActive = newMintStatus;
  }

  function getMintedCount() public view returns (uint256) {
    return _publicIssued;
  }

  function withdraw() public payable onlyOwner() {
    uint256 _each = address(this).balance / 4;

    payable(ownerAddress).transfer(_each * 3);
    // Transfer 25% to Give Directly
    payable(giveDirectlyAddress).transfer(_each);    
  }
  
  function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

    if (value == 0) {
        return "0";
    }
    uint256 temp = value;
    uint256 digits;
    while (temp != 0) {
        digits++;
        temp /= 10;
    }
    bytes memory buffer = new bytes(digits);
    while (value != 0) {
        digits -= 1;
        buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
        value /= 10;
    }
    return string(buffer);
  }
  
  constructor() ERC721("Character", "CHAR") Ownable() {}
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
  bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  /// @notice Encodes some bytes to the base64 representation
  function encode(bytes memory data) internal pure returns (string memory) {
    uint256 len = data.length;
    if (len == 0) return "";

    // multiply by 4/3 rounded up
    uint256 encodedLen = 4 * ((len + 2) / 3);

    // Add some extra buffer at the end
    bytes memory result = new bytes(encodedLen + 32);

    bytes memory table = TABLE;

    assembly {
      let tablePtr := add(table, 1)
      let resultPtr := add(result, 32)

      for {
          let i := 0
      } lt(i, len) {

      } {
        i := add(i, 3)
        let input := and(mload(add(data, i)), 0xffffff)

        let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
        out := shl(8, out)
        out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
        out := shl(8, out)
        out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
        out := shl(8, out)
        out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
        out := shl(224, out)

        mstore(resultPtr, out)

        resultPtr := add(resultPtr, 4)
      }

      switch mod(len, 3)
      case 1 {
          mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
      }
      case 2 {
        mstore(sub(resultPtr, 1), shl(248, 0x3d))
      }

      mstore(result, encodedLen)
    }

    return string(result);
  }
}
