pragma solidity ^0.8.0;


// SPDX-License-Identifier: MIT
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract AvatarArtContext is Context {
    function _now() internal view returns(uint){
        return block.timestamp;
    }
}

abstract contract Ownable is AvatarArtContext {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) internal {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IAvatarArtArtistKYC {
    function isVerified(address account) external view returns(bool); 
}

// SWC-102-Outdated Compiler Version: L3
/**
* @dev Verify and unverify Artist KYC information
* This approvement will be used to verify KYC so that Artist can create their own NFTs
*/
// SWC-135-Code With No Effects: L12
contract AvatarArtArtistKYC is IAvatarArtArtistKYC, Ownable {
    mapping(address => bool) private _isVerifieds;
    
    function isVerified(address account) external override view returns(bool){
        return _isVerifieds[account];
    }
    
    /**
    * @dev Toogle artists' KYC verification status
    * Note that: Only owner can send request
     */
    function toggleVerify(address account) external onlyOwner{
        _isVerifieds[account] = !_isVerifieds[account];
    }
}
