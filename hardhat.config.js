require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("hardhat-abi-exporter");
require("hardhat-gas-reporter");
const config = require("./.config.json");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 2000
          }
        }
      },
    ]
  }, 
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      blockGasLimit: 12e6
    },
  },
  gasReporter: {
    currency: "USD",
    coinmarketcap: config.coinmarketcapKey,
    showTimeSpent: true,
  },
  mocha: {
    timeout: 120000,
    retries: 0,
    bail: true,
  },
  abiExporter: {
    flat: true
  }
};
