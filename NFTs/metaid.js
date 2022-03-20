const contractName = "metaid"; // links to the file name in contracts/<filename.sol>

const env = process.env.HARDHAT_NETWORK === "mainnet" ? "www" : "dev";

const nftName = "Meta ID";
const symbol = "METAID";
const metadataFolderURL = `https://${env}.metaid.quest/api/v1/metadata/`;
const mintsPerAddress = 1;
const openseaContractMetadataURI = `https://${env}.metaid.quest/api/v1/contract-metadata`;
const mintActive = false;

// For a project to be added to this list, it must include the ownerOf function in its contract
// This is standard for ERC721 contracts
const validProjectsMint = [
  "0xE600AFed52558f0c1F8Feeeb128c9b932B7ae4e3", // Character
  "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D", // BAYC
  "0x60E4d786628Fea6478F785A6d7e704777c86a7c6", // MAYC
  "0x7Bd29408f11D2bFC23c34f18275bBf23bB716Bc7", // Meebits
  "0x1A92f7381B9F03921564a437210bB9396471050C", // CoolCats
  "0x7E6Bc952d4b4bD814853301bEe48E99891424de0", // Jungle Freaks
  "0x439cac149B935AE1D726569800972E1669d17094", // The Idols
  "0x508d06B8f3A4B0Fd363239Ce61e0C4b0B82f3626", // Loot Explorers
  "0x5180db8F5c931aaE63c74266b211F580155ecac8", // Crypto Coven
  "0x8a90CAb2b38dba80c64b7734e58Ee1dB38B8992e", // Doodles
  "0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03", // Nouns
];

const contractArgs = [
  nftName,
  symbol,
  metadataFolderURL,
  mintsPerAddress,
  openseaContractMetadataURI,
  mintActive,
  validProjectsMint,
];

// eslint-disable-next-line node/no-unsupported-features/es-syntax
export { contractName, contractArgs };
