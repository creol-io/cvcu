/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
require('dotenv').config()

const HDWalletProvider = require("truffle-hdwallet-provider");
//const LedgerProvider = require("truffle-ledger-provider");
const LedgerOptions = {
  networkId: "4",
  path: "44'/60'/0'/0",
  askConfirm: true,
  accountsLength: 10,
  accountsOffset: 0// ledger default derivation path
}
const babelRegister = require('babel-register');
const babelPolyfill = require('babel-polyfill');

// Infura API key
const infura_apikey_dev = 'API_KEY_DEV';
const infura_apikey_prod = 'API_KEY_PROD';

// 12 mnemonic words that represents the account that will own the contract
const mnemonic_dev = "MNEMONIC_DEV";
const mnemonic_prod = "MNEMONIC_PROD";

module.exports = {
  compilers:{
		solc:{
			version: "0.5.16",
			settings:{
				optimizer:{
					enabled: true,
					runs: 1000,
				},
			},
		},
  },
  networks: {
    local: {
      host: 'localhost',
      port: 7545,
      gas: 5000000,
      gasPrice: 5e9,
      network_id: '5777'
    },
    ropsten: {
        provider: function() {
            return new HDWalletProvider(mnemonic_dev, "https://ropsten.infura.io/v3/" + infura_apikey_dev);
        },
        network_id: "3",
        gas: 4612388,
        gasPrice: 10,
    },
    rinkeby: {
        provider: function() {
            return new HDWalletProvider(mnemonic_dev, "https://rinkeby.infura.io/v3/" + infura_apikey_dev);
        },
        network_id: "4",
        gas: 4612388
    },
    mainnet: {
        provider: function() {
            return new HDWalletProvider(mnemonic_prod, "https://mainnet.infura.io/v3/" + infura_apikey_prod);
        },
        network_id: "1",
        gas: 4612388,
        gasPrice: 7000000000
    }
  }
};
