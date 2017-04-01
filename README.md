# MelonChallenge
Sample Dutch Auction ICO

## Design Rationale

Based on Melonport's first ICO selling out in nearly 10 minutes, and many - myself included - missing out due to this I decided to implement a modified Dutch Auction. In this auction the price starts at 1 MLN = 2 ETH and declines constantly over 150,000 blocks until 1 MLN = .5 ETH. This setup allows the investors to buy in at a valuation that they believe is fair; thus allowing those with great faith in the protocol to have a higher probability of participating in the ICO. Furthermore, all participants end up paying the same price, so there's no disadvantage in participating earlier. I'm considering changing this to a max 10% difference, in order to realign incentives and potentially prevent too high of a valuation. 

##Todo 
1. Finish implementing SampleToken and use SafeMath.sol
2. Testing



