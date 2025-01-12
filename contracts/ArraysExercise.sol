// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title Arrays Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/arrays/arrays-exercise
 */

contract ArraysExercise {
    // January 1, 2000, 12:00am
    uint constant Y2K_TIMESTAMP = 946702800;

    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] public senders;
    uint[] timestamps;

    function getNumbers() external view returns (uint[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function resetTimestamps() public {
        timestamps = new uint[](0);
    }

    function resetSenders() public {
        senders = new address[](0);
    }

    function appendToNumbers(uint[] calldata _toAppend) external {
        // I tested with two options:
        //
        // 1. [1,2,3,4,5,6,7,8,9,10]
        // 2. [1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10]
        
        // Gas usage:
        //
        // 1. 291,348
        // 2. 1,334,214
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }


        // Gas usage:
        //
        // 1. 322,175
        // 2. 1,394,975

        // uint numbersLength = numbers.length;
        // uint totalLength = numbersLength + _toAppend.length;
        // uint[] memory result = new uint[](totalLength);
        // uint i;

        // for (i = 0; i < numbersLength; i++) {
        //     result[i] = numbers[i];
        // }

        // for (i = 0; i < _toAppend.length; i++) {
        //     result[numbersLength + i] = _toAppend[i];
        // }
        // numbers = result;
    }

    function saveTimestamp(uint _unixTimestamp) external {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function _countTimestamps(uint _afterMe) internal view returns(uint) {
        uint result = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > _afterMe) {
                result++;
            }
        }

        return result;
    }

    function afterY2K() public view returns (
        uint[] memory timestampsAfterY2K,
        address[] memory sendersAfterY2K) {

        // It is assumed that `timestamps' and `senders' are always the same length
        // and their indexes are synchronized.
        
        uint y2kTimestampsLength = _countTimestamps(Y2K_TIMESTAMP);
        if (y2kTimestampsLength == 0) {
            return(new uint[](0), new address[](0));
        }

        uint[] memory resultTimestamps = new uint[](y2kTimestampsLength);
        address[] memory resultSenders = new address[](y2kTimestampsLength);
        uint counter = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K_TIMESTAMP) {
                resultTimestamps[counter] = timestamps[i];
                resultSenders[counter] = senders[i];
                counter++;
            }
        }

        return(resultTimestamps, resultSenders);
    }
}