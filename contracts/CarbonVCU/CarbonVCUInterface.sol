
pragma solidity ^0.5.0;
/**
 * 
 * 
 * 
 *   @title CarbonVCUInterface v0.0.1
 ________  ________  _______   ________  ___          
|\   ____\|\   __  \|\  ___ \ |\   __  \|\  \         
\ \  \___|\ \  \|\  \ \   __/|\ \  \|\  \ \  \        
 \ \  \    \ \   _  _\ \  \_|/_\ \  \\\  \ \  \       
  \ \  \____\ \  \\  \\ \  \_|\ \ \  \\\  \ \  \____  
   \ \_______\ \__\\ _\\ \_______\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|_______|\|_______|
                                             
 
 
 * 
 * 



   _____           _             __      _______ _    _ _____       _             __               
  / ____|         | |            \ \    / / ____| |  | |_   _|     | |           / _|              
 | |     __ _ _ __| |__   ___  _ _\ \  / / |    | |  | | | |  _ __ | |_ ___ _ __| |_ __ _  ___ ___ 
 | |    / _` | '__| '_ \ / _ \| '_ \ \/ /| |    | |  | | | | | '_ \| __/ _ \ '__|  _/ _` |/ __/ _ \
 | |___| (_| | |  | |_) | (_) | | | \  / | |____| |__| |_| |_| | | | ||  __/ |  | || (_| | (_|  __/
  \_____\__,_|_|  |_.__/ \___/|_| |_|\/   \_____|\____/|_____|_| |_|\__\___|_|  |_| \__,_|\___\___|
                                                                                                   
                                                                                                   

                                    
* @author Joshua Bijak 
* Date:       February 18,2020 
* @notice CarbonVCU Pulling Contract Interface
* @dev CarbonVCU interface to get VCU Information 
 
* 
* 
*           
* 
*/

interface CarbonVCUInterface {
    function gettokenIDtoSubtokenAddress(uint256 _VCUID) external view returns(address _subtokenAddress);
}