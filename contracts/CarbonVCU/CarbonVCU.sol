/*
  @title CarbonVCU v0.1.4
 ________  ________  _______   ________  ___          
|\   ____\|\   __  \|\  ___ \ |\   __  \|\  \         
\ \  \___|\ \  \|\  \ \   __/|\ \  \|\  \ \  \        
 \ \  \    \ \   _  _\ \  \_|/_\ \  \\\  \ \  \       
  \ \  \____\ \  \\  \\ \  \_|\ \ \  \\\  \ \  \____  
   \ \_______\ \__\\ _\\ \_______\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|_______|\|_______|
                                             
 
 
   _____           _             __      _______ _    _ 
  / ____|         | |            \ \    / / ____| |  | |
 | |     __ _ _ __| |__   ___  _ _\ \  / / |    | |  | |
 | |    / _` | '__| '_ \ / _ \| '_ \ \/ /| |    | |  | |
 | |___| (_| | |  | |_) | (_) | | | \  / | |____| |__| |
  \_____\__,_|_|  |_.__/ \___/|_| |_|\/   \_____|\____/ 
                                                       
                        
Author:      Joshua Bijak
Date:        March 12, 2019
Title:       CarbonVCU NFT Prototype
Description: Contract that demonstrates NFT enumerability of Carbon VCUs
              
  ___                            _       
|_ _|_ __ ___  _ __   ___  _ __| |_ ___ 
 | || '_ ` _ \| '_ \ / _ \| '__| __/ __|
 | || | | | | | |_) | (_) | |  | |_\__ \
|___|_| |_| |_| .__/ \___/|_|   \__|___/
              |_|                       

*/
pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Enumerable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721MetadataMintable.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Metadata.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Enumerable.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/introspection/IERC165.sol";


import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

import "@openzeppelin/upgrades/contracts/Initializable.sol";

import "../VCUSubToken/VCUSubTokenFactoryInterface.sol";
import "../VCUSubToken/VCUSubTokenInterface.sol";

import "./CarbonVCUInterface.sol";
/*
  _____            _                  _   
 / ____|          | |                | |  
| |     ___  _ __ | |_ _ __ __ _  ___| |_ 
| |    / _ \| '_ \| __| '__/ _` |/ __| __|
| |___| (_) | | | | |_| | | (_| | (__| |_ 
 \_____\___/|_| |_|\__|_|  \__,_|\___|\__|

*/
/**
 * @author Joshua Bijak
 * @title CarbonVCU NFT
 * @dev Contract that demonstrates NFT enumerability of Carbon VCUs
 * @notice CarbonVCU NFT Contract
 * 
 */
contract CarbonVCU is CarbonVCUInterface,Initializable, Ownable, ERC721Enumerable, ERC721MetadataMintable {
    
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
     event CarbonVCUCreated(string name, string symbol, address creolSuper);
     event VCUMinted(uint256 VCUID, address VCUSubToken);
     event VCUSubTokenDeployed(address VCUSubToken);
     event VCUSubTokenFactoryUpdated(address VCUSubtokeFactory);
     event newTokenURI(string _newTokenURI, uint256 _VCUSerialIdx);
     event newProxyAdmin(address _proxyAdmin);

    VCUSubTokenFactoryInterface private genericSubTokenFactoryInterface;
    VCUSubTokenInterface private genericSubTokenInterface;
   
    
        
    /**
     * 
     *    _____ _        _   _          
         / ____| |      | | (_)         
        | (___ | |_ __ _| |_ _  ___ ___ 
         \___ \| __/ _` | __| |/ __/ __|
         ____) | || (_| | |_| | (__\__ \
        |_____/ \__\__,_|\__|_|\___|___/
     * 
     * 
     */
     
    using SafeMath for uint256;
    
    address public creolSuper;
    
      
    struct VCUMetaData {
        uint256 VCUID;
        uint256 VCUSerialIdx;
        string VCUClass;
        uint256 VVBID;
        string VCSRegistry;
        string projectCountryCode;
        uint256 scopeNumber;
        uint256 projectIdentifier;
        uint256 startDate;
        uint256 endDate;
        uint256 additionalCertInfo;
        //address subtokenAddress;
    }
    
    mapping (uint256 => VCUMetaData) public tokenIDtoVCUMetadata;
    mapping (uint256 => address) public tokenIDtoSubtokenAddress;
    mapping(uint256 => bool) NFTisTokenized;
    mapping(uint256 => bool) VCUSerialIdxExists;
    
    // New VARIABLES
    
    address private proxyAdmin;
    
    /**
     *   __  __           _ _  __ _               
        |  \/  |         | (_)/ _(_)              
        | \  / | ___   __| |_| |_ _  ___ _ __ ___ 
        | |\/| |/ _ \ / _` | |  _| |/ _ \ '__/ __|
        | |  | | (_) | (_| | | | | |  __/ |  \__ \
        |_|  |_|\___/ \__,_|_|_| |_|\___|_|  |___/
        
    */
    modifier onlyCreolSuper(){
        require(msg.sender == creolSuper);
        _;
    }
    
   
     
     /**
      *   ______                _   _                 
         |  ____|              | | (_)                
         | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
         |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
         | |  | |_| | | | | (__| |_| | (_) | | | \__ \
         |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
     */
     
    
     
     constructor () public {
         
     }
      /**
      * @notice Deploys a new batch of CarbonVCU NFTs that have Metadata enabled
      * @dev  -  Constructor for CarbonVCU NFT
     *  @param _creolSuper is the super user incharge of the Creol Smart contracting system
     *  @param name Name of the VCU batch
     *  @param symbol for VCU batch
     *  @param _VCUSubTokenFactory SubToken Factory address that is initialized
     * 
     *
     */
     
     function initializeConstruct(string memory name, string memory symbol, address _creolSuper, address _VCUSubTokenFactory) public initializer {
         if(_creolSuper == address(0)){
             creolSuper = msg.sender;
         }
         else{
          
            creolSuper = _creolSuper;      
         }
        genericSubTokenFactoryInterface = VCUSubTokenFactoryInterface(_VCUSubTokenFactory);
        Ownable.initialize(_creolSuper);
        ERC721.initialize();
        ERC721Enumerable.initialize();
        ERC721Metadata.initialize(name,symbol);
        ERC721MetadataMintable.initialize(_creolSuper);
        //super.initialize(name,symbol);
        emit CarbonVCUCreated(name, symbol, creolSuper);

            
     }
     /**
      * @dev mints VCU and immediately tokenizes using "tokenizeVCU"
      * @notice Mint a new VCU using VCS details
      * @param _forOwner Owner to transfer VCU ownership to
      * @param _VCUID ID of this VCU
      * @param _tokenMetadata Metadata for this token. Can be reference to VERRA
      * @param _VCUSerialIdx Index of serial number
      * @param _VCUClass VCU Class number
      * @param _VVBID VVBID number
      * @param _VCSRegistry Registry where credit is currently registered
      * @param _projectCountryCode Project Country Code
      * @param _scopeNumber Scope number
      * @param _projectIdentifier Project Identfier
      * @param _startDate Epoch UTC start date of the VCU
      * @param _endDate Epoch UTC end date of the VCU
      * @param _additionalCertInfo Any other certification info on VERRA
      * 
      */ 
     function mintVCU(address _forOwner, uint256 _VCUID, string memory _tokenMetadata, uint256 _VCUSerialIdx, string memory _VCUClass, uint256 _VVBID, string memory _VCSRegistry, string memory _projectCountryCode, 
     uint256 _scopeNumber, uint256 _projectIdentifier, uint256  _startDate, uint256 _endDate, uint256 _additionalCertInfo) onlyMinter public {
         
         require(VCUSerialIdxExists[_VCUSerialIdx] == false, "VCU Serial Index Already Exists, Cannot Mint");
         super.mintWithTokenURI(_forOwner, _VCUSerialIdx, _tokenMetadata);
         
         tokenIDtoVCUMetadata[_VCUSerialIdx].VCUID = _VCUID;
         tokenIDtoVCUMetadata[_VCUSerialIdx].VCUSerialIdx = _VCUSerialIdx;
         tokenIDtoVCUMetadata[_VCUSerialIdx].VCUClass = _VCUClass;
         tokenIDtoVCUMetadata[_VCUSerialIdx].VVBID = _VVBID;
         tokenIDtoVCUMetadata[_VCUSerialIdx].VCSRegistry = _VCSRegistry;
         tokenIDtoVCUMetadata[_VCUSerialIdx].projectCountryCode = _projectCountryCode;
         tokenIDtoVCUMetadata[_VCUSerialIdx].scopeNumber = _scopeNumber;
         tokenIDtoVCUMetadata[_VCUSerialIdx].projectIdentifier = _projectIdentifier;
         tokenIDtoVCUMetadata[_VCUSerialIdx].startDate = _startDate;
         tokenIDtoVCUMetadata[_VCUSerialIdx].endDate = _endDate;
         tokenIDtoVCUMetadata[_VCUSerialIdx].additionalCertInfo = _additionalCertInfo;
         
         
         VCUSerialIdxExists[_VCUSerialIdx] = true;
         
         address _tokenizedVCU = tokenizeVCU(_forOwner,_VCUSerialIdx);
        
         emit VCUMinted(_VCUSerialIdx, _tokenizedVCU);
     }
     /**
      * @dev tokenizes VCUs by assiging a SubToken ERC20
      * @notice tokenizes Subtoken 
      * @param _forOwner for which VCU owner 
      * @param _VCUSerialIdx VCU serial index 
      */
     function tokenizeVCU(address _forOwner, uint256 _VCUSerialIdx) internal returns (address newVCUAddress) {
         // Cap is always 1,000,000 for grams in ton CO2e
         
         //string s = string(abi.encodePacked("a", " ", "concatenated", " ", "string"));
         //uint256 tempID = _VCUID;
         require(NFTisTokenized[_VCUSerialIdx] == false, "NFT is already tokenized");
        
         string memory convert_VCUID = uint2str(_VCUSerialIdx);
        
         string memory ticker = string(abi.encodePacked("VCUT", convert_VCUID));
         
         string memory tokenName = string(abi.encodePacked("VCU Sub Token ",convert_VCUID));
         
         bytes memory payLoadData = abi.encodeWithSignature("initialize(address,address,address,string,string,uint8,uint256)",_forOwner,address(this),creolSuper,tokenName,ticker,uint8(0x12),uint256(1000000000000000000000000));
         
         address _tokenizedVCU  = genericSubTokenFactoryInterface.createVCUUpgradeableToken(proxyAdmin,payLoadData);
         
         genericSubTokenInterface = VCUSubTokenInterface(_tokenizedVCU);
         
         genericSubTokenInterface.increaseAllowance(_forOwner,1000000000000000000000000);
         
         
         tokenIDtoSubtokenAddress[_VCUSerialIdx] = _tokenizedVCU;
        
         NFTisTokenized[_VCUSerialIdx] = true;
         
         emit VCUSubTokenDeployed(_tokenizedVCU);
         return _tokenizedVCU;
     }
     /**
      * @dev approves buring of subtokens by the owner of the VCU
      * @notice currently this is handled by creolSuper but will change to an ACL contract later
      * @param _forOwner for which VCU owner 
      * @param _VCUSerialIdx VCU serial index 
      * @param _amount Amount of tokens to burn
      */
     function approveBurns(address _forOwner, uint256 _VCUSerialIdx, uint256 _amount) public onlyOwner{
          
          genericSubTokenInterface = VCUSubTokenInterface(tokenIDtoSubtokenAddress[_VCUSerialIdx]);
      
          genericSubTokenInterface.increaseAllowance(_forOwner,_amount);
          
      }
      /**
       * @dev checks if a certain VCU is completely offset or not.
       * @notice this loops through the contracts and can use a LOT of gas
       * @param _VCUSerialIdx VCU serial index
       */
      function isOffset(uint256 _VCUSerialIdx) public returns(bool _isOffset){
          if (NFTisTokenized[_VCUSerialIdx]){
              genericSubTokenInterface = VCUSubTokenInterface(tokenIDtoSubtokenAddress[_VCUSerialIdx]);
              if (genericSubTokenInterface.totalSupply() > 0){
                  return false;
              }
              else {
                  return true;
              }
          }
          else{
              revert("Not Tokenized");
          }
      }
     
     /**
      * @dev returns the SubToken contract address for that VCUSerialIdx
      * @notice this is  mapped against unique numbers
      * @param _VCUSerialIdx VCU serial index
      */
     
      function gettokenIDtoSubtokenAddress(uint256 _VCUSerialIdx) public view returns(address _subtokenAddress){
          return tokenIDtoSubtokenAddress[_VCUSerialIdx];
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
    /**
     * @dev Meant to update interface if it ever needs to change, although unlikely given it uses Proxies
     * @notice Meant to update interface if it ever needs to change, although unlikely given it uses Proxies
     * @param _newVCUTokenFactory Address for new VCUSubTokenFactoryInterface to be used
     */
    function updateVCUSubtokenFactory( address _newVCUTokenFactory) public onlyCreolSuper {
        
        genericSubTokenFactoryInterface = VCUSubTokenFactoryInterface(_newVCUTokenFactory);
        
        emit VCUSubTokenFactoryUpdated(_newVCUTokenFactory);
        
    }
    /**
     * @dev Meant to update the proxyAdmin address, that was added in new version.
     * @notice Meant to update the proxyAdmin address, that was added in new version.
     * @param _proxyAdmin new address of the proxyAdmin contract for the openzeppelin app entry
     */
    function setProxyAdmin( address _proxyAdmin) public onlyCreolSuper {
        proxyAdmin = _proxyAdmin;
        emit newProxyAdmin(_proxyAdmin);
        
    }
    /**
     * @dev Meant to be used to fix URIs of already deployed NFTs to match the ERC1155 standard and use an IPFS address
     * @notice Uses internal _setTokenURI function to achieve this
     * @param _newTokenURI the new tokenURI address to NFTisTokenized
     * @param _VCUSerialIdx the token to change
     */
     
    function setNFTUri(string memory _newTokenURI, uint256 _VCUSerialIdx) public onlyCreolSuper {
        _setTokenURI(_VCUSerialIdx, _newTokenURI);
        emit newTokenURI(_newTokenURI,_VCUSerialIdx);
    }
/**
 * 
 * 
 *   _                      _ 
    | |                    | |
    | |     ___  __ _  __ _| |
    | |    / _ \/ _` |/ _` | |
    | |___|  __/ (_| | (_| | |
    |______\___|\__, |\__,_|_|
                 __/ |        
                |___/    
 * 
 * They come with no warranty and are not for use in a production setting. For production usage, please contact joshua.bijak@creol.io
 * 
 */
 }
 