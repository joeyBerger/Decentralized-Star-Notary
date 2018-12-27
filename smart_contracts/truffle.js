// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // to customize your Truffle configuration!
//   networks: {
//     development: {
//       host: "localhost",
//       port: 8545,
//       network_id: "*" // Match any network id
//   },
//     rinkeby: {
//       host: "localhost", //local node
//       port: 8545, // connection port
//       network_id: 4, // network id for test networks
//       gas: 4700000 // gas limit
//     }
//   }
// };




var HDWalletProvider = require('truffle-hdwallet-provider');

var mnemonic = 'candy maple cake sugar pudding cream honey rich smooth crumble sweet treat';

module.exports = {
  networks: { 
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: "*"
    }, 
    rinkeby: {
      provider: function() { 
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/e83751249eeb4643b8b5bac5c578421c') 
      },
      network_id: 4,
      gas: 4500000,
      gasPrice: 10000000000,
    }
  }
};