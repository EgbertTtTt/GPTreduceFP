pragma solidity 0.5.11;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, 'mul');

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, 'div');
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, 'sub');
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'add');

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/// @title ISettings
/// @dev Interface for getting the data from settings contract.
interface ISettings {
    function oracleAddress() external view returns(address);
    function MIN_DEPO() external view returns(uint256);
    function SYS_COMM() external view returns(uint256);
    function USER_COMM() external view returns(uint256);
    function ratio() external view returns(uint256);
    function globalTargetCollateralization() external view returns(uint256);
    function tmvAddress() external view returns(uint256);
    function maxStability() external view returns(uint256);
    function minStability() external view returns(uint256);
    function isFeeManager(address account) external view returns (bool);
    function logicManager() external view returns(address);
}

/// @title ILogic
/// @dev Interface for interaction with the TMV logic contract to manage Boxes.
interface ILogic {
    function create(uint256 withdraw) external payable returns (uint256);
    function precision() external view returns (uint256);
    function rate() external view returns (uint256);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function close(uint256 id) external;
    function withdrawPercent(uint256 _collateral) external view returns(uint256);
    function boxes(uint256 id) external view returns(uint256, uint256);
    function withdrawEth(uint256 _id, uint256 _amount) external;
    function withdrawTmv(uint256 _id, uint256 _amount) external;
    function withdrawableEth(uint256 id) external view returns(uint256);
    function withdrawableTmv(uint256 collateral) external view returns(uint256);
    function maxCapAmount(uint256 _id) external view returns (uint256);
    function capitalize(uint256 _id, uint256 _tmv) external;
    function boxWithdrawableTmv(uint256 _id) external view returns(uint256);
    function addEth(uint256 _id) external payable;
}

/// @title IToken
/// @dev Interface for interaction with the TMV token contract.
interface IToken {
    function burnLogic(address from, uint256 value) external;
    function balanceOf(address who) external view returns (uint256);
    function mint(address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

/// @title ExchangeService
contract ExchangeService {
    using SafeMath for uint256;

    /// @notice The address of the admin account.
    address public admin;

    // The amount of Ether received from the commissions of the system.
    uint256 public systemETH;

    // Commission percentage
    uint256 public commission;

    // The percentage divider
    uint256 public divider = 100000;

    // The minimum deposit amount
    uint256 public minEther;

    ISettings public settings;

    /// @dev An array containing the Ask struct for all Asks in existence. The ID
    ///  of each Ask is actually an index into this array.
    Ask[] public asks;

    /// @dev The main Ask struct. Every Ask is represented by a copy
    ///  of this structure.
    struct Ask {
        address owner;
        uint256 pack;
    }

    /// @dev The AskCreated event is fired whenever a new Ask comes into existence.
    event AskCreated(uint256 id, address owner, uint256 pack);

    /// @dev The AskClosed event is fired whenever Ask is closed.
    event AskClosed(uint256 id, address who);

    /// @dev The AskMatched event is fired whenever an Ask is matched.
    event AskMatched(uint256 id, uint256 tBox, address who, address owner);

    event ExchangeFeeUpdated(uint256 _value);
    event ExchangeMinEtherUpdated(uint256 _value);

    /// @dev Access modifier for admin-only functionality.
    modifier onlyAdmin() {
        require(admin == msg.sender, "You have no access");
        _;
    }

    /// @dev Access modifier for Ask owner-only functionality.
    modifier onlyOwner(uint256 _id) {
        require(asks[_id].owner == msg.sender, "Ask isn't your");
        _;
    }

    modifier onlyExists(uint256 _id) {
        require(asks[_id].owner != address(0), "Ask doesn't exist");
        _;
    }

    /// @notice ISettings address couldn't be changed later.
    /// @dev The contract constructor sets the original `admin` of the contract to the sender
    //   account and sets the settings contract with provided address.
    /// @param _settings The address of the settings contract.
    constructor(ISettings _settings) public {
        admin = msg.sender;
        settings = ISettings(_settings);

        commission = 500; // 0.5%
        emit ExchangeFeeUpdated(commission);

        minEther = 1 ether;
        emit ExchangeMinEtherUpdated(minEther);
    }

    /// @dev Withdraws system fee.
    function withdrawSystemETH(address payable _beneficiary) external onlyAdmin {
        require(_beneficiary != address(0), "Zero address, be careful");
        require(systemETH > 0, "There is no available ETH");

        uint256 _systemETH = systemETH;
        systemETH = 0;
        _beneficiary.transfer(_systemETH);
    }

    /// @dev Reclaims ERC20 tokens.
    function reclaimERC20(address _token, address _beneficiary) external onlyAdmin {
        require(_beneficiary != address(0), "Zero address, be careful");

        uint256 _amount = IToken(_token).balanceOf(address(this));
        require(_amount > 0, "There are no tokens");
        IToken(_token).transfer(_beneficiary, _amount);
    }

    /// @dev Sets commission.
    function setCommission(uint256 _value) external onlyAdmin {
        require(_value <= 10000, "Too much");
        commission = _value;
        emit ExchangeFeeUpdated(_value);
    }

    /// @dev Sets minimum deposit amount.
    function setMinEther(uint256 _value) external onlyAdmin {
        require(_value <= 100 ether, "Too much");
        minEther = _value;
        emit ExchangeMinEtherUpdated(_value);
    }

    /// @dev Sets admin address.
    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Zero address, be careful");
        admin = _newAdmin;
    }

    /// @dev Creates an Ask.
    function create() public payable returns (uint256) {
        require(msg.value >= minEther, "Too small funds");
        // SWC-115-Authorization through tx.origin: L129
        Ask memory _ask = Ask(
            tx.origin,
            msg.value
        );
        uint256 _id = asks.push(_ask).sub(1);
        emit AskCreated(_id, tx.origin, msg.value);
        return _id;
    }

    /// @dev Closes an Ask.
    function close(uint256 _id) external onlyOwner(_id) {

        uint256 _eth = asks[_id].pack;
        delete asks[_id];
        msg.sender.transfer(_eth);
        emit AskClosed(_id, msg.sender);
    }

    /// @dev Uses to match an Ask.
    function take(uint256 _id) external payable onlyExists(_id) returns(uint256) {

        address _owner = asks[_id].owner;
        uint256 _eth = asks[_id].pack;
        uint256 _sysEth = _eth.mul(commission).div(divider);
        systemETH = systemETH.add(_sysEth);
        uint256 _tmv = _eth.mul(ILogic(settings.logicManager()).rate()).div(ILogic(settings.logicManager()).precision());
        uint256 _box = ILogic(settings.logicManager()).create.value(msg.value)(_tmv);
        uint256 _sysTmv = _tmv.mul(commission).div(divider);
        delete asks[_id];
        msg.sender.transfer(_eth.sub(_sysEth));
        ILogic(settings.logicManager()).transferFrom(address(this), msg.sender, _box);
        IToken(settings.tmvAddress()).transfer(_owner, _tmv.sub(_sysTmv));
        emit AskMatched(_id, _box, msg.sender, _owner);
        return _tmv.sub(_sysTmv);
    }
}
