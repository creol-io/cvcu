/*
  @title VCUSubTokenFactoryInterface v0.0.1
 ________  ________  _______   ________  ___          
|\   ____\|\   __  \|\  ___ \ |\   __  \|\  \         
\ \  \___|\ \  \|\  \ \   __/|\ \  \|\  \ \  \        
 \ \  \    \ \   _  _\ \  \_|/_\ \  \\\  \ \  \       
  \ \  \____\ \  \\  \\ \  \_|\ \ \  \\\  \ \  \____  
   \ \_______\ \__\\ _\\ \_______\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|_______|\|_______|
                                             
 


 __      _______ _    _  _____       _  _______    _              ______         _                   _____       _             __               
 \ \    / / ____| |  | |/ ____|     | ||__   __|  | |            |  ____|       | |                 |_   _|     | |           / _|              
  \ \  / / |    | |  | | (___  _   _| |__ | | ___ | | _____ _ __ | |__ __ _  ___| |_ ___  _ __ _   _  | |  _ __ | |_ ___ _ __| |_ __ _  ___ ___ 
   \ \/ /| |    | |  | |\___ \| | | | '_ \| |/ _ \| |/ / _ \ '_ \|  __/ _` |/ __| __/ _ \| '__| | | | | | | '_ \| __/ _ \ '__|  _/ _` |/ __/ _ \
    \  / | |____| |__| |____) | |_| | |_) | | (_) |   <  __/ | | | | | (_| | (__| || (_) | |  | |_| |_| |_| | | | ||  __/ |  | || (_| | (_|  __/
     \/   \_____|\____/|_____/ \__,_|_.__/|_|\___/|_|\_\___|_| |_|_|  \__,_|\___|\__\___/|_|   \__, |_____|_| |_|\__\___|_|  |_| \__,_|\___\___|
                                                                                                __/ |                                           
                                                                                               |___/                                            

Author:      Joshua Bijak
Date:        February 17, 2020
Title:       VCUSubToken Contract Factory interface
Description: interface to VCUSubTokenFactory

 
*/

pragma solidity ^0.5.0;
/**
 * @author Joshua Bijak
 * @dev VCUSubTokenFactory interface
 * @notice VCUSubTokenFactoryInterface interface
 */
interface VCUSubTokenFactoryInterface {
    function createVCUSubToken(address _vcuOwner,address _parentVCU, address _creolSuper, string calldata _VCUTokenName, string calldata _VCUTokenSymbol, uint8 decimals, uint256 _cap) external returns (address _tokenizedVCU);
    function createVCUUpgradeableToken(address _creolAdmin, bytes calldata _encodedData) external returns (address);
    
    event LogNewVCUSubToken(address VCUSubToken);

    
}