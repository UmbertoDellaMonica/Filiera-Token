const PrivateKeyProvider = require("@truffle/hdwallet-provider");
const privateKey = "ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f";
const privateKeyProvider = new PrivateKeyProvider(
  privateKey,
  "http://localhost:8545",
);

module.exports = {
  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },


    besuWallet: {
      provider: privateKeyProvider,
      network_id: "*",
      gasPrice: 0,
      gas: 4500000,
    },

    
  },
  mocha: {
    timeout: 100000
  },
  compilers: {
    solc: {
      version: "^0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
      evmVersion: "constantinople"
    }
  }
}