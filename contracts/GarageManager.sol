// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title Structs Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/structs/structs-exercise
 */

contract GarageManager {

    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    error BadCarIndex(uint carIndex);

    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint _numberOfDoors
    )
        external
    {
            Car memory car = Car({
                make: _make,
                model: _model,
                color: _color,
                numberOfDoors: _numberOfDoors
            });

            garage[msg.sender].push(car);
    }

    function getMyCars() public view returns(Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _userAddress) public view returns(Car[] memory) {
        return garage[_userAddress];
    }

    function updateCar(
        uint _index,
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint _numberOfDoors
    )
        external
    {
            if (_index >= garage[msg.sender].length) {
                revert BadCarIndex(_index);
            }

            Car memory car = Car({
                make: _make,
                model: _model,
                color: _color,
                numberOfDoors: _numberOfDoors
            });

            garage[msg.sender][_index] = car;
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}