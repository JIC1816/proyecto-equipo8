const { ethers, run, network } = require("hardhat");

async function main() {
  const CollectionFactory = await ethers.getContractFactory(
    "equipoOcho_Collection"
  );
  console.log("Deploying contract...");
  const collection = await CollectionFactory.deploy();
  await collection.deployed();
  console.log(`Deployed contract to: ${collection.address}`);
  await collection.deployTransaction.wait(6);
  await verify(collection.address, []);

  const MarketFactory = await ethers.getContractFactory("equipoOcho_Market");
  console.log("Deploying contract...");
  const market = await MarketFactory.deploy();
  await market.deployed();
  console.log(`Deployed contract to: ${market.address}`);
  await market.deployTransaction.wait(12);
  await verify(market.address, []);
}

async function verify(contractAddress, args) {
  console.log("Verifying contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified!");
    } else {
      console.log(e);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
