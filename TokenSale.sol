pragma solidity ^0.4.8;

import "./SafeMath.sol"
import "./SampleToken.sol"

contract ProRataAllocation {

	// CONSTANTS

	uint public constant ETHER_CAP = 125000 * 10**18; //Max amount raised during second contribution; 125,000 eth. 
	uint public constant MAX_CONTRIBUTION_BLOCKS = 150000; //Number of blocks crowdsale should run for; arbitrary value now. Approx 30 days.
	uint public constant PRICE_PER_MELON = 1 * 10**18; //1 MLN = 1 ETH; arbitrary value
	uint public constant MELON_CAP = ETHER_CAP / PRICE_PER_MELON;


	// FIELDS ONLY CHANGED BY CONSTRUCTOR

	uint public startBlock; //contribution start block
	uint public endBlock; //last block one in which one can contribute to coin offering
	address public melonport;
	SampleToken public sampleToken;


	// FIELDS MODIFIABLE BY FUNCTIONS

	uint public etherCommited = 0; //total amount of Ether raised during the coin offering
	mapping (address => uint) public bidsSubmitted; //maping of bidders address => amount of bid


	// EVENTS 

	event BidCommited(uint bidAmount, address indexed investorAddress);

	// MODIFIERS

	modifier auctionInProgress {
		assert(block.number <= endBlock && block.number >= startBlock);
		_;
	}

	modifier auctionOver {
		assert(block.number >= endBlock);
		_;
	}

	// FUNCTIONS 

	function commitEth() 
		payable
		auctionInProgress
	{
		bidsSubmitted[msg.sender] += msg.value;
		etherCommited += msg.value;
		BidCommited(msg.value, msg.sender);
	}

	function claimTokens() 
		auctionOver
	{
		uint tokensClaimed = 0;
		if (etherCommited <= ETHER_CAP) {
			tokensClaimed = bidsSubmitted[msg.sender] / PRICE_PER_MELON;
		} else {
			tokensClaimed = calcualteProRataAlloc(bidsSubmitted[msg.sender]) / PRICE_PER_MELON;	
		}
		bidsSubmitted[msg.sender] = 0;
		SampleToken.transfer(msg.sender, tokensClaimed);
	}


	function calcualteProRataAlloc(uint bidAmount) 
		returns (uint amtAllocatedToBidder)
	{
		return (bidAmount / etherCommited) * MELON_CAP;
	}

	// CONSTRUCTOR

	function ProRataAllocation() {
		melonport = msg.sender;
		startBlock = block.number;
		endBlock = block.number + MAX_CONTRIBUTION_BLOCKS;

	}
}