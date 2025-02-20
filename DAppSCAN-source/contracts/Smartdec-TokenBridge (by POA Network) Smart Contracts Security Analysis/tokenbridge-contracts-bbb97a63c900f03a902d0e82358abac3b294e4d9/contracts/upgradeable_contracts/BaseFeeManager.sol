pragma solidity 0.4.24;


/**
 * @title EternalStorage
 * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
 */
contract EternalStorage {

    mapping(bytes32 => uint256) internal uintStorage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;

}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

interface IRewardableValidators {
    function isValidator(address _validator) public view returns(bool);
    function requiredSignatures() public view returns(uint256);
    function owner() public view returns(address);
    function validatorList() public view returns (address[]);
    function getValidatorRewardAddress(address _validator) public view returns(address);
    function validatorCount() public view returns (uint256);
    function getNextValidator(address _address) public view returns (address);
}

contract FeeTypes {
    bytes32 internal constant HOME_FEE = keccak256(abi.encodePacked("home-fee"));
    bytes32 internal constant FOREIGN_FEE = keccak256(abi.encodePacked("foreign-fee"));
}

contract BaseFeeManager is EternalStorage, FeeTypes {
    using SafeMath for uint256;

    event HomeFeeUpdated(uint256 fee);
    event ForeignFeeUpdated(uint256 fee);

    function calculateFee(uint256 _value, bool _recover, bytes32 _feeType) public view returns(uint256) {
        uint256 fee = _feeType == HOME_FEE ? getHomeFee() : getForeignFee();
        uint256 eth = 1 ether;
        if (!_recover) {
            return _value.mul(fee).div(eth);
        }
        return _value.mul(fee).div(eth.sub(fee));
    }

    function setHomeFee(uint256 _fee) external {
        uintStorage[keccak256(abi.encodePacked("homeFee"))] = _fee;
        emit HomeFeeUpdated(_fee);
    }

    function getHomeFee() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("homeFee"))];
    }

    function setForeignFee(uint256 _fee) external {
        uintStorage[keccak256(abi.encodePacked("foreignFee"))] = _fee;
        emit ForeignFeeUpdated(_fee);
    }

    function getForeignFee() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("foreignFee"))];
    }

    function distributeFeeFromAffirmation(uint256 _fee) external;

    function distributeFeeFromSignatures(uint256 _fee) external;

    function getFeeManagerMode() public pure returns(bytes4);
    // SWC-110-Assert Violation: L48-L50
    function random(uint256 _count) public view returns(uint256) {
        return uint256(blockhash(block.number.sub(1))) % _count;
    }
}
