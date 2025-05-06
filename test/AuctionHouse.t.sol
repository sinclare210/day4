// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AuctionHouse} from "../src/AuctionHouse.sol";
import {Test} from "forge-std/Test.sol";

contract AuctionHouseTest is Test {
    AuctionHouse public auctionHouse;
    address public owner;

    function setUp() external {
        auctionHouse = new AuctionHouse("Vintage Clock", 3600);
    }

    function testIfEverythingSetCorrectly() public view {
        assertEq(auctionHouse.owner(), address(this));

        assertEq(auctionHouse.item(), "Vintage Clock");

        assertEq(auctionHouse.auctionEndTime(), block.timestamp + 3600);
    }

    function testBidRequiresIndBids() public {
        assertEq(block.timestamp, 1);
        skip(7200);
        vm.expectRevert();
        auctionHouse.bid(0.1 ether);
        assertEq(block.timestamp, 7201);

        //test if suppose to revrt if the user want to send zero
        vm.expectRevert();
        auctionHouse.bid(0 ether);
    }

    function testIfUserBidsHigherThanFormerBid() public {
        //test it is suppose to revert if the user wants to bid lower than he had bidded before

        auctionHouse.bid(0.5 ether);
        vm.expectRevert();
        auctionHouse.bid(0.1 ether);
    }

    function testTheArrayOfBiiders() public {
        auctionHouse.bid(0.5 ether);

        address sinclair = address(0x1);
        vm.prank(sinclair);
        auctionHouse.bid(1 ether);

        assertEq(auctionHouse.bidders(0), address(this));
        assertEq(auctionHouse.bidders(1), sinclair);
    }

    function tesstGetAllBidders() public {
        auctionHouse.bid(0.5 ether);

        address sinclair = address(0x1);
        vm.prank(sinclair);
        auctionHouse.bid(1 ether);

        assertEq(auctionHouse.bidders(0), address(this));
        assertEq(auctionHouse.bidders(1), sinclair);

        (uint256 people, address[] memory addy) = auctionHouse.getAllBidders();
        assertEq(people, 2);
        assertEq(addy[0], address(this));
        assertEq(addy[1], sinclair);
    }

    function testGetWinner() public {
        auctionHouse.bid(0.5 ether);

        address sinclair = address(0x1);
        vm.prank(sinclair);
        auctionHouse.bid(1 ether);

        skip(3600); // Skip to end of auction
        auctionHouse.endAuction(); // End auction manually

        (address addy, uint256 amount) = auctionHouse.getWinner();
        assertEq(addy, sinclair);
        assertEq(amount, 1 ether);
    }

    function testEndFunction() public {
        //test if it reverts when it is called and teime isnot up
        auctionHouse.bid(0.5 ether);
        vm.expectRevert();
        auctionHouse.endAuction();
    }

    function testEndFunction2() public {
        //test if it reverts when it is called and teime isnot up
        auctionHouse.bid(0.5 ether);
        skip(3600);

        auctionHouse.endAuction();

        assertEq(auctionHouse.ended(), true);
    }

    function testWithdraw() public {
        //dont call when the auction has not ended
        auctionHouse.bid(0.5 ether);
        vm.expectRevert();
        auctionHouse.withdraw();
    }

    function testWithdrawWinnerCantWithdraw() public {
        //winner cant withdraw
        address sinclair = address(0x1);
        vm.prank(sinclair);
        auctionHouse.bid(1 ether);
        skip(3600);
        auctionHouse.endAuction(); //end the auction
        uint256 amount = auctionHouse.bids(sinclair);
        assertEq(amount, 1 ether);
        vm.expectRevert();
        vm.prank(sinclair);
        auctionHouse.withdraw();

        //test if the others has collected their money
        assertEq(auctionHouse.bids(msg.sender), 0 ether);
    }
}
