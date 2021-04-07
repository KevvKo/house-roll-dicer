// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.6.6;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";

contract VRFD20 is VRFConsumerBase {

    uint256 private constant ROLL_IN_PROGRESS = 42;
    bytes32 private keyHash;
    uint256 private fee;
    address internal coordinator = 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9;
    address internal link = 0xa36085F69e2889c224210F603D836748e7dC0088;

    mapping(bytes32 => address) private rollers;
    mapping(address => uint256) private results;

    event DiceRolled(bytes32 indexed requestId, address indexed roller);
    event DiceLanded(bytes32 indexed requestId, uint256 indexed result);

    constructor() public
    VRFConsumerBase(coordinator, link){
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4; 
        fee = 0.1 * 10 ** 18;
    }

function rollDice(uint256 userProvidedSeed, address roller) public returns (bytes32 requestId) {
    require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK to pay fee");
    require(results[roller] == 0, "Already rolled");
    requestId = requestRandomness(keyHash,fee, userProvidedSeed);
    rollers[requestId] = roller;
    results[roller] = ROLL_IN_PROGRESS;
    emit DiceRolled(requestId, roller);
}

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 d20Value = randomness.mod(20).add(1);
        results[rollers[requestId]] = d20Value;
        emit DiceLanded(requestId, d20Value);
    }

    function house(address player) public view returns (string memory){
        require(results[player] != 0, "Dice not rolled");
        require(results[player] != ROLL_IN_PROGRESS, "Roll in progress");
        return getHouseName(results[player]);
    }

    function getHouseName(uint256 id) private pure returns (string memory) {
        string[20] memory houseNames = [
            "Targaryen",
            "Lannister",
            "Stark",
            "Tyrell",
            "Baratheon",
            "Martell",
            "Tully",
            "Bolton",
            "Greyjoy",
            "Arryn",
            "Frey",
            "Mormont",
            "Tarley",
            "Dayne",
            "Umber",
            "Valeryon",
            "Manderly",
            "Clegane",
            "Glover",
            "Karstark"
        ];
        return houseNames[id.sub(1)];
    }
}