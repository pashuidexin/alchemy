const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
  
main();

//  Contract deployed to: 0x7b14d87372241C3431389D2e0f26a6798F48F5D2
// npx hardhat verify --network mumbai 0x7b14d87372241C3431389D2e0f26a6798F48F5D2
// npx hardhat verify --network mumbai 0x23faA3741596FEd3f2A8a7ad0f14733EF307767A