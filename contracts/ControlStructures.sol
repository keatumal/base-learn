// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title Control Structures Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/control-structures/control-structures-exercise
 */

contract ControlStructures {
    error AfterHours(uint _time);

    // Create a function called fizzBuzz that accepts a uint called _number and returns a string memory.
    // The function should return:
    //
    // - "Fizz" if the _number is divisible by 3
    // - "Buzz" if the _number is divisible by 5
    // - "FizzBuzz" if the _number is divisible by 3 and 5
    // - "Splat" if none of the above conditions are true
    function fizzBuzz(uint _number) public pure returns (string memory) {
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        } else if (_number % 3 == 0) {
            return "Fizz";
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }


    // Create a function called doNotDisturb that accepts a uint called _time, and returns a string memory.
    // It should adhere to the following properties:
    //
    // - If _time is greater than or equal to 2400, trigger a panic
    // - If _time is greater than 2200 or less than 800, revert with a custom error of AfterHours, and include the time provided
    // - If _time is between 1200 and 1259, revert with a string message "At lunch!"
    // - If _time is between 800 and 1199, return "Morning!"
    // - If _time is between 1300 and 1799, return "Afternoon!"
    // - If _time is between 1800 and 2200, return "Evening!"
    function doNotDisturb(uint _time) public pure returns (string memory) {
        assert(_time < 2400);
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        } else if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        } else if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        } else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }
        // There's only one possible scenario left: _time >= 1800 && _time <= 2200
        return "Evening!";
    }
}