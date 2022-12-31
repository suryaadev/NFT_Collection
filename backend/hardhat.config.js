require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config({ path: ".env" })

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY

module.exports = {
  solidity: "0.8.17",
  networks:{
    goerli:{
      url: GOERLI_RPC_URL,
      chainId : 5,
      accounts : [PRIVATE_KEY]
    }
  }
};
