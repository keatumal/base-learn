// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title Mappings Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/mappings/mappings-exercise
 */

contract FavoriteRecords {
    error NotApproved(string albumName);

    mapping (string => bool) public approvedRecords;
    mapping (address => mapping (string => bool)) public userFavorites;
    mapping (address => string[]) internal userAlbums;
    mapping (address => uint) internal userAlbumsNum;


    // In the beginning, I used this constant wherever I could to save gas.
    // But my contract did not pass the tests. Then, after hours of desperation, I realized that
    // the `getApprovedRecords' function should return a non-fixed length array (string[] memory),
    // and I used this code: ... returns(string[INIT_RECORDS_NUM] memory).
    //
    // Because of this, the tests failed. So I decided not to use this constant.

    // uint constant INIT_RECORDS_NUM = 9;

    string[] initApprovedList = [
        "Thriller",
        "Back in Black",
        "The Bodyguard",
        "The Dark Side of the Moon",
        "Their Greatest Hits (1971-1975)",
        "Hotel California",
        "Come On Over",
        "Rumours",
        "Saturday Night Fever"
    ];

    constructor() {
        for (uint i = 0; i < initApprovedList.length; i++) {
            approvedRecords[initApprovedList[i]] = true;
        }
    }

    function getApprovedRecords() external view returns(string[] memory) {
        return initApprovedList;
    }

    function addRecord(string calldata _albumName) external {
        if (!approvedRecords[_albumName]) {
            revert NotApproved(_albumName);
        }
        userFavorites[msg.sender][_albumName] = true;
        userAlbums[msg.sender].push(_albumName);
        userAlbumsNum[msg.sender]++;
    }

    function getUserFavorites(address _userAddress) public view returns(string[] memory) {
        uint albumsNum = userAlbumsNum[_userAddress];
        if (albumsNum == 0) {
            return(new string[](0));
        }
        string[] memory result = new string[](albumsNum);

        for (uint i = 0; i < albumsNum; i++) {
            result[i] = userAlbums[_userAddress][i];
        }
        return result;
    }

    function resetUserFavorites() external {
        uint albumsNum = userAlbumsNum[msg.sender];

        for (uint i = 0; i < albumsNum; i++) {
            userFavorites[msg.sender][userAlbums[msg.sender][i]] = false;
        }

        userAlbums[msg.sender] = new string[](0);
        userAlbumsNum[msg.sender] = 0;
    }
}