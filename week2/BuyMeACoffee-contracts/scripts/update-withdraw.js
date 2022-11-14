// scripts/withdraw.js

const hre = require("hardhat");
const abi = require("../artifacts/contracts/Buymeacoffee.sol/BuyMeACoffee.json");
require("dotenv").config();

async function getBalance(provider, address) {
  const balanceBigInt = await provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

async function main() {
  // Get the contract that has been deployed to Goerli.
  const contractAddress = "0xDBa03676a2fBb6711CB652beF5B7416A53c1421D";
  //const account = await hre.ethers.getSigner();
  //const newAddress = await account.getAddress();

  const contractABI = abi.abi;

  // Get the node connection and wallet connection.
  const provider = new hre.ethers.providers.AlchemyProvider("goerli", process.env.GOERLI_API_KEY);

  // Ensure that signer is the SAME address as the original contract deployer,
  // or else this script will fail with an error.
  const signer = new hre.ethers.Wallet(process.env.GOERLI_PRIVATE_KEY, provider);
  // Instantiate connected contract.
  const buyMeACoffee = new hre.ethers.Contract(contractAddress, contractABI, signer);

  const newAddress = "0xa94ad2de38c88D3c507a9F5D4946B004197dBDC8";
  console.log ("set new withdraw address to: ", newAddress);
  const updateAddress = await buyMeACoffee.setNewAddress(newAddress); 
  await updateAddress.wait();
  console.log("Withdrawal address updated...")

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });