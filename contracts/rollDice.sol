// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.6.6;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";

contract VRFD20 is VRFConsumerBase {
    bytes32 private keyHash;
    uint256 private fee;
    address internal coordinator = 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9;
    address internal link = 0xa36085f69e2889c224210f603d836748e7dc0088;

    mapping(bytes32 => address) private rollers;
    mapping(address => uint256) private results;

    constructor() public
    VRFConsumerBase(coordinator, link){
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4; 
        fee = 0.1 * 10 ** 18;
    }
}