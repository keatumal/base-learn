// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;


/**
 * @title BasicMath - basic functions exercise contract for Base Learn
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise
 */

contract BasicMath {

    // A function called adder. It must:
    //
    //   - Accept two uint arguments, called _a and _b
    //   - Return a uint sum and a bool error
    //   - If _a + _b does not overflow, it should return the sum and an error of false
    //   - If _a + _b overflows, it should return 0 as the sum, and an error of true
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        if (_a > type(uint).max - _b) {
            return (0, true);
        }
        return (_a + _b, false);
    }

    // A function called subtractor. It must:

    //   - Accept two uint arguments, called _a and _b
    //   - Return a uint difference and a bool error
    //   - If _a - _b does not underflow, it should return the difference and an error of false
    //   - If _a - _b underflows, it should return 0 as the difference, and an error of true
    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        if (_b > _a) {
            return (0, true);
        }
        return (_a - _b, false);
    }
}