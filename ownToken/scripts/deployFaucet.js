const hre = require("hardhat");
const ethers = require("ethers");

async function main() {
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0x0fE7297c391362f6103e0a36566AF215FB87A168");
  await faucet.deployed();
  console.log("Faucet contract deployed to:", faucet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});