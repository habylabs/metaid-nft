const metaidApiUrl =
  process.env.HARDHAT_NETWORK === "mainnet"
    ? "https://metaid.quest/api/v1/metaid/token/"
    : "https://b104-136-58-120-30.ngrok.io/api/v1/metaid/token/";

const nftName = "Meta ID";
const symbol = "METAID";
const metadataFolderURL = metaidApiUrl;
const mintsPerAddress = 1;
const openseaContractMetadataURI = metaidApiUrl;
const mintActive = true;

// For a project to be added to this list, it must include the ownerOf function in its contract
// This is standard for ERC721 contracts
const freeMintProjects = [
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
  "0x0290d49f53A8d186973B82faaFdaFe696B29AcBb", // HyperLoot
  "0xED5AF388653567Af2F388E6224dC7C4b3241C544", // Azuki
  "0x23581767a106ae21c074b2276D25e5C3e136a68b", // Moonbirds
  "0xe785E82358879F061BC3dcAC6f0444462D4b5330", // WOW
  "0x7Eaa96D48380802A75ED6d74b91E2B30c3d474C1", // CPG POP
  "0xd93206BD0062cC054E397eCCCdB8436c3fa5700e", // Decagon
  "0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7", // Loot
  "0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF", // mLoot
];

const contractArgs = [
  nftName,
  symbol,
  metadataFolderURL,
  mintsPerAddress,
  openseaContractMetadataURI,
  mintActive,
  freeMintProjects,
];

// eslint-disable-next-line node/no-unsupported-features/es-syntax
module.exports = contractArgs;
