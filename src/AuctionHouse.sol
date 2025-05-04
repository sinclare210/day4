// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AuctionHouse {
    string[] data= new string[](2);
    address public owner;
    uint256 public auctionEndTime;
    string public item;
    address private highestBidder;
    uint256 private highestBid;
    bool public ended;
    mapping (address => uint) public bids;
    address[] public bidders;

    constructor () {
        owner = msg.sender;
    }

}