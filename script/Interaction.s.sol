// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinatorV2 = helperConfig.getConfig().vrfCoordinatorV2; // returns network config for active network
        (uint256 subId,) = createSubscription(vrfCoordinatorV2);
        return (subId, vrfCoordinatorV2);
    }

    function createSubscription(address vrfCoordinatorV2) public returns (uint256, address) {
        console.log(" creating subscription on chain id: ", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinatorV2).createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription Id is : ", subId);
        console.log("please update subscription id in your HelperConfig.s.sol");
        return (subId, vrfCoordinatorV2);
    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}
