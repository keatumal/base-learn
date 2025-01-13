// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

import "./SillyStringUtils.sol";

/**
 * @title Imports Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/imports/imports-exercise
 */

contract ImportsExercise {

    using SillyStringUtils for SillyStringUtils.Haiku;

    SillyStringUtils.Haiku public haiku;

    function saveHaiku(
        string calldata _line1,
        string calldata _line2,
        string calldata _line3
    )
        external
    {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    function getHaiku() external view returns(SillyStringUtils.Haiku memory) {
        return haiku;
    }
    
    function shruggieHaiku() external view returns(SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory result = haiku;
        result.line3 = SillyStringUtils.shruggie(result.line3);
        return result;
    }
}