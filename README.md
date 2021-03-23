# Creol Carbon Eth

<p align="center">
    <img src="https://github.com/JUDOKICK/creol-react-dapp-oz/blob/master/src/assets/images/Logo-FullSizeGif.gif">
</p>

[www.offset.creol.io](http://www.offset.creol.io)

Creol Carbon Eth is the master repo for smart contracts pertaining to the Creol Carbon ecosystem. This includes two suites of contracts

CarbonVCU - Representation of VERRA standard Verified Carbon Unit, in ERC721 form. It is also a parent contract to subcontracts known as VCUSubtoken

VCUSubtoken - Representation of each gram of CO2e in a single CarbonVCU tonne. Used using a standard ERC20, these are periodically burned to irreversibly remove carbon from the system. 

While quite simple as a concept, it remains that Creol administers this system for the time being as there currently is no decentralized 
Carbon regulation authority to issue CO2e tonnes on chain via Oracles/Authentication of any kind. 

The contract suite also includes interfaces as well as VCUSubtokenFactory for usage.
## Installation

1. Clone repo and Install npm dependencies
    ```javascript
   git clone https://github.com/creol-io/creol-carbon-eth.git
    yarn install
    ```
2. Build and compile the smart contracts
    ```javascript
    oz compile
    ```
3. (Optional) Publish contracts to localchain
    ```javascript
    oz publish
    ```

## Usage

Each set of contracts requires a few paremeters for setup as they are Initializable contracts from OZ

#### CarbonVCU

   This contract once deployed requires a few initial parameters in the Initialize function. It is important to note that it inherits the 
   initialize function from other contracts and the correct one should be use. 
   
   The correct signature is this one
   
   ```initializeConstruct(string memory name, string memory symbol, address _creolSuper, address _VCUSubTokenFactory)```
   
   Takes in 4 parameters:
   The ERC-721 Token Name and Symbol.
   
   The CreolSuper Address, who is to be the admin of the contract for deployment purposes (set this to an address you have control over)
   
   The _VCUSubTokenFactory address which is the address of the deployed VCUSubTokenFactory to be used
   
   Post deployment, it is important to set the CarbonVCU address in tokenFactory to ensure that only this CarbonVCU can deploy new
   subtokens. Using this function in the ```VCUSubTokenFactory.sol``` contract:
   
   ```function setCarbonVCUAddress(address _newCarbonVCUAddress) public onlyOwner ```
   
#### VCUSubTokenFactory
Prior to deploying the CarbonVCU contract, it is required to deploy the VCUSubTokenFactory to be able to issue VCUSubtokens

This comes with the Caveat of having to also having an upgradeable version deployed of the base VCUSubtoken

So ensure that you have deployed that as well. The initialization function for the factory is the following:

```function initialize (address _owner) public initializer```

But also requires you to get the App package address from OZ Publish

and set it using:

``` function setAppPackage (App _appPackage) public onlyOwner```

Once completed, the factory will be able to use to deploy the CarbonVCU Project. 

#### VCUSubToken

This is the base ERC20 upgradeable proxy version contract, this is to be deployed using OZ publish and shouldnt really be ever deployed manually.




