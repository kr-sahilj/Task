require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: "https://goerli.infura.io/v3/abe3751076cc41e4b667f40d4430dd4c",
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  }
};
