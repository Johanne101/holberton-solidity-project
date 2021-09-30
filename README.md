# holberton-solidity-project

### Assignment

Build a simple NFT exchange. See full writeup in `/assignment` folder.

### Setup:

1. Fork the repository

2. Install

```
npm i
```

3. Add `.config.json` and sign up for alchemy key https://alchemyapi.io/

```
{
    "alchemyKey": ""
}
```

4. Run tests

```
npm run test
```

---

### Resources

This repo is forked from [this repo](https://github.com/davidberiro/bancor-liquidity-mining).  Feel free to use it as a reference on how to do things.

I would suggest before you and your team start, you should get comfortable with the [ERC721](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol) and or [ERC1155](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol) smart contracts by first setting them up in [Remix](http://remix.ethereum.org/), creating an NFT, transferring it, etc.

General Resources:

- Solidity is the language in which smart contracts are written https://docs.soliditylang.org/
- Hardhat is a development environment for creating, debugging, and unit testing smart contracts, it also runs the local ethereum blockchain https://hardhat.org/getting-started/
- Ethereum Stack Exchange https://ethereum.stackexchange.com/
- Remix allows you to write, test, and debug smart contracts in the browser, no installs! http://remix.ethereum.org/
- OpenZeppelin is the organization responsible for maintaining Ethereum's smart contract standards their docs may be able to assist with best practices as well as understanding ERC721 and ERC1155 https://docs.openzeppelin.com/contracts/4.x/
- OpenSea is the largest NFT exchange by volume, their docs and examples may help https://docs.opensea.io/ 

The following are two channels I would recommend for tutorials on Solidity Smart Contract Development:

- [EatTheBlocks YouTube Channel](https://www.youtube.com/c/EatTheBlocks) | Github Repo with many examples: [https://github.com/jklepatch/eattheblocks](https://github.com/jklepatch/eattheblocks)
- [Solidity, Blockchain, and Smart Contract Course – Beginner to Expert Python Tutorial - freeCodeCamp.org](https://www.youtube.com/watch?v=M576WGiDBdQ)