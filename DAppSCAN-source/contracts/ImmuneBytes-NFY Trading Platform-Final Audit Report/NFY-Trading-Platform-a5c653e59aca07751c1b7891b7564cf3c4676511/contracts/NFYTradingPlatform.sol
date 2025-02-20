pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;


// SPDX-License-Identifier: MIT
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

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
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


contract Ownable is Context {

    address payable public owner;
    address public dev;

    event TransferredOwnership(address _previous, address _next, uint256 _time);

    modifier onlyOwner() {
        require(_msgSender() == owner, "Owner only");
        _;
    }

    modifier onlyDev() {
        require(_msgSender() == dev, "Dev only");
        _;
    }

    constructor(address _dev) public {
        owner = _msgSender();
        dev = _dev;
    }

    function transferOwnership(address payable _owner) public onlyOwner() {
        address previousOwner = owner;
        owner = _owner;
        emit TransferredOwnership(previousOwner, owner, now);
    }

    function transferDev(address _dev) public onlyDev() {
        dev = _dev;
    }

}

interface NFTContract {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function nftTokenId(address _stakeholder) external view returns(uint256 id);
}

contract NFYTradingPlatform is Ownable {
    using SafeMath for uint;

    // SWC-131-Presence of unused variables
    bytes32 constant ETH = 'ETH';

    bytes32[] private stakeTokenList;
    uint private nextTradeId;
    uint private nextOrderId;

    uint public platformFee;

    IERC20 public NFYToken;
    address public rewardPool;
    address public communityFund;
    address public devAddress;

    enum Side {
        BUY,
        SELL
    }

    struct StakeToken {
        bytes32 ticker;
        NFTContract nftContract;
        address nftAddress;
        address stakingAddress;
    }

    struct Order {
        uint id;
        address userAddress;
        Side side;
        bytes32 ticker;
        uint amount;
        uint filled;
        uint price;
        uint date;
    }

    struct PendingTransactions{
        uint pendingAmount;
        uint id;
    }

    mapping(bytes32 => mapping(address => PendingTransactions[])) private pendingETH;

    mapping(bytes32 => mapping(address => PendingTransactions[])) private pendingToken;

    mapping(bytes32 => StakeToken) private tokens;

    mapping(address => mapping(bytes32 => uint)) private traderBalances;

    mapping(bytes32 => mapping(uint => Order[])) private orderBook;

    mapping(address => uint) private ethBalance;

    // Event for a new trade
    event NewTrade(
        uint tradeId,
        uint orderId,
        bytes32 indexed ticker,
        address trader1,
        address trader2,
        uint amount,
        uint price,
        uint date
    );

    constructor(address _nfy, address _rewardPool, uint _fee, address _devFeeAddress, address _communityFundAddress, address _dev) Ownable(_dev) public {
        NFYToken = IERC20(_nfy);
        rewardPool = _rewardPool;
        platformFee = _fee;
        devAddress = _devFeeAddress;
        communityFund = _communityFundAddress;
    }

    // Function that updates platform fee
    function setFee(uint _fee) external onlyOwner() {
        platformFee = _fee;
    }

    // Function that updates dev address for portion of fee
    function setDevFeeAddress(address _devAddress) external onlyDev() {
        devAddress = _devAddress;
    }

    // Function that updates community address for portion of fee
    function setCommunityFeeAddress(address _communityAddress) external onlyOwner() {
        communityFund = _communityAddress;
    }

    // Function that gets balance of a user
    function getTraderBalance(address _user, string memory ticker) external view returns(uint) {
        bytes32 _ticker = stringToBytes32(ticker);

        return traderBalances[_user][_ticker];
    }

    // Function that gets eth balance of a user
    function getEthBalance(address _user) external view returns(uint) {
        return ethBalance[_user];
    }

    // Function that adds staking NFT
    function addToken(string memory ticker, NFTContract _NFTContract, address _nftAddress, address _stakingAddress) onlyOwner() external {
        bytes32 _ticker = stringToBytes32(ticker);
        tokens[_ticker] = StakeToken(_ticker, _NFTContract, _nftAddress, _stakingAddress);
        stakeTokenList.push(_ticker);
    }

    // Function that allows user to deposit staking NFT
    function depositStake(string memory ticker, uint _tokenId, uint _amount) stakeNFTExist(ticker) external {
        bytes32 _ticker = stringToBytes32(ticker);
        require(tokens[_ticker].nftContract.ownerOf(_tokenId) == _msgSender(), "Owner of token is not user");

        (bool success, bytes memory data) = tokens[_ticker].stakingAddress.call(abi.encodeWithSignature("decrementNFTValue(uint256,uint256)", _tokenId, _amount));
        require(success == true, "decrement call failed");

        traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].add(_amount);
    }

    // Function that allows a user to withdraw their staking NFT
    function withdrawStake(string memory ticker, uint _amount) stakeNFTExist(ticker) external {
        bytes32 _ticker = stringToBytes32(ticker);

        if(tokens[_ticker].nftContract.nftTokenId(_msgSender()) == 0){
            addStakeholder(_ticker);
        }

        uint _tokenId = tokens[_ticker].nftContract.nftTokenId(_msgSender());
        require(traderBalances[_msgSender()][_ticker] >= _amount, 'balance too low');

        (bool success, bytes memory data) = tokens[_ticker].stakingAddress.call(abi.encodeWithSignature("incrementNFTValue(uint256,uint256)", _tokenId, _amount));
        require(success == true, "increment call failed");

        traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].sub(_amount);
    }

    // Function that deposits eth
    function depositEth() external payable{
        ethBalance[_msgSender()] = ethBalance[_msgSender()].add(msg.value);
    }

    // Function that withdraws eth
    function withdrawEth(uint _amount) external{
        require(_amount > 0, "cannot withdraw 0 eth");
        require(ethBalance[_msgSender()] >= _amount, "Not enough eth in trading balance");

        uint amountToWithdraw = _amount;
        ethBalance[_msgSender()] = ethBalance[_msgSender()].sub(_amount);

        _msgSender().transfer(amountToWithdraw);
    }

    // Function that adds stakeholder
    function addStakeholder(bytes32 _ticker) private {
        address _stakeholder = _msgSender();
        (bool success, bytes memory data) = tokens[_ticker].stakingAddress.call(abi.encodeWithSignature("addStakeholderExternal(address)", _stakeholder));
        require(success == true, "add stakeholder call failed");
    }

    // Function that gets total all orders
    function getOrders(string memory ticker, Side side) external view returns(Order[] memory) {
        bytes32 _ticker = stringToBytes32(ticker);

        return orderBook[_ticker][uint(side)];
     }

    // Function that gets all trading
    function getTokens() external view returns(StakeToken[] memory) {
         StakeToken[] memory _tokens = new StakeToken[](stakeTokenList.length);
         for (uint i = 0; i < stakeTokenList.length; i++) {
             _tokens[i] = StakeToken(
               tokens[stakeTokenList[i]].ticker,
               tokens[stakeTokenList[i]].nftContract,
               tokens[stakeTokenList[i]].nftAddress,
               tokens[stakeTokenList[i]].stakingAddress
             );
         }
         return _tokens;
    }

    // Function that creates limit order
    function createLimitOrder(string memory ticker, uint _amount, uint _price, Side _side) external {
        require(NFYToken.balanceOf(_msgSender()) >= platformFee, "Do not have enough NFY to cover fee");

        uint devFee = platformFee.div(100).mul(10);
        uint communityFee = platformFee.div(100).mul(5);

        uint rewardFee = platformFee.sub(devFee).sub(communityFee);

        NFYToken.transferFrom(_msgSender(), devAddress, devFee);
        NFYToken.transferFrom(_msgSender(), communityFund, communityFee);
        NFYToken.transferFrom(_msgSender(), rewardPool, rewardFee);

        _limitOrder(ticker, _amount, _price, _side);
    }

    // Limit order Function
    function _limitOrder(string memory ticker, uint _amount, uint _price, Side _side) stakeNFTExist(ticker) internal {
        bytes32 _ticker = stringToBytes32(ticker);
        require(_amount > 0, "Amount can not be 0");

        Order[] storage orders = orderBook[_ticker][uint(_side == Side.BUY ? Side.SELL : Side.BUY)];
        if(orders.length == 0){
            _createOrder(_ticker, _amount, _price, _side);
        }
        else{
            if(_side == Side.BUY){
                uint remaining = _amount;
                uint i;
                uint orderLength = orders.length;
                while(i < orders.length && remaining > 0) {

                    if(_price >= orders[i].price){
                        remaining = _matchOrder(_ticker,orders, remaining, i, _side);
                        nextTradeId = nextTradeId.add(1);

                        if(orders.length.sub(i) == 1 && remaining > 0){
                            _createOrder(_ticker, remaining, _price, _side);
                        }
                        i = i.add(1);
                    }
                    else{
                        i = orderLength;
                        if(remaining > 0){
                            _createOrder(_ticker, remaining, _price, _side);
                        }
                    }
                }
            }

            if(_side == Side.SELL){
                uint remaining = _amount;
                uint i;
                uint orderLength = orders.length;
                while(i < orders.length && remaining > 0) {
                    if(_price <= orders[i].price){
                        remaining = _matchOrder(_ticker,orders, remaining, i, _side);
                        nextTradeId = nextTradeId.add(1);

                        if(orders.length.sub(i) == 1 && remaining > 0){
                            _createOrder(_ticker, remaining, _price, _side);
                        }
                        i = i.add(1);
                    }
                    else{
                        i = orderLength;
                        if(remaining > 0){
                            _createOrder(_ticker, remaining, _price, _side);
                        }
                    }
                }
            }

           uint i = 0;

            while(i < orders.length && orders[i].filled == orders[i].amount) {
                for(uint j = i; j < orders.length.sub(1); j = j.add(1) ) {
                    orders[j] = orders[j.add(1)];
                }
            orders.pop();
            i = i.add(1);
            }
        }
    }

    function _createOrder(bytes32 _ticker, uint _amount, uint _price, Side _side) internal {
        if(_side == Side.BUY) {
            require(ethBalance[_msgSender()] > 0, "Can not purchase no stake");
            require(ethBalance[_msgSender()] >= _amount.mul(_price).div(1e18), "Eth too low");
            PendingTransactions[] storage pending = pendingETH[_ticker][_msgSender()];
            pending.push(PendingTransactions(_amount.mul(_price).div(1e18), nextOrderId));
            ethBalance[_msgSender()] = ethBalance[_msgSender()].sub(_amount.mul(_price).div(1e18));
        }
        else {
            require(traderBalances[_msgSender()][_ticker] >= _amount, "Token too low");
            PendingTransactions[] storage pending = pendingToken[_ticker][_msgSender()];
            pending.push(PendingTransactions(_amount, nextOrderId));
            traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].sub(_amount);
        }

        Order[] storage orders = orderBook[_ticker][uint(_side)];

        orders.push(Order(
            nextOrderId,
            _msgSender(),
            _side,
            _ticker,
            _amount,
            0,
            _price,
            now
        ));

        uint i = orders.length > 0 ? orders.length.sub(1) : 0;
        while(i > 0) {
            if(_side == Side.BUY && orders[i.sub(1)].price > orders[i].price) {
                break;
            }
            if(_side == Side.SELL && orders[i.sub(1)].price < orders[i].price) {
                break;
            }
            Order memory order = orders[i.sub(1)];
            orders[i.sub(1)] = orders[i];
            orders[i] = order;
            i = i.sub(1);
        }
        nextOrderId = nextOrderId.add(1);
    }

    function _matchOrder(bytes32 _ticker, Order[] storage orders, uint remaining, uint i, Side side) internal returns(uint left){
        uint available = orders[i].amount.sub(orders[i].filled);
        uint matched = (remaining > available) ? available : remaining;
        remaining = remaining.sub(matched);
        orders[i].filled = orders[i].filled.add(matched);

        emit NewTrade(
            nextTradeId,
            orders[i].id,
            _ticker,
            orders[i].userAddress,
            _msgSender(),
            matched,
            orders[i].price,
            now
        );

        if(side == Side.SELL) {
            traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].sub(matched);
            traderBalances[orders[i].userAddress][_ticker] = traderBalances[orders[i].userAddress][_ticker].add(matched);
            ethBalance[_msgSender()]  = ethBalance[_msgSender()].add(matched.mul(orders[i].price).div(1e18));

            PendingTransactions[] storage pending = pendingETH[_ticker][orders[i].userAddress];
            uint userOrders = pending.length;
            uint b = 0;
            uint id = orders[i].id;
            while(b < userOrders){
                if(pending[b].id == id && orders[i].filled == orders[i].amount){
                    for(uint o = b; o < userOrders.sub(1); o = o.add(1)){
                        pending[o] = pending[o.add(1)];
                        b = userOrders;
                    }
                    pending.pop();
                }
                b = b.add(1);
            }
        }

        if(side == Side.BUY) {
            require(ethBalance[_msgSender()] >= matched.mul(orders[i].price).div(1e18), 'eth balance too low');
            traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].add(matched);
            ethBalance[orders[i].userAddress]  = ethBalance[orders[i].userAddress].add(matched.mul(orders[i].price).div(1e18));
            ethBalance[_msgSender()]  = ethBalance[_msgSender()].sub(matched.mul(orders[i].price).div(1e18));

            PendingTransactions[] storage pending = pendingToken[_ticker][orders[i].userAddress];
            uint userOrders = pending.length;
            uint b = 0;
            while(b < userOrders){
                if(pending[b].id == orders[i].id && orders[i].filled == orders[i].amount){
                    for(uint o = b; o < userOrders.sub(1); o = o.add(1)){
                        pending[o] = pending[o.add(1)];
                        b = userOrders;
                    }
                    pending.pop();
                }
                b = b.add(1);
            }
        }
        left = remaining;
        return left;
    }

    function cancelOrder(string memory ticker, Side _side) external stakeNFTExist(ticker) {
        bytes32 _ticker = stringToBytes32(ticker);

        Order[] storage orders = orderBook[_ticker][uint(_side)];

        if(_side == Side.BUY) {
            PendingTransactions[] storage pending = pendingETH[_ticker][_msgSender()];
            uint amount = _cancelOrder(pending, orders, _side);
            ethBalance[_msgSender()]  = ethBalance[_msgSender()].add(amount);
        }
        else{
            PendingTransactions[] storage pending = pendingToken[_ticker][_msgSender()];
            uint amount = _cancelOrder(pending, orders, _side);
            traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].add(amount);
        }
    }

    function _cancelOrder(PendingTransactions[] storage pending, Order[] storage orders, Side _side) internal returns(uint left){
        int userOrders = int(pending.length - 1);
        require(userOrders >= 0, 'users has no pending order');
        uint userOrder = uint(userOrders);
        uint orderId = pending[userOrder].id;
        uint orderLength = orders.length;

        uint i = 0;
        uint amount;

        while(i < orders.length){

           if(orders[i].id == orderId){

                if(_side == Side.BUY){
                    amount = pending[userOrder].pendingAmount.sub(orders[i].filled.mul(orders[i].price).div(1e18));
                }

                else {
                    amount = pending[userOrder].pendingAmount.sub(orders[i].filled);
                }

                for(uint c = i; c < orders.length.sub(1); c = c.add(1)){
                    orders[c] = orders[c.add(1)];
                }

                orders.pop();
                pending.pop();
                i = orderLength;
           }

           i = i.add(1);
        }
        left = amount;
        return left;
    }

    modifier stakeNFTExist(string memory ticker) {
        bytes32 _ticker = stringToBytes32(ticker);
        require(tokens[_ticker].stakingAddress != address(0), "staking NFT does not exist");
        _;
    }

    //HELPER FUNCTION
    // CONVERT STRING TO BYTES32

    function stringToBytes32(string memory _source)
    public pure
    returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(_source);
        string memory tempSource = _source;

        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(tempSource, 32))
        }
    }

}
