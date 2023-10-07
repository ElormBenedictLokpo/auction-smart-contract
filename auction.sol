//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction{
    address owner;
    uint startTime;
    uint endTime;
    uint initialPrice = 0.061 ether;

    enum AuctionStates {Started, Ended, Cancelled}
    AuctionStates currentState;
  
    //mapping(address => uint) public bidders;

    struct Bidder{
        address ethaddress;
        uint256 amount;
    }

    Bidder[] bidders;


    constructor(){
        owner = msg.sender;
        startTime = block.number;
        endTime = 40320;
        currentState = AuctionStates.Started;
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
        require(currentState == AuctionStates.Started, "Auction not started");
        require(currentState != AuctionStates.Cancelled, "Auction cancelled");
        require(startTime <= endTime, "Auction ended");

        for (uint i = 0; i< bidders.length; i++){
            if(bidders[i].ethaddress == msg.sender){
                bidders[i].amount += msg.value/1;
            }else{
                Bidder memory newBidder = Bidder({
                    ethaddress: msg.sender,
                    amount: msg.value/1
                });
                bidders.push(newBidder);
            }
        }

       
    }

    function getBidderBidAmount(address _bidder) public view returns(Bidder memory) {
            for (uint i = 0; i< bidders.length; i++){
                if(bidders[i].ethaddress == _bidder){
                    return bidders[i];
                }
            }

            return Bidder(address(0), 0);
    }

   function endAuction() public {
        
   }
  
}