// scripts/deploy.js
//BuyMeACoffee deployed to: 0x8f85c8756e9EAFD1A7CFd1e34Bcf6252a84F991b
//BuyMeACoffee deployed to: 0x7b14d87372241C3431389D2e0f26a6798F48F5D2

const hre = require("hardhat");

async function main() {
// We get the contract to deploy.
const BuyMeACoffee = await hre.ethers.getContractFactory("BuyMeACoffee");
const buyMeACoffee = await BuyMeACoffee.deploy();

await buyMeACoffee.deployed();

console.log("BuyMeACoffee deployed to:", buyMeACoffee.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
.then(() => process.exit(0))
.catch((error) => {
console.error(error);
process.exit(1);
});

