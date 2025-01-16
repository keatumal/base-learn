// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

/**
 * @title ERC-20 Tokens Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/erc-20-token/erc-20-exercise
 */

import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WeightedVoting is ERC20 {

    using EnumerableSet for EnumerableSet.AddressSet;

    string constant TOKEN_NAME = "Weighted Voting";
    string constant TOKEN_SYMBOL = "WV";

    uint constant MAX_SUPPLY = 1_000_000;
    uint public maxSupply;

    uint constant CLAIM_AMOUNT = 100;
    uint totalClaimed;
    mapping(address => bool) isUserClaimed;


    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }
    Issue[] issues;

    struct IssueView {
        address[] voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    enum Vote { AGAINST, FOR, ABSTAIN }

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint amount);
    error AlreadyVoted();
    error VotingClosed();
    error InvalidIssueId(uint id);

    modifier validIssueId(uint _id) {
        if (_id >= issues.length) {
            revert InvalidIssueId(_id);
        }
        _;
    }

    modifier tokenHolder(address _user) {
        if (balanceOf(_user) == 0) {
            revert NoTokensHeld();
        }
        _;
    }

    constructor()
        ERC20(TOKEN_NAME, TOKEN_SYMBOL)
    {
        maxSupply = MAX_SUPPLY;

        Issue storage burntIssue = issues.push();
        burntIssue.closed = true;
    }

    function claim() public {
        if (isUserClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        uint newTotalClaimed = totalClaimed + CLAIM_AMOUNT;
        if (newTotalClaimed > MAX_SUPPLY) {
            revert AllTokensClaimed();
        }

        totalClaimed = newTotalClaimed;
        _update(address(0), msg.sender, CLAIM_AMOUNT);
        isUserClaimed[msg.sender] = true;
    }

    function createIssue(string calldata _desc, uint _quorum)
        external tokenHolder(msg.sender) returns(uint)
    {
        if (_quorum > MAX_SUPPLY) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _desc;
        newIssue.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint _id) external view validIssueId(_id) returns (IssueView memory) {
        Issue storage issue = issues[_id];
        IssueView memory issueView = IssueView({
            voters: issue.voters.values(),
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
        return issueView;
    }

    function vote(uint _issueId, Vote _vote) public
        validIssueId(_issueId) tokenHolder(msg.sender)
    {
        Issue storage issue = issues[_issueId];
        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        issue.voters.add(msg.sender);
        uint voteWeight = balanceOf(msg.sender);

        if (_vote == Vote.FOR) {
            issue.votesFor += voteWeight;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voteWeight;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voteWeight;
        }
        issue.totalVotes += voteWeight;

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}