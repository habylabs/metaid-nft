const contractName = "metaid"; // links to the file name in contracts/<filename.sol>

const env = process.env.HARDHAT_NETWORK === "mainnet" ? "www" : "dev";

const nftName = "Meta ID";
const symbol = "METAID";
const metadataFolderURL = `https://${env}.metaid.quest/api/v1/metadata/`;
const mintsPerAddress = 1;
const openseaContractMetadataURI = `https://${env}.metaid.quest/api/v1/contract-metadata`;
const mintActive = false;

const contractArgs = [
  nftName,
  symbol,
  metadataFolderURL,
  mintsPerAddress,
  openseaContractMetadataURI,
  mintActive,
];

// eslint-disable-next-line node/no-unsupported-features/es-syntax
export { contractName, contractArgs };
