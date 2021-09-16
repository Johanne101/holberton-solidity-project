# Assignment

Build a simple NFT exchange.  A user should be able to transfer their NFT to the exchange, list it for a price in ETH, sell to another user, user B withdraws or resells.  The exchange should also allow a user to update their NFT's price and delist the NFT from sale.

General Requirements:

- must use [ERC721](https://eips.ethereum.org/EIPS/eip-721) and/or [ERC1155](https://eips.ethereum.org/EIPS/eip-1155) standards
- exchange must support pricing NFTs in ETH
- must use hardhat

Minimum required unit test coverage:

- deposit NFT
- deposit and list NFT
- deposit, list, sell, withdraw NFT
- update NFT price
- delist NFT

Bonus points:

- allow smart contract to interact with exchange to deposit, buy, sell, withdraw
- allow 3rd party tokens (allow someone to bid in another token than ETH such as USDC, DAI, LINK, etc)
- allow user to deposit/withdraw multiple NFTs
- allow your contract to be [upgraded](https://docs.openzeppelin.com/contracts/4.x/upgradeable)

Security considerations:

- only the NFT owner should be able to list, update price, delist, and withdraw an NFT
- only the marketplace owner should be able to perform any owner related functions

### Questions

If you have questions, post them in Q&A section of the discussion tab.
