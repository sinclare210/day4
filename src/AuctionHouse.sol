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

    constructor (string memory _item, uint256 _biddingTime) {
        owner = msg.sender;
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime;

    }

    function  bid (uint256 _auctionEndTime, uint256 _amount) external {
        require(block.timestamp < auctionEndTime, "Auction has already ended");
        require(_amount > 0, "Cant bid zero");
        require(_amount > bids[msg.sender], "Bids must be higher than your previous bid");

        if(bids[msg.sender] == 0){
            bidders.push(msg.sender);


        }
        bids[msg.sender] = _amount;
        if(_amount > highestBid){
            highestBid = _amount;
            highestBidder = msg.sender;
        }

       
    }

     function endAuction () external{
        require(block.timestamp >= auctionEndTime, "Auction has not ended");
        require(!ended, "Auction end has already been called");

        ended = true;
    }

}