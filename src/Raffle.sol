// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private

// view & pure functions



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {VRFConsumerBaseV2} from "chainlink/src/v0.8/vrf/VRFConsumerBaseV2.sol";
//NATSPEC
    /**
 * @title  A Sample Raffle Contract
 * @author Maria
 * @notice This contract is designed to simulate a simple raffle system.
 * @dev It impliments chainlink VRFv2.5 and chainlink automation

 */


contract Raffle is VRFConsumerBaseV2 {
//Errors
 error Raffle__NotEnoughEthSent();


uint256 private immutable i_entranceFee;
/// @dev Duration of lottery in seconds 
uint256 private immutable i_interval;
// Chainlink VRF related variables
address immutable i_vrfCoordinator;

//made payable to allow for paying ETH prize to one of registered participants
address payable[] private s_players;
uint256 private s_lastTimestamp;

//event
event EnteredRaffle(address indexed player);

constructor (uint256 entranceFee, uint256 interval, address vrfCoordinator){
    i_entranceFee = entranceFee;
    i_interval = interval;
    s_lastTimestamp = block.timestamp;

    i_vrfCoordinator = vrfCoordinator;
} 

//users enter raffle by paying a ticker price, define price
function enterRaffle() external payable {
/*     require(msg.value >= i_entranceFee, "Not enough Ether!");  
    strings to give info on failures are expensive when deploying, not gas efficient
    custom errors can also be used in require statements */
    if (msg.value < i_entranceFee){ revert Raffle__NotEnoughEthSent();}
    s_players.push(payable(msg.sender));
    emit EnteredRaffle(msg.sender);

}

//pick winner out of the registered users
function pickWinner() external {
    //check if enough time has passed
    if(block.timestamp - s_lastTimestamp < i_interval) revert();

    // get our random number
     requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
}


function getEntranceFee() external view returns (uint256) {
return i_entranceFee;
}

}