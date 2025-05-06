// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AuctionHouse {
    address public owner;
    uint256 public auctionEndTime;
    string public item;
    address private highestBidder;
    uint256 private highestBid;
    bool public ended;
    mapping(address => uint256) public bids;
    address[] public bidders;

    constructor(string memory _item, uint256 _biddingTime) {
        owner = msg.sender;
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function bid(uint256 _amount) external payable {
        require(block.timestamp < auctionEndTime, "Auction has already ended");
        require(_amount > 0, "Cant bid zero");
        require(_amount > bids[msg.sender], "Bids must be higher than your previous bid");

        if (bids[msg.sender] == 0) {
            bidders.push(msg.sender);
        }
        bids[msg.sender] = _amount;
        if (_amount > highestBid) {
            highestBid = _amount;
            highestBidder = msg.sender;
        }
    }

    function endAuction() external {
        require(block.timestamp >= auctionEndTime, "Auction has not ended");
        require(!ended, "Auction end has already been called");

        ended = true;
    }

    function getWinner() external view returns (address, uint256) {
        require(ended, "auction hasnt ended yet");
        return (highestBidder, highestBid);
    }

    function getAllBidders() public view returns (uint256, address[] memory) {
        return (bidders.length, bidders);
    }

    function withdraw() public {
        require(ended, "Auction must be ended before withdrawing");
        require(msg.sender != highestBidder, "Winner cannot withdraw");

        uint256 amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}
