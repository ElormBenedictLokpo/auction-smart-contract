//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction{
    address owner;
    uint startTime;
    uint endTime;
    uint initialPrice = 0.061 ether;
    uint currentHighestBid;

    enum AuctionStates {Started, Ended, Cancelled}
    AuctionStates currentState;
  
    //mapping(address => uint) public bidders;

    struct Bidder{
        address ethaddress;
        uint256 amount;
    }

    Bidder[] bidders;
    Bidder auctionWinner;

    constructor(){
        owner = msg.sender;
        startTime = block.number;
        endTime = 40320;
        currentState = AuctionStates.Started;
        currentHighestBid = initialPrice;
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
        require(currentState != AuctionStates.Ended, "Auction cancelled");
        require(currentHighestBid < msg.value, "You cannot bid an amount same or lower");

        require(startTime <= endTime, "Auction ended");
        
        if (currentHighestBid < msg.value){
            currentHighestBid = msg.value;
        }

        for (uint i = 0; i< bidders.length; i++){
            if(bidders[i].ethaddress == msg.sender){
                bidders[i].amount += msg.value/1;

                return;
            }
        }


            Bidder memory newBidder = Bidder({
                    ethaddress: msg.sender,
                    amount: msg.value/1
                });
                bidders.push(newBidder);
       
    }
    function getAllBidders() public view returns(Bidder[] memory){
        return bidders;
    }

    function determineHighestBidder() public view returns (uint){
        uint max_amount = bidders[0].amount;
        for (uint i=0; i < bidders.length; i++){
            if (bidders[i].amount > max_amount){
                max_amount = bidders[i].amount;
            }            
        }

        return max_amount;
    }

    function payOutLowBidders() public{
        require(currentState == AuctionStates.Ended, "End auction first");

        uint highestBid = determineHighestBidder();

        for (uint i = 0; i < bidders.length;i++){
            if (bidders[i].amount != highestBid){
                payable(bidders[i].ethaddress).transfer(bidders[i].amount);
            }
        }
    }

    function endAuction() public returns (Bidder memory) {
        currentState = AuctionStates.Ended;
        uint higestBid = determineHighestBidder();
        

        for (uint i = 0; i < bidders.length; i++){
            if (bidders[i].amount == higestBid){
                auctionWinner = bidders[i];
                return bidders[i];
            }
        }

        payOutLowBidders();
        return Bidder(address(0), 0);
    }


    function getBidderBidAmount(address _bidder) public view returns(Bidder memory) {
            for (uint i = 0; i< bidders.length; i++){
                if(bidders[i].ethaddress == _bidder){
                    return bidders[i];
                }
            }

            return Bidder(address(0), 0);
    }

   
    function cancelAuction() public {
        currentState = AuctionStates.Cancelled;
   }
  
} 