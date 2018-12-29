// Allows us to use ES6 in our migrations and tests.
require('babel-register')

// Edit truffle.config file should have settings to deploy the contract to the Rinkeby Public Network.
// Infura should be used in the truffle.config file for deployment to Rinkeby.

module.exports = {
  networks: {
    ganache: {
      host: '127.0.0.1',
      //port: 7545,
      port: 9545,
      network_id: '*' // Match any network id
    }
  }
}



// var HDWalletProvider = require('truffle-hdwallet-provider');

// var mnemonic = 'candy maple cake sugar pudding cream honey rich smooth crumble sweet treat';

// module.exports = {
//   networks: { 
//     development: {
//       host: '127.0.0.1',
//       port: 8545,
//       network_id: "*"
//     }, 
//     rinkeby: {
//       provider: function() { 
//         return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/e83751249eeb4643b8b5bac5c578421c') 
//       },
//       network_id: 4,
//       gas: 4500000,
//       gasPrice: 10000000000,
//     }
//   }
// };