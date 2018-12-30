// Allows us to use ES6 in our migrations and tests.
require('babel-register')

var HDWalletProvider = require('truffle-hdwallet-provider');

var mnemonic = 'note bullet gym acoustic plastic correct cradle color monitor stove knee deliver';

module.exports = {
  networks: { 
    ganache: {
      host: '127.0.0.1',
      port: 9545,
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