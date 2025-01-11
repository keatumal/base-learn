// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title Storage Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/storage/storage-exercise
 */

contract EmployeeStorage {
    error TooManyShares(uint totalShares);

    // The contract should have the following state variables, optimized to minimize storage:
    //
    // - A private variable shares storing the employee's number of shares owned
    //     Employees with more than 5,000 shares count as directors and are stored in another contract
    // - Public variable name which stores the employee's name
    // - A private variable salary storing the employee's salary
    //     Salaries range from 0 to 1,000,000 dollars
    // - A public variable idNumber storing the employee's ID number
    //     Employee numbers are not sequential, so this field should allow any number up to 2^256-1

    // These two variables take up 40 bits and can be packed
    uint16 private shares; // type(uint16).max == 65,535
    uint24 private salary; // type(uint24).max == 16,777,215

    uint public idNumber;
    string public name;

    constructor (uint16 _shares, string memory _name, uint24 _salary, uint _idNumber) {
        shares = _shares;
        salary = _salary;
        idNumber = _idNumber;
        name = _name;
    }

    function viewSalary() public view returns (uint24) {
        return salary;
    }

    function viewShares() public view returns (uint16) {
        return shares;
    }

    // Add a public function called grantShares that increases the number of shares allocated to an employee by _newShares.
    // It should:
    //
    // - Add the provided number of shares to the shares
    // - If this would result in more than 5000 shares, revert with a custom error called TooManyShares
    //   that returns the number of shares the employee would have with the new amount added
    // - If the number of _newShares is greater than 5000, revert with a string message, "Too many shares"
    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        uint newTotal = shares + _newShares;
        if (newTotal > 5000) {
            revert TooManyShares(newTotal);
        }
        shares = uint16(newTotal);
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}