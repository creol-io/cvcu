/*
  @title VCUSubTokenInterface v0.1.4
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
Date:        February 17, 2020
Title:       VCUSubToken Contract  interface
Description: interface to VCUSubToken

 
*/

pragma solidity ^0.5.0;
/**
 * @author Joshua Bijak
 * @dev VCUSubToken interface
 * @notice VCUSubTokenInterface interface
 */
interface VCUSubTokenInterface {
    function initialize (address _vcuOwner, address _parentVCU, address _creolSuper, string calldata _VCUTokenName, string calldata _VCUTokenSymbol, uint8 decimals, uint256 _cap) external;

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function setTransferEnabled(bool enable) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount)external returns (bool);
    function burn(uint256 value) external;
    function burnFrom(address from, uint256 value) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    
    function approve(address spender, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


    
}