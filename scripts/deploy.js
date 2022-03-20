/* eslint-disable node/no-unsupported-features/es-syntax */
// eslint-disable-next-line no-unused-vars
import hre, { ethers, network, run } from "hardhat";
import axios from "axios";
import "@nomiclabs/hardhat-ethers";
import { formatUnits, parseUnits } from "ethers/lib/utils";
const [file] = process.argv.slice(2);

const maxGasPrice = "100";

const getContractInfo = async (file) => await import(`../NFTs/${file}.js`);

async function waitForGasPriceBelow(max) {
  console.log("Waiting for gas price below", formatUnits(max, "gwei"), "gwei");
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const price = await ethers.provider.getGasPrice();
    console.log(
      new Date().toLocaleString(),
      "Gas Price:",
      formatUnits(price, "gwei"),
      "gwei"
    );
    if (price.lte(max)) {
      console.log("Good enough!");
      return price;
    }
    await new Promise((resolve) => setTimeout(resolve, 30_000));
  }
}

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
  const { contractName, contractArgs } = await getContractInfo(file);

  console.log("contract name:", contractName);
  console.log("contract args:", contractArgs);

  await run("compile");

  await waitForGasPriceBelow(parseUnits(maxGasPrice, "gwei"));
  const ERC721Factory = await ethers.getContractFactory(contractName);
  const contractInstance = await ERC721Factory.deploy(...contractArgs); // Instance of the contract

  console.log(
    `deploying contract: ${contractInstance.address} to the ${network.name} network...`
  );
  // console.log(`using gas price of ${Number(network)/(10**9)} gwei`);
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
