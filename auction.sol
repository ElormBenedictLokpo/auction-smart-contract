//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction{
    address owner;
    uint startTime;
    uint endTime;
    uint initialPrice = 0.061 ether;

    enum AuctionStates {Started, Running, Ended, Cancelled}

  
    mapping(address => uint) public bidders;


    constructor(){
        owner = msg.sender;
    }

    modifier isOwner(){
        require(owner == msg.sender, "Only owner is can access functionality");
        _;
    }

    modifier notOwner(){
          require(owner != msg.sender, "Owner cannot access this functionality");
        _;
    }

    function bid() public payable notOwner{
        require(msg.value >= initialPrice, "Cannot bid an amount less than initial price");

        bidders[msg.sender] += msg.value / 1 ether;
       
    }

   
  
}