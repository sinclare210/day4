// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AuctionHouse} from "../src/AuctionHouse.sol";
import {Script} from "forge-std/Script.sol";

contract AuctionHouseScript is Script {
    AuctionHouse public auctionHouse;

    function run() public{
        vm.startBroadcast();
        auctionHouse = new AuctionHouse("Vintage Clock", 3600);
        vm.stopBroadcast();
    }

}