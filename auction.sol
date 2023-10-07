//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction{
    address owner;
    uint startTime;
    uint endTime;
    uint initialPrice = 0.061 ether;

    enum AuctionStates {Started, Running, Ended, Cancelled}

    struct Bidder{
        address ethaddress;
        uint256 amount;
    }

    mapping(address => Bidder[]) public bidders;


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
        Bidder memory newBidder = Bidder({
            ethaddress: msg.sender,
            amount: msg.value
        });

        bidders[address(this)].push(newBidder);
    }

    function getAllBidders() public view returns(Bidder[] memory){
        return bidders[address(this)];
    }

    function getBidderBidValue(address _bidder) public view returns(Bidder memory){
        for(uint i =0; i < bidders[address(this)].length; i++){
            if (bidders[address(this)][i].ethaddress == _bidder){
                return bidders[address(this)][i];
            }
        }

        return Bidder(address(0), 0);
    }
}