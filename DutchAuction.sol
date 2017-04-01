pragma solidity ^0.4.8;

contract DutchAuction {
	
	// CONSTANTS

	uint public constant ETHER_CAP = 125000 * 10**18; //Max amount raised during second contribution; 125,000 eth. 
	uint public constant MAX_CONTRIBUTION_BLOCKS = 150000; //Number of blocks crowdsale should run for; arbitrary value now. Approx 30 days.

	// Fields only changed by the constructor

	uint public startBlock; //contribution start block
	uint public endBlock; //last block one in which one can contribute to coin offering
	address public melonport;

	// Fields modifiable by functions

	uint public etherRaised = 0; //total amount of Ether raised during the coin offering
	uint public finalPrice; //the price everyone ends up paying per MLN
	bool crowdsaleRunning = true; //false once the crowdsale is completed
	mapping (address => uint) public bidsSubmitted; //maping of bidders address => amount of bi

	// EVENTS

	event BidCommited(uint bidAmount, address indexed investorAddress);

	// MODIFIERS

	modifier capNotReached {
		assert(msg.value + etherRaised <= ETHER_CAP);
		_;
	}

	modifier auctionInProgress {
		assert(block.number <= endBlock);
		_;
	}

	modifier auctionOver {
		assert(crowdsaleRunning == false);
		_;
	}

	modifier finalpriceSet {
		assert(finalPrice != 0);
		_;
	}

	// FUNCTIONS

	function submitBid()
		payable
		capNotReached
		auctionInProgress
	{
		bidsSubmitted[msg.sender] += msg.value;
		etherRaised += msg.value;
		if (etherRaised == ETHER_CAP) {
			crowdsaleRunning = false;
			setFinalPrice();
		}
		BidCommited(msg.value, msg.sender);
	}

	//based on a start price of 1 MLN = 2 ETH and a constant increase until 1 MLN = .5 ETH
	//this function can easily be changed to allow a more complex pricing schedule
	function calculateCurrentTokenPrice()
		returns (uint currentTokenprice)
	{
		if (block.number > endBlock) { return .5 ether; }
		return 2 ether - 1/((100000)*(block.number - startBlock));
	}

	//sets the variable finalPrice
	function setFinalPrice() 
		private 
		auctionOver
	{
		finalPrice = calculateCurrentTokenPrice();
	}

	//allows an ICO bidder to claim their tokens
	function claimTokens() 
		finalpriceSet
	{
		uint tokensClaimed = bidsSubmitted[msg.sender] / finalPrice;
		bidsSubmitted[msg.sender] = 0;
		//transfer token logic to bidder here
	}

	//CONSTRUCTOR

	function DutchAuction() {
		melonport = msg.sender;
		startBlock = block.number;
		endBlock = block.number + MAX_CONTRIBUTION_BLOCKS;
	}
}