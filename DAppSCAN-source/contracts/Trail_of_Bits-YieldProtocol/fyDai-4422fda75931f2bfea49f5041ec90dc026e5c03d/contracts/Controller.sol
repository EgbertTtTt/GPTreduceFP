pragma solidity ^0.6.10;


// SPDX-License-Identifier: MIT
/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

/// @dev Interface to interact with the vat contract from MakerDAO
/// Taken from https://github.com/makerdao/developerguides/blob/master/devtools/working-with-dsproxy/working-with-dsproxy.md
interface IVat {
    // function can(address, address) external view returns (uint);
    function hope(address) external;
    function nope(address) external;
    function live() external view returns (uint);
    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);
    function urns(bytes32, address) external view returns (uint, uint);
    function gem(bytes32, address) external view returns (uint);
    // function dai(address) external view returns (uint);
    function frob(bytes32, address, address, address, int, int) external;
    function fork(bytes32, address, address, int, int) external;
    function move(address, address, uint) external;
    function flux(bytes32, address, address, uint) external;
}

/// @dev interface for the pot contract from MakerDao
/// Taken from https://github.com/makerdao/developerguides/blob/master/dai/dsr-integration-guide/dsr.sol
interface IPot {
    function chi() external view returns (uint256);
    function pie(address) external view returns (uint256); // Not a function, but a public variable.
    function rho() external returns (uint256);
    function drip() external returns (uint256);
    function join(uint256) external;
    function exit(uint256) external;
}

interface ITreasury {
    function debt() external view returns(uint256);
    function savings() external view returns(uint256);
    function pushDai(address user, uint256 dai) external;
    function pullDai(address user, uint256 dai) external;
    function pushChai(address user, uint256 chai) external;
    function pullChai(address user, uint256 chai) external;
    function pushWeth(address to, uint256 weth) external;
    function pullWeth(address to, uint256 weth) external;
    function shutdown() external;
    function live() external view returns(bool);
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IYDai is IERC20 {
    function isMature() external view returns(bool);
    function maturity() external view returns(uint);
    function chi0() external view returns(uint);
    function rate0() external view returns(uint);
    function chiGrowth() external view returns(uint);
    function rateGrowth() external view returns(uint);
    function mature() external;
    function mint(address, uint) external;
    function burn(address, uint) external;
    function flashMint(address, uint, bytes calldata) external;
    // function transfer(address, uint) external returns (bool);
    // function transferFrom(address, address, uint) external returns (bool);
    // function approve(address, uint) external returns (bool);
}

interface IController {
    function series(uint256) external view returns (IYDai);
    function seriesIterator(uint256) external view returns (uint256);
    function totalSeries() external view returns (uint256);
    function containsSeries(uint256) external view returns (bool);
    function posted(bytes32, address) external view returns (uint256);
    function debtYDai(bytes32, uint256, address) external view returns (uint256);
    function totalDebtDai(bytes32, address) external view returns (uint256);
    function isCollateralized(bytes32, address) external view returns (bool);
    function inDai(bytes32, uint256, uint256) external view returns (uint256);
    function inYDai(bytes32, uint256, uint256) external view returns (uint256);
    function erase(bytes32, address) external returns (uint256, uint256);
    function shutdown() external;
    function post(bytes32, address, address, uint256) external;
    function withdraw(bytes32, address, address, uint256) external;
    function borrow(bytes32, uint256, address, address, uint256) external;
    function repayYDai(bytes32, uint256, address, address, uint256) external;
    function repayDai(bytes32, uint256, address, address, uint256) external;
}

/// @dev Delegable enables users to delegate their account management to other users
contract Delegable {
    event Delegate(address indexed user, address indexed delegate, bool enabled);

    mapping(address => mapping(address => bool)) public delegated;

    /// @dev Require that msg.sender is the account holder or a delegate
    modifier onlyHolderOrDelegate(address holder, string memory errorMessage) {
        require(
            msg.sender == holder || delegated[holder][msg.sender],
            errorMessage
        );
        _;
    }

    /// @dev Enable a delegate to act on the behalf of caller
    function addDelegate(address delegate) public {
        delegated[msg.sender][delegate] = true;
        emit Delegate(msg.sender, delegate, true);
    }

    /// @dev Stop a delegate from acting on the behalf of caller
    function revokeDelegate(address delegate) public {
        delegated[msg.sender][delegate] = false;
        emit Delegate(msg.sender, delegate, false);
    }
}

/// @dev Implements simple fixed point math mul and div operations for 27 decimals.
contract DecimalMath {
    using SafeMath for uint256;

    uint256 constant public UNIT = 1000000000000000000000000000;

    /// @dev Multiplies x and y, assuming they are both fixed point with 27 digits.
    function muld(uint256 x, uint256 y) internal pure returns (uint256) {
        return x.mul(y).div(UNIT);
    }

    /// @dev Divides x between y, assuming they are both fixed point with 27 digits.
    function divd(uint256 x, uint256 y) internal pure returns (uint256) {
        return x.mul(UNIT).div(y);
    }

    /// @dev Divides x between y, rounding up to the closest representable number.
    /// Assumes x and y are both fixed point with `decimals` digits.
    function divdrup(uint256 x, uint256 y)
        internal pure returns (uint256)
    {
        uint256 z = x.mul(10000000000000000000000000000).div(y); // RAY * 10
        if (z % 10 > 0) return z / 10 + 1;
        else return z / 10;
    }
}

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

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Orchestrated allows to define static access control between multiple contracts.
 * This contract would be used as a parent contract of any contract that needs to restrict access to some methods,
 * which would be marked with the `onlyOrchestrated modifier.
 * During deployment, the contract deployer (`owner`) can register any contracts that have privileged access by calling `orchestrate`.
 * Once deployment is completed, `owner` can call `transferOwnership(address(0))` to avoid any more contracts ever gaining privileged access.
 */
contract Orchestrated is Ownable {
    event GrantedAccess(address access);

    mapping(address => bool) public authorized;

    constructor () public Ownable() {}

    /// @dev Restrict usage to authorized users
    modifier onlyOrchestrated(string memory err) {
        require(authorized[msg.sender], err);
        _;
    }

    /// @dev Add user to the authorized users list
    function orchestrate(address user) public onlyOwner {
        authorized[user] = true;
        emit GrantedAccess(user);
    }
}

/**
 * @dev The Controller manages collateral and debt levels for all users, and it is a major user entry point for the Yield protocol.
 * Controller keeps track of a number of yDai contracts.
 * Controller allows users to post and withdraw Chai and Weth collateral.
 * Any transactions resulting in a user weth collateral below dust are reverted.
 * Controller allows users to borrow yDai against their Chai and Weth collateral.
 * Controller allows users to repay their yDai debt with yDai or with Dai.
 * Controller integrates with yDai contracts for minting yDai on borrowing, and burning yDai on repaying debt with yDai.
 * Controller relies on Treasury for all other asset transfers.
 * Controller allows orchestrated contracts to erase any amount of debt or collateral for an user. This is to be used during liquidations or during unwind.
 * Users can delegate the control of their accounts in Controllers to any address.
 */
contract Controller is IController, Orchestrated(), Delegable(), DecimalMath {
    using SafeMath for uint256;

    event Posted(bytes32 indexed collateral, address indexed user, int256 amount);
    event Borrowed(bytes32 indexed collateral, uint256 indexed maturity, address indexed user, int256 amount);

    bytes32 public constant CHAI = "CHAI";
    bytes32 public constant WETH = "ETH-A";
    uint256 public constant DUST = 50000000000000000; // 0.05 ETH
    uint256 public constant THREE_MONTHS = 7776000;

    IVat internal _vat;
    IPot internal _pot;
    ITreasury internal _treasury;

    mapping(uint256 => IYDai) public override series;                 // YDai series, indexed by maturity
    uint256[] public override seriesIterator;                         // We need to know all the series

    mapping(bytes32 => mapping(address => uint256)) public override posted;                        // Collateral posted by each user
    mapping(bytes32 => mapping(uint256 => mapping(address => uint256))) public override debtYDai;  // Debt owed by each user, by series

    bool public live = true;

    /// @dev Set up addresses for vat, pot and Treasury.
    constructor (
        address vat_,
        address pot_,
        address treasury_
    ) public {
        _vat = IVat(vat_);
        _pot = IPot(pot_);
        _treasury = ITreasury(treasury_);
    }

    /// @dev Modified functions only callable while the Controller is not unwinding due to a MakerDAO shutdown.
    modifier onlyLive() {
        require(live == true, "Controller: Not available during unwind");
        _;
    }

    /// @dev Only valid collateral types are Weth and Chai.
    modifier validCollateral(bytes32 collateral) {
        require(
            collateral == WETH || collateral == CHAI,
            "Controller: Unrecognized collateral"
        );
        _;
    }

    /// @dev Only series added through `addSeries` are valid.
    modifier validSeries(uint256 maturity) {
        require(
            containsSeries(maturity),
            "Controller: Unrecognized series"
        );
        _;
    }

    /// @dev Safe casting from uint256 to int256
    function toInt256(uint256 x) internal pure returns(int256) {
        require(
            x <= 57896044618658097711785492504343953926634992332820282019728792003956564819967,
            "Controller: Cast overflow"
        );
        return int256(x);
    }

    /// @dev Disables post, withdraw, borrow and repay. To be called only when Treasury shuts down.
    function shutdown() public override {
        require(
            _treasury.live() == false,
            "Controller: Treasury is live"
        );
        live = false;
    }

    /// @dev Return if the borrowing power for a given collateral of a user is equal or greater
    /// than its debt for the same collateral
    /// @param collateral Valid collateral type
    /// @param user Address of the user vault
    function isCollateralized(bytes32 collateral, address user) public view override returns (bool) {
        return powerOf(collateral, user) >= totalDebtDai(collateral, user);
    }

    /// @dev Return if the collateral of an user is between zero and the dust level
    /// @param collateral Valid collateral type
    /// @param user Address of the user vault
    function aboveDustOrZero(bytes32 collateral, address user) public view returns (bool) {
        uint256 postedCollateral = posted[collateral][user];
        return postedCollateral == 0 || DUST < postedCollateral;
    }

    /// @dev Return the total number of series registered
    function totalSeries() public view override returns (uint256) {
        return seriesIterator.length;
    }

    /// @dev Returns if a series has been added to the Controller.
    /// @param maturity Maturity of the series to verify.
    function containsSeries(uint256 maturity) public view override returns (bool) {
        return address(series[maturity]) != address(0);
    }

    /// @dev Adds an yDai series to this Controller
    /// After deployment, ownership should be renounced, so that no more series can be added.
    /// @param yDaiContract Address of the yDai series to add.
    function addSeries(address yDaiContract) public onlyOwner {
        uint256 maturity = IYDai(yDaiContract).maturity();
        require(
            !containsSeries(maturity),
            "Controller: Series already added"
        );
        series[maturity] = IYDai(yDaiContract);
        seriesIterator.push(maturity);
    }

    /// @dev Dai equivalent of a yDai amount.
    /// After maturity, the Dai value of a yDai grows according to either the stability fee (for WETH collateral) or the Dai Saving Rate (for Chai collateral).
    /// @param collateral Valid collateral type
    /// @param maturity Maturity of an added series
    /// @param yDaiAmount Amount of yDai to convert.
    /// @return Dai equivalent of an yDai amount.
    function inDai(bytes32 collateral, uint256 maturity, uint256 yDaiAmount)
        public view override
        validCollateral(collateral)
        returns (uint256)
    {
        IYDai yDai = series[maturity];
        if (yDai.isMature()){
            if (collateral == WETH){
                return muld(yDaiAmount, yDai.rateGrowth());
            } else if (collateral == CHAI) {
                return muld(yDaiAmount, yDai.chiGrowth());
            }
        } else {
            return yDaiAmount;
        }
    }

    /// @dev yDai equivalent of a Dai amount.
    /// After maturity, the yDai value of a Dai decreases according to either the stability fee (for WETH collateral) or the Dai Saving Rate (for Chai collateral).
    /// @param collateral Valid collateral type
    /// @param maturity Maturity of an added series
    /// @param daiAmount Amount of Dai to convert.
    /// @return yDai equivalent of a Dai amount.
    function inYDai(bytes32 collateral, uint256 maturity, uint256 daiAmount)
        public view override
        validCollateral(collateral)
        returns (uint256)
    {
        IYDai yDai = series[maturity];
        if (yDai.isMature()){
            if (collateral == WETH){
                return divd(daiAmount, yDai.rateGrowth());
            } else if (collateral == CHAI) {
                return divd(daiAmount, yDai.chiGrowth());
            }
        } else {
            return daiAmount;
        }
    }

    /// @dev Debt in dai of an user
    /// After maturity, the Dai debt of a position grows according to either the stability fee (for WETH collateral) or the Dai Saving Rate (for Chai collateral).
    /// @param collateral Valid collateral type
    /// @param maturity Maturity of an added series
    /// @param user Address of the user vault
    /// @return Debt in dai of an user
    //
    //                        rate_now
    // debt_now = debt_mat * ----------
    //                        rate_mat
    //
    function debtDai(bytes32 collateral, uint256 maturity, address user) public view returns (uint256) {
        return inDai(collateral, maturity, debtYDai[collateral][maturity][user]);
    }

    /// @dev Total debt of an user across all series, in Dai
    /// The debt is summed across all series, taking into account interest on the debt after a series matures.
    /// This function loops through all maturities, limiting the contract to hundreds of maturities.
    /// @param collateral Valid collateral type
    /// @param user Address of the user vault
    /// @return Total debt of an user across all series, in Dai
    function totalDebtDai(bytes32 collateral, address user) public view override returns (uint256) {
        uint256 totalDebt;
        uint256[] memory _seriesIterator = seriesIterator;
        for (uint256 i = 0; i < _seriesIterator.length; i += 1) {
            if (debtYDai[collateral][_seriesIterator[i]][user] > 0) {
                totalDebt = totalDebt + debtDai(collateral, _seriesIterator[i], user);
            }
        } // We don't expect hundreds of maturities per controller
        return totalDebt;
    }

    /// @dev Borrowing power (in dai) of a user for a specific series and collateral.
    /// @param collateral Valid collateral type
    /// @param user Address of the user vault
    /// @return Borrowing power of an user in dai.
    //
    // powerOf[user](wad) = posted[user](wad) * price()(ray)
    //
    function powerOf(bytes32 collateral, address user) public view returns (uint256) {
        // dai = price * collateral
        if (collateral == WETH){
            (,, uint256 spot,,) = _vat.ilks(WETH);  // Stability fee and collateralization ratio for Weth
            return muld(posted[collateral][user], spot);
        } else if (collateral == CHAI) {
            uint256 chi = _pot.chi();
            return muld(posted[collateral][user], chi);
        }
        return 0;
    }

    /// @dev Returns the amount of collateral locked in borrowing operations.
    /// @param collateral Valid collateral type.
    /// @param user Address of the user vault.
    function locked(bytes32 collateral, address user)
        public view
        validCollateral(collateral)
        returns (uint256)
    {
        if (collateral == WETH){
            (,, uint256 spot,,) = _vat.ilks(WETH);  // Stability fee and collateralization ratio for Weth
            return divdrup(totalDebtDai(collateral, user), spot);
        } else if (collateral == CHAI) {
            return divdrup(totalDebtDai(collateral, user), _pot.chi());
        }
    }

    /// @dev Takes collateral assets from `from` address, and credits them to `to` collateral account.
    /// `from` can delegate to other addresses to take assets from him. Also needs to use `ERC20.approve`.
    /// Calling ERC20.approve for Treasury contract is a prerequisite to this function
    /// @param collateral Valid collateral type.
    /// @param from Wallet to take collateral from.
    /// @param to Yield vault to put the collateral in.
    /// @param amount Amount of collateral to move.
    // from --- Token ---> us(to)
    function post(bytes32 collateral, address from, address to, uint256 amount)
        public override 
        validCollateral(collateral)
        onlyHolderOrDelegate(from, "Controller: Only Holder Or Delegate")
        onlyLive
    {
        posted[collateral][to] = posted[collateral][to].add(amount);

        if (collateral == WETH){
            require(
                aboveDustOrZero(collateral, to),
                "Controller: Below dust"
            );
            _treasury.pushWeth(from, amount);
        } else if (collateral == CHAI) {
            _treasury.pushChai(from, amount);
        }
        
        emit Posted(collateral, to, toInt256(amount));
    }

    /// @dev Returns collateral to `to` wallet, taking it from `from` Yield vault account.
    /// `from` can delegate to other addresses to take assets from him.
    /// @param collateral Valid collateral type.
    /// @param from Yield vault to take collateral from.
    /// @param to Wallet to put the collateral in.
    /// @param amount Amount of collateral to move.
    // us(from) --- Token ---> to
    // SWC-105-Unprotected Ether Withdrawal: L294 - L320
    function withdraw(bytes32 collateral, address from, address to, uint256 amount)
        public override
        validCollateral(collateral)
        onlyHolderOrDelegate(from, "Controller: Only Holder Or Delegate")
        onlyLive
    {
        posted[collateral][from] = posted[collateral][from].sub(amount); // Will revert if not enough posted

        require(
            isCollateralized(collateral, from),
            "Controller: Too much debt"
        );

        if (collateral == WETH){
            require(
                aboveDustOrZero(collateral, to),
                "Controller: Below dust"
            );
            _treasury.pullWeth(to, amount);
        } else if (collateral == CHAI) {
            _treasury.pullChai(to, amount);
        }

        emit Posted(collateral, from, -toInt256(amount));
    }

    /// @dev Mint yDai for a given series for wallet `to` by increasing the user debt in Yield vault `from`
    /// `from` can delegate to other addresses to borrow using his vault.
    /// The collateral needed changes according to series maturity and MakerDAO rate and chi, depending on collateral type.
    /// @param collateral Valid collateral type.
    /// @param maturity Maturity of an added series
    /// @param from Yield vault that gets an increased debt.
    /// @param to Wallet to put the yDai in.
    /// @param yDaiAmount Amount of yDai to borrow.
    //
    // posted[user](wad) >= (debtYDai[user](wad)) * amount (wad)) * collateralization (ray)
    //
    // us(from) --- yDai ---> to
    // debt++
    function borrow(bytes32 collateral, uint256 maturity, address from, address to, uint256 yDaiAmount)
        public override
        validCollateral(collateral)
        validSeries(maturity)
        onlyHolderOrDelegate(from, "Controller: Only Holder Or Delegate")
        onlyLive
    {
        IYDai yDai = series[maturity];

        debtYDai[collateral][maturity][from] = debtYDai[collateral][maturity][from].add(yDaiAmount);

        require(
            isCollateralized(collateral, from),
            "Controller: Too much debt"
        );

        yDai.mint(to, yDaiAmount);
        emit Borrowed(collateral, maturity, from, toInt256(yDaiAmount));
    }

    /// @dev Burns yDai from `from` wallet to repay debt in a Yield Vault.
    /// User debt is decreased for the given collateral and yDai series, in Yield vault `to`.
    /// `from` can delegate to other addresses to take yDai from him for the repayment.
    /// Calling yDai.approve for Controller contract is a prerequisite to this function
    /// @param collateral Valid collateral type.
    /// @param maturity Maturity of an added series
    /// @param from Wallet providing the yDai for repayment.
    /// @param to Yield vault to repay debt for.
    /// @param yDaiAmount Amount of yDai to use for debt repayment.
    //
    //                                                  debt_nominal
    // debt_discounted = debt_nominal - repay_amount * ---------------
    //                                                  debt_now
    //
    // user(from) --- yDai ---> us(to)
    // debt--
    function repayYDai(bytes32 collateral, uint256 maturity, address from, address to, uint256 yDaiAmount)
        public override
        validCollateral(collateral)
        validSeries(maturity)
        onlyHolderOrDelegate(from, "Controller: Only Holder Or Delegate")
        onlyLive
    {
        uint256 toRepay = Math.min(yDaiAmount, debtYDai[collateral][maturity][to]);
        series[maturity].burn(from, toRepay);
        _repay(collateral, maturity, to, toRepay);
    }

    /// @dev Burns Dai from `from` wallet to repay debt in a Yield Vault.
    /// User debt is decreased for the given collateral and yDai series, in Yield vault `to`.
    /// The amount of debt repaid changes according to series maturity and MakerDAO rate and chi, depending on collateral type.
    /// `from` can delegate to other addresses to take Dai from him for the repayment.
    /// Calling ERC20.approve for Treasury contract is a prerequisite to this function
    /// @param collateral Valid collateral type.
    /// @param maturity Maturity of an added series
    /// @param from Wallet providing the Dai for repayment.
    /// @param to Yield vault to repay debt for.
    /// @param daiAmount Amount of Dai to use for debt repayment.
    //
    //                                                  debt_nominal
    // debt_discounted = debt_nominal - repay_amount * ---------------
    //                                                  debt_now
    //
    // user --- dai ---> us
    // debt--
    function repayDai(bytes32 collateral, uint256 maturity, address from, address to, uint256 daiAmount)
        public override
        validCollateral(collateral)
        validSeries(maturity)
        onlyHolderOrDelegate(from, "Controller: Only Holder Or Delegate")
        onlyLive
    {
        uint256 toRepay = Math.min(daiAmount, debtDai(collateral, maturity, to));
        _treasury.pushDai(from, toRepay);                                      // Have Treasury process the dai
        _repay(collateral, maturity, to, inYDai(collateral, maturity, toRepay));
    }

    /// @dev Removes an amount of debt from an user's vault.
    /// Internal function.
    /// @param collateral Valid collateral type.
    /// @param maturity Maturity of an added series
    /// @param user Yield vault to repay debt for.
    /// @param yDaiAmount Amount of yDai to use for debt repayment.

    //
    //                                                principal
    // principal_repayment = gross_repayment * ----------------------
    //                                          principal + interest
    //    
    function _repay(bytes32 collateral, uint256 maturity, address user, uint256 yDaiAmount) internal {
        debtYDai[collateral][maturity][user] = debtYDai[collateral][maturity][user].sub(yDaiAmount);

        emit Borrowed(collateral, maturity, user, -toInt256(yDaiAmount));
    }

    /// @dev Removes all collateral and debt for an user, for a given collateral type.
    /// This function can only be called by other Yield contracts, not users directly.
    /// @param collateral Valid collateral type.
    /// @param user Address of the user vault
    /// @return The amounts of collateral and debt removed from Controller.
    function erase(bytes32 collateral, address user)
        public override
        validCollateral(collateral)
        onlyOrchestrated("Controller: Not Authorized")
        returns (uint256, uint256)
    {
        uint256 userCollateral = posted[collateral][user];
        delete posted[collateral][user];

        uint256 userDebt;
        uint256[] memory _seriesIterator = seriesIterator;
        for (uint256 i = 0; i < _seriesIterator.length; i += 1) {
            uint256 maturity = _seriesIterator[i];
            userDebt = userDebt.add(debtDai(collateral, maturity, user)); // SafeMath shouldn't be needed
            delete debtYDai[collateral][maturity][user];
        } // We don't expect hundreds of maturities per controller

        return (userCollateral, userDebt);
    }
}
