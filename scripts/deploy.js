/* eslint-disable node/no-unsupported-features/es-syntax */
// eslint-disable-next-line no-unused-vars
const hre = require("hardhat");
const axios = require("axios");
require("@nomiclabs/hardhat-ethers");

const { ethers, network, run } = hre;

const getContractInfo = async () => await import(`../NFTs/metaId.js`);

const sleep = (ms) => {
  console.log(`sleeping ${ms / 1000} seconds`);
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const waitForEtherscan = async (address, network) => {
  console.log("waiting for the contract to be available on etherscan...");
  const { ETHERSCAN_API_KEY } = process.env;
  let deployed = false;

  while (!deployed) {
    const networkString = network === "mainnet" ? "" : `-${network}`;
    const apiToHit = `https://api${networkString}.etherscan.io/api?module=account&action=txlist&address=${address}&startblock=0&endblock=99999999&sort=asc&apikey=${ETHERSCAN_API_KEY}`;
    const res = await axios.get(apiToHit);
    if (res.data.status === 1) {
      console.log("contract code finally verified");
      deployed = true;
    } else {
      console.log("status:", res.data.status);
      await sleep(5000);
    }
  }
};

async function main() {
  const { contractName, contractArgs } = await getContractInfo();

  console.log("contract name:", contractName);
  console.log("contract args:", contractArgs);

  await run("compile");

  const ERC721Factory = await ethers.getContractFactory(contractName);
  const contractInstance = await ERC721Factory.deploy(...contractArgs); // Instance of the contract

  console.log(
    `deploying contract: ${contractInstance.address} to the ${network.name} network...`
  );
  await contractInstance.deployed();
  console.log("contract deployed");

  await waitForEtherscan(contractInstance.address, network.name);

  console.log("verifying the contract on etherscan...");
  await run("verify:verify", {
    address: contractInstance.address,
    constructorArguments: contractArgs,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
