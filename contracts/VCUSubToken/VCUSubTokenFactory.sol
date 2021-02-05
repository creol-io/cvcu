/*
  @title VCUSubTokenFactory v0.1.4
 ________  ________  _______   ________  ___          
|\   ____\|\   __  \|\  ___ \ |\   __  \|\  \         
\ \  \___|\ \  \|\  \ \   __/|\ \  \|\  \ \  \        
 \ \  \    \ \   _  _\ \  \_|/_\ \  \\\  \ \  \       
  \ \  \____\ \  \\  \\ \  \_|\ \ \  \\\  \ \  \____  
   \ \_______\ \__\\ _\\ \_______\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|_______|\|_______|
                                             
 
 


 __      _______ _    _  _____       _  _______    _              ______         _                   
 \ \    / / ____| |  | |/ ____|     | ||__   __|  | |            |  ____|       | |                  
  \ \  / / |    | |  | | (___  _   _| |__ | | ___ | | _____ _ __ | |__ __ _  ___| |_ ___  _ __ _   _ 
   \ \/ /| |    | |  | |\___ \| | | | '_ \| |/ _ \| |/ / _ \ '_ \|  __/ _` |/ __| __/ _ \| '__| | | |
    \  / | |____| |__| |____) | |_| | |_) | | (_) |   <  __/ | | | | | (_| | (__| || (_) | |  | |_| |
     \/   \_____|\____/|_____/ \__,_|_.__/|_|\___/|_|\_\___|_| |_|_|  \__,_|\___|\__\___/|_|   \__, |
                                                                                                __/ |
                                                                                               |___/ 


                        
Author:      Joshua Bijak
Date:        February 20, 2020
Title:       VCUSubtoken Contract Factory
Description: Contract that deploys VCUSubtoken contracts for gas optimizations
              
  ___                            _       
|_ _|_ __ ___  _ __   ___  _ __| |_ ___ 
 | || '_ ` _ \| '_ \ / _ \| '__| __/ __|
 | || | | | | | |_) | (_) | |  | |_\__ \
|___|_| |_| |_| .__/ \___/|_|   \__|___/
              |_|                       

*/

pragma solidity ^0.5.0; 

import "./VCUSubTokenFactoryInterface.sol";
import "./VCUSubToken.sol";


import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/upgrades/contracts/application/App.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
/**
 * @author Joshua Bijak
 * @dev Contract to deploy VCUSubtoken contracts for tracking.
 * @notice LEDFactory: Creates VCUSubtoken contracts using VCUSubToken Contract
 *
 */
contract VCUSubTokenFactory is VCUSubTokenFactoryInterface,Initializable, Ownable {
   
   /**
     * 
           _____ _       _           _     
          / ____| |     | |         | |    
         | |  __| | ___ | |__   __ _| |___ 
         | | |_ | |/ _ \| '_ \ / _` | / __|
         | |__| | | (_) | |_) | (_| | \__ \
          \_____|_|\___/|_.__/ \__,_|_|___/
                                           
                                   
    */
    
    address[] public VCUSubTokens;
    mapping(address => bool) VCUSubTokenExists;
    App private creolApp;
    address public ApprovedCarbonVCUAddress;
    /**
     *   __  __           _ _  __ _               
        |  \/  |         | (_)/ _(_)              
        | \  / | ___   __| |_| |_ _  ___ _ __ ___ 
        | |\/| |/ _ \ / _` | |  _| |/ _ \ '__/ __|
        | |  | | (_) | (_| | | | | |  __/ |  \__ \
        |_|  |_|\___/ \__,_|_|_| |_|\___|_|  |___/
        
    */
    modifier onlyCarbonVCU(){
        require(msg.sender == ApprovedCarbonVCUAddress || msg.sender == owner());
        _;
    }
    /**
     * 
          ______               _       
         |  ____|             | |      
         | |____   _____ _ __ | |_ ___ 
         |  __\ \ / / _ \ '_ \| __/ __|
         | |___\ V /  __/ | | | |_\__ \
         |______\_/ \___|_| |_|\__|___/
                                       
     * 
     * 
     */
 
    event LogNewVCUSubToken(address VCUSubToken);
    event newCarbonVCUAddress(address _newCarbonVCUAddress);
    event newAppPackage(App _appPackage);
    
    /**
      *   ______                _   _                 
         |  ____|              | | (_)                
         | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
         |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
         | |  | |_| | | | | (__| |_| | (_) | | | \__ \
         |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
     */
     /**
      * @dev creates a new VCUSubToken contract
      * @notice create new VCUSubToken contract
     * @param _vcuOwner Address that owns the tokens generated in the subtokenization
     * @param _creolSuper Creol Super User address, currently in use during pilots and testing, will be removed on post-Beta release
     * @param _VCUTokenName Name of the ERC20 subtokenization, inherited from the parent VCU
     * @param _VCUTokenSymbol Symbol of the ERC20 subtokenization, inherited from the parent VCU
     * @param decimals Num decimals for token, default is 18
     * @param _cap Token minting cap to prevent overminting of the token. 
      */ 
    function createVCUSubToken(address _vcuOwner,address _parentVCU, address _creolSuper, string memory _VCUTokenName, string memory _VCUTokenSymbol, uint8 decimals, uint256 _cap) public onlyCarbonVCU returns (address _tokenizedVCU)
    {
        
         VCUSubToken tokenizedVCU = new VCUSubToken();
         tokenizedVCU.initialize(_vcuOwner, _parentVCU,_creolSuper,_VCUTokenName,_VCUTokenSymbol,decimals,_cap);
         VCUSubTokens.push(address(tokenizedVCU));
         VCUSubTokenExists[address(tokenizedVCU)] = true;
         emit LogNewVCUSubToken(address(tokenizedVCU));
         
         return address(tokenizedVCU);
    }
    
    function initialize (address _owner) public initializer {
        super.initialize(_owner);
    }
    
    function setAppPackage (App _appPackage) public onlyOwner {
        creolApp = _appPackage;
        emit newAppPackage(_appPackage);
    }
    function createVCUUpgradeableToken(address _proxyAdmin, bytes memory _encodedData) public onlyCarbonVCU returns (address) {
        string memory packageName = "creol-carbon-eth";
        string memory contractName = "VCUSubToken";
        address newVCUSubToken = address(creolApp.create(packageName,contractName,_proxyAdmin, _encodedData));
        VCUSubTokens.push(newVCUSubToken);
        VCUSubTokenExists[newVCUSubToken] = true;
        
        emit LogNewVCUSubToken(newVCUSubToken);
        
        return newVCUSubToken;
    }
    function setCarbonVCUAddress(address _newCarbonVCUAddress) public onlyOwner {
        ApprovedCarbonVCUAddress = _newCarbonVCUAddress;
        emit newCarbonVCUAddress(_newCarbonVCUAddress);
    }
         /**
      * @dev - Converts uints to strings 
      * 
      */ 
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    
}