// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title Minimal Tokens Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/minimal-tokens/minimal-tokens-exercise
 */

contract UnburnableToken {

    uint constant TOTAL_SUPPLY = 100_000_000;
    uint constant CLAIM_AMOUNT = 1000;

    mapping(address => uint) public balances;
    uint public totalSupply;
    mapping(address => bool) internal addressClaimed;
    uint public totalClaimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address to);

    constructor() {
        totalSupply = TOTAL_SUPPLY;
    }

    function claim() public {
        if (addressClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        uint newTotalClaimed = totalClaimed + CLAIM_AMOUNT;
        if (newTotalClaimed > TOTAL_SUPPLY) {
            revert AllTokensClaimed();
        }

        balances[msg.sender] += CLAIM_AMOUNT;
        addressClaimed[msg.sender] = true;
        totalClaimed = newTotalClaimed;
    }

    function safeTransfer(address _to, uint _amount) public {
        if (_to == address(0) || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}