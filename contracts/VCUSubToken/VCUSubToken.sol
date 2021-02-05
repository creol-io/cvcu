/*
  @title VCUSubToken v0.1.4
 ________  ________  _______   ________  ___          
|\   ____\|\   __  \|\  ___ \ |\   __  \|\  \         
\ \  \___|\ \  \|\  \ \   __/|\ \  \|\  \ \  \        
 \ \  \    \ \   _  _\ \  \_|/_\ \  \\\  \ \  \       
  \ \  \____\ \  \\  \\ \  \_|\ \ \  \\\  \ \  \____  
   \ \_______\ \__\\ _\\ \_______\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|_______|\|_______|
                                             

 __      _______ _    _  _____       _  _______    _              
 \ \    / / ____| |  | |/ ____|     | ||__   __|  | |             
  \ \  / / |    | |  | | (___  _   _| |__ | | ___ | | _____ _ __  
   \ \/ /| |    | |  | |\___ \| | | | '_ \| |/ _ \| |/ / _ \ '_ \ 
    \  / | |____| |__| |____) | |_| | |_) | | (_) |   <  __/ | | |
     \/   \_____|\____/|_____/ \__,_|_.__/|_|\___/|_|\_\___|_| |_|
                                                                  
                                                                 
    Date:        September 09, 2019                    

              
  ___                            _       
|_ _|_ __ ___  _ __   ___  _ __| |_ ___ 
 | || '_ ` _ \| '_ \ / _ \| '__| __/ __|
 | || | | | | | |_) | (_) | |  | |_\__ \
|___|_| |_| |_| .__/ \___/|_|   \__|___/
              |_|                       

*/
pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";

import "./VCUSubTokenInterface.sol";
/*
  _____            _                  _   
 / ____|          | |                | |  
| |     ___  _ __ | |_ _ __ __ _  ___| |_ 
| |    / _ \| '_ \| __| '__/ _` |/ __| __|
| |___| (_) | | | | |_| | | (_| | (__| |_ 
 \_____\___/|_| |_|\__|_|  \__,_|\___|\__|

*/
/**
@author Joshua Bijak
@title Tokenized NFT Prototype
@notice Contract that Tokenizes NFTs
@dev Subtoken is deployed by the parent NFT
*/
contract VCUSubToken is VCUSubTokenInterface, Initializable, ERC20, ERC20Burnable, ERC20Mintable {
    
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
    
    address public parentVCU;
    
    address public creolSuper;
    
    address public vcuOwner;
    
    bool public transferEnabled;
    
    string private _name;
    string private _symbol;
    uint8  private _decimals;
  
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
    
    
    modifier canTransfer() {
        require( transferEnabled || msg.sender == creolSuper);
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
     event newVCUTokenCreated(address VCUToken);
     event Transfer(address indexed from, address indexed to, uint256 value);
     event Approval(address indexed owner, address indexed spender, uint256 value);
     
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
      * 
      * @notice VCUSubtoken Constructor
      * @dev  -  Constructor for ERC20 Tokenization of VCUs
     * Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     * @param _vcuOwner Address that owns the tokens generated in the subtokenization
     * @param _creolSuper Creol Super User address, currently in use during pilots and testing, will be removed on post-Beta release
     * @param _VCUTokenName Name of the ERC20 subtokenization, inherited from the parent VCU
     * @param _VCUTokenSymbol Symbol of the ERC20 subtokenization, inherited from the parent VCU
     * @param decimals Num decimals for token, default is 18
     * @param _cap Token minting cap to prevent overminting of the token. 
     * 
     */
     
     function initialize (address _vcuOwner, address _parentVCU, address _creolSuper, string memory _VCUTokenName, string memory _VCUTokenSymbol, uint8 decimals, uint256 _cap) public initializer {
         

        ERC20Mintable.initialize(msg.sender);
        
        vcuOwner = _vcuOwner;
        creolSuper = _creolSuper;
        parentVCU = _parentVCU;
        
         _name = _VCUTokenName;
        _symbol = _VCUTokenSymbol;
        _decimals = decimals;
        
        // Tokens are originally owned by the VCUO, when the VCU is "active", 
        // the VCU transfers the tokens to the vcuOwner for offsetting 
        addMinter(_creolSuper);
        mint(_parentVCU, _cap);
        
        emit newVCUTokenCreated(address(this));
            
     }
     
    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    
    /**
     * @dev Enables transfers of the tokens to other parties other than owner.
     * 
     */
     function setTransferEnabled(bool enable) onlyCreolSuper public {
        transferEnabled = enable;
    }
     /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     * - transferEnabled must be true
     */
    function transfer(address recipient, uint256 amount) canTransfer public returns (bool) {
        super._transfer(msg.sender, recipient, amount);
        return true;
    }
    
    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     * 
     * - transferEnabled must be true
     */
    function transferFrom(address sender, address recipient, uint256 amount) canTransfer public returns (bool) {
        super._transfer(sender, recipient, amount);
        //_approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }
    
    /**
     * @dev Burns a specific amount of tokens.
     * @param value The amount of token to be burned.
     */
    function burn(uint256 value) public {
        super._burn(msg.sender, value);
    }

    /**
     * @dev Burns a specific amount of tokens from the target address and decrements allowance
     * @param from address The address which you want to send tokens from
     * @param value uint256 The amount of token to be burned
     */
    function burnFrom(address from, uint256 value) public {
        super._burnFrom(from, value);
    }
    
    
    
   

    function totalSupply() public view returns (uint256){
        return super.totalSupply();
    }
    

    function balanceOf(address who) public view returns (uint256){
        return super.balanceOf(who);
    }
    
     function approve(address spender, uint256 value) public returns (bool){
        super.approve(spender,value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return super.allowance(owner,spender);
    }
    
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool){
        return super.increaseAllowance(spender,addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
        return super.decreaseAllowance(spender,subtractedValue);
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