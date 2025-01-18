// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title ERC-721 Tokens Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/erc-721-token/erc-721-exercise
 */

contract HaikuNFT is ERC721 {

    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    Haiku[] public haikus;
    mapping(address sharedWith => uint[] haikuIds) public sharedHaikus;
    uint public counter = 1;

    EnumerableSet.Bytes32Set uniqueLines;

    error HaikuNotUnique();
    error NotYourHaiku(uint haikuId);
    error NoHaikusShared();

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function _lineHash(string calldata _line) internal pure returns(bytes32) {
        return keccak256(abi.encodePacked(_line));
    }

    function mintHaiku(
        string calldata _line1,
        string calldata _line2,
        string calldata _line3
    )
        external
    {
        bytes32 hash1 = _lineHash(_line1);
        bytes32 hash2 = _lineHash(_line2);
        bytes32 hash3 = _lineHash(_line3);

        if (
            uniqueLines.length() > 0 &&
            (
                uniqueLines.contains(hash1) ||
                uniqueLines.contains(hash2) ||
                uniqueLines.contains(hash3)
             )
         ) {
            revert HaikuNotUnique();
        }

        uniqueLines.add(hash1);
        uniqueLines.add(hash2);
        uniqueLines.add(hash3);

        Haiku memory newHaiku = Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        });

        haikus.push(newHaiku);
        _safeMint(msg.sender, counter);
        counter++;
    }

    function shareHaiku(address _to, uint _id) public {
        if (_ownerOf(_id) != msg.sender) {
            revert NotYourHaiku(_id);
        }
        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() public view returns(Haiku[] memory) {
        uint haikusNum = sharedHaikus[msg.sender].length;
        if (haikusNum == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory result = new Haiku[](haikusNum);
        Haiku memory haiku;

        for (uint i = 0; i < haikusNum; i++) {
            // sharedHaikus[msg.sender][i] returns the ID of the haiku
            // I start the `haikus` array with zero, and the IDs of the tokens themselves start with one.
            // So I subtract one to get the index of the `haikus` array.
            haiku = haikus[sharedHaikus[msg.sender][i] - 1];
            result[i] = haiku;
        }

        return result;
    }
}