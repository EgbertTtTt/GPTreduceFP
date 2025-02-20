pragma solidity 0.6.12;


// SPDX-License-Identifier: MIT
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

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
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

interface IMdexRouter {
    function factory() external pure returns (address);

    function WHT() external pure returns (address);

    function swapMining() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);

    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IMdexPair {
    // event Approval(address indexed owner, address indexed spender, uint value);
    // event Transfer(address indexed from, address indexed to, uint value);

    // function name() external pure returns (string memory);

    // function symbol() external pure returns (string memory);

    // function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    // function allowance(address owner, address spender) external view returns (uint);

    // function approve(address spender, uint value) external returns (bool);

    // function transfer(address to, uint value) external returns (bool);

    // function transferFrom(address from, address to, uint value) external returns (bool);

    // function DOMAIN_SEPARATOR() external view returns (bytes32);

    // function PERMIT_TYPEHASH() external pure returns (bytes32);

    // function nonces(address owner) external view returns (uint);

    // function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    // event Mint(address indexed sender, uint amount0, uint amount1);
    // event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    // event Swap(
    //     address indexed sender,
    //     uint amount0In,
    //     uint amount1In,
    //     uint amount0Out,
    //     uint amount1Out,
    //     address indexed to
    // );
    // event Sync(uint112 reserve0, uint112 reserve1);

    // function MINIMUM_LIQUIDITY() external pure returns (uint);

    // function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    // function price0CumulativeLast() external view returns (uint);

    // function price1CumulativeLast() external view returns (uint);

    // function kLast() external view returns (uint);

    // function mint(address to) external returns (uint liquidity);

    // function burn(address to) external returns (uint amount0, uint amount1);

    // function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    // function skim(address to) external;

    // function sync() external;

    // function price(address token, uint256 baseDecimal) external view returns (uint256);

    // function initialize(address, address) external;
}

interface IMdexFactory {
    // event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    // function feeTo() external view returns (address);

    // function feeToSetter() external view returns (address);

    // function feeToRate() external view returns (uint256);

    // function initCodeHash() external view returns (bytes32);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    // function allPairs(uint) external view returns (address pair);

    // function allPairsLength() external view returns (uint);

    // function createPair(address tokenA, address tokenB) external returns (address pair);

    // function setFeeTo(address) external;

    // function setFeeToSetter(address) external;

    // function setFeeToRate(uint256) external;

    // function setInitCodeHash(bytes32) external;

    // function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);

    // function pairFor(address tokenA, address tokenB) external view returns (address pair);

    function getReserves(address tokenA, address tokenB) external view returns (uint256 reserveA, uint256 reserveB);

    // function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);

    // function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);

    // function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
}

interface IStrategyLink {

    event StrategyDeposit(address indexed strategy, uint256 indexed pid, address indexed user, uint256 amount, uint256 borrowAmount);
    event StrategyBorrow(address indexed strategy, uint256 indexed pid, address indexed user, uint256 borrowAmount);
    event StrategyWithdraw(address indexed strategy, uint256 indexed pid, address indexed user, uint256 amount);
    event StrategyLiquidation(address indexed strategy, uint256 indexed pid, address indexed user, uint256 amount);
    
    function bank() external view returns(address);
    function getSource() external view returns (string memory);
    function userInfo(uint256 _pid, address _account) external view returns (uint256,uint256,address,uint256);
    function getPoolInfo(uint256 _pid) external view  returns(address[] memory collateralToken, address baseToken, address lpToken, uint256 poolId, uint256 totalLPAmount, uint256 totalLPRefund);
    function getBorrowInfo(uint256 _pid, address _account) external view returns (address borrowFrom, uint256 bid);
    function getBorrowAmount(uint256 _pid, address _account) external view returns (uint256 value);
    function getDepositAmount(uint256 _pid, address _account) external view returns (uint256 amount);

    function getPoolCollateralToken(uint256 _pid) external view returns (address[] memory collateralToken);
    function getPoollpToken(uint256 _pid) external view returns (address lpToken);
    function getBaseToken(uint256 _pid) external view returns (address baseToken);

    function poolLength() external view returns (uint256);

    function pendingRewards(uint256 _pid, address _account) external view returns (uint256 value);
    function pendingLPAmount(uint256 _pid, address _account) external view returns (uint256 value);

    function massUpdatePools() external;
    function updatePool(uint256 _pid) external;

    function deposit(uint256 _pid, address _account, address _debtFrom, uint256 _bAmount, uint256 _desirePrice, uint256 _slippage) external returns (uint256 lpAmount);
    function depositLPToken(uint256 _pid, address _account, address _debtFrom, uint256 _bAmount, uint256 _desirePrice, uint256 _slippage) external returns (uint256 lpAmount);
    
    function withdraw(uint256 _pid, address _account, uint256 _rate) external;
    function withdrawLPToken(uint256 _pid, address _account, uint256 _rate) external;

    function emergencyWithdraw(uint256 _pid, address _account) external;

    function liquidation(uint256 _pid, address _account, address _hunter, uint256 _maxDebt) external;
    function repayBorrow(uint256 _pid, address _account, uint256 _rate, bool _fast) external;
}

interface IStrategyConfig {

    // factor 
    function getBorrowFactor(address _strategy, uint256 _poolid) external view returns (uint256);
    function setBorrowFactor(address _strategy, uint256 _poolid, uint256 _borrowFactor) external;

    function getLiquidationFactor(address _strategy, uint256 _poolid) external view returns (uint256);
    function setLiquidationFactor(address _strategy, uint256 _poolid, uint256 _liquidationFactor) external;
    
    function getFarmPoolFactor(address _strategy, uint256 _poolid) external view returns (uint256 value);
    function setFarmPoolFactor(address _strategy, uint256 _poolid, uint256 _farmPoolFactor) external;

    // fee manager
    function getDepositFee(address _strategy, uint256 _poolid) external view returns (address, uint256);
    function setDepositFee(address _strategy, uint256 _poolid, uint256 _depositFee) external;

    function getWithdrawFee(address _strategy, uint256 _poolid) external view returns (address, uint256);
    function setWithdrawFee(address _strategy, uint256 _poolid, uint256 _withdrawFee) external;

    function getRefundFee(address _strategy, uint256 _poolid) external view returns (address, uint256);
    function setRefundFee(address _strategy, uint256 _poolid, uint256 _refundFee) external;

    function getClaimFee(address _strategy, uint256 _poolid) external view returns (address, uint256);
    function setClaimFee(address _strategy, uint256 _poolid, uint256 _claimFee) external;

    function getLiquidationFee(address _strategy, uint256 _poolid) external view returns (address, uint256);
    function setLiquidationFee(address _strategy, uint256 _poolid, uint256 _liquidationFee) external;
}

interface ISafeBox {

    function bank() external view returns(address);

    function token() external view returns(address);

    function getSource() external view returns (string memory);

    function supplyRatePerBlock() external view returns (uint256);
    function borrowRatePerBlock() external view returns (uint256);

    function getBorrowInfo(uint256 _bid) external view 
            returns (address owner, uint256 amount, address strategy, uint256 pid);
    function getBorrowId(address _strategy, uint256 _pid, address _account) external view returns (uint256 borrowId);
    function getBorrowId(address _strategy, uint256 _pid, address _account, bool _add) external returns (uint256 borrowId);
    function getDepositTotal() external view returns (uint256);
    function getBorrowTotal() external view returns (uint256);
    function getBorrowAmount(address _account) external view returns (uint256 value); 
    function getBaseTokenPerLPToken() external view returns (uint256);

    function deposit(uint256 _value) external;
    function withdraw(uint256 _value) external;
    
    function emergencyWithdraw() external;
    function emergencyRepay(uint256 _bid, uint256 _value) external;

    function borrowInfoLength() external view returns (uint256);

    function borrow(uint256 _bid, uint256 _value, address _to) external;
    function repay(uint256 _bid, uint256 _value) external;
    function claim(uint256 _tTokenAmount) external;

    function update() external;
    function mintDonate(uint256 _value) external;

    function pendingSupplyAmount(address _account) external view returns (uint256 value);   
    function pendingBorrowAmount(uint256 _bid) external view returns (uint256 value);
    function pendingBorrowRewards(uint256 _bid) external view returns (uint256 value);
}

interface ITenBankHall {
    function makeBorrowFrom(uint256 _pid, address _account, address _debtFrom, uint256 _value) external returns (uint256 bid);
}

library TenMath {
  using SafeMath for uint256;

  function min(uint256 v1, uint256 v2) public pure returns (uint256 vr) {
    vr = v1 > v2 ? v2 : v1; 
  }
    
  function safeSub(uint256 v1, uint256 v2) internal pure returns (uint256 vr) {
    vr = v1 > v2 ? v1.sub(v2) : 0; 
  }

  // implementation from https://github.com/Uniswap/uniswap-lib/commit/99f3f28770640ba1bb1ff460ac7c5292fb8291a0
  // original implementation: https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
  function sqrt(uint256 x) internal pure returns (uint256) {
    if (x == 0) return 0;
    uint256 xx = x;
    uint256 r = 1;

    if (xx >= 0x100000000000000000000000000000000) {
      xx >>= 128;
      r <<= 64;
    }

    if (xx >= 0x10000000000000000) {
      xx >>= 64;
      r <<= 32;
    }
    if (xx >= 0x100000000) {
      xx >>= 32;
      r <<= 16;
    }
    if (xx >= 0x10000) {
      xx >>= 16;
      r <<= 8;
    }
    if (xx >= 0x100) {
      xx >>= 8;
      r <<= 4;
    }
    if (xx >= 0x10) {
      xx >>= 4;
      r <<= 2;
    }
    if (xx >= 0x8) {
      r <<= 1;
    }

    r = (r + x / r) >> 1;
    r = (r + x / r) >> 1;
    r = (r + x / r) >> 1;
    r = (r + x / r) >> 1;
    r = (r + x / r) >> 1;
    r = (r + x / r) >> 1;
    r = (r + x / r) >> 1; // Seven iterations should be enough
    uint256 r1 = x / r;
    return (r < r1 ? r : r1);
  }
}

contract StrategyUtils is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IStrategyConfig public sconfig;
    address public strategy;

    IMdexFactory constant factory = IMdexFactory(0xb0b670fc1F7724119963018DB0BfA86aDb22d941);
    IMdexRouter public constant router = IMdexRouter(0xED7d5F38C79115ca12fe6C0041abb22F0A06C300);

    constructor(address _sconfig) public {
        sconfig = IStrategyConfig(_sconfig);
        strategy = msg.sender;
    }

    function setSConfig(address _sconfig) external onlyOwner {
        sconfig = IStrategyConfig(_sconfig);
    }

    // fee
    function makeDepositFee(uint256 _pid) external onlyOwner {
        if(address(sconfig) == address(0)) {
            return;
        }
        address[] memory collateralToken = IStrategyLink(strategy).getPoolCollateralToken(_pid);
        (address gather, uint256 feerate) = sconfig.getDepositFee(strategy, _pid);
        makeFeeTransfer(collateralToken[0], feerate, 1e9, gather);
        makeFeeTransfer(collateralToken[1], feerate, 1e9, gather);
    }

    function makeFeeTransfer(address _token, uint256 _feerate, uint256 _balancerate, address _gather) internal { 
        if(_token == address(0) || _feerate == 0 || _gather == address(0)) {
            return ;
        }
        uint256 feeValue = IERC20(_token).balanceOf(strategy).mul(_balancerate).div(1e9).mul(_feerate).div(1e9);
        if(feeValue > 0) {
            IERC20(_token).safeTransferFrom(strategy, _gather, feeValue);
        }
    }

    function makeFeeTransferByValue(address _token, uint256 _feeValue, address _gather) internal { 
        if(_token == address(0) || _feeValue == 0 || _gather == address(0)) {
            return ;
        }
        if(_feeValue > 0) {
            IERC20(_token).safeTransferFrom(strategy, _gather, _feeValue);
        }
    }

    function makeWithdrawRewardFee(uint256 _pid, uint256 _borrowRate, uint256 _rewardsRate) external onlyOwner {
        if(address(sconfig) == address(0)) {
            return;
        }
        address[] memory collateralToken = IStrategyLink(strategy).getPoolCollateralToken(_pid);

        // sconfig.
        (address gather, uint256 feerate) = sconfig.getWithdrawFee(strategy, _pid);
        uint256 rewardsByBorrowRate = _rewardsRate.mul(_borrowRate).div(1e9);
        if(rewardsByBorrowRate > 0) {
            makeFeeTransfer(collateralToken[0], feerate, rewardsByBorrowRate, gather);
            makeFeeTransfer(collateralToken[1], feerate, rewardsByBorrowRate, gather);
        }
    }

    function makeRefundFee(uint256 _pid, uint256 _newRewardBase) external onlyOwner {
        if(address(sconfig) == address(0)) {
            return;
        }
        address baseToken = IStrategyLink(strategy).getBaseToken(_pid);

        // sconfig.
        (address gather, uint256 feerate) = sconfig.getRefundFee(strategy, _pid);
        uint256 feeValue = _newRewardBase.mul(feerate).div(1e9);
        makeFeeTransferByValue(baseToken, feeValue, gather);
    }

    function makeLiquidationFee(uint256 _pid, address _baseToken, uint256 _borrowAmount) external onlyOwner {
        if(address(sconfig) == address(0)) {
            return ;
        }

        _borrowAmount;
    
        // sconfig.
        (address gather, uint256 feerate) = sconfig.getLiquidationFee(strategy, _pid);
        makeFeeTransfer(_baseToken, feerate, 1e9, gather);
    }
    
    // check limit 
    function checkAddPoolLimit(uint256 _pid, address _baseToken, address _lpTokenInPools) 
            external view returns (bool bok) {

        address[] memory collateralToken = IStrategyLink(strategy).getPoolCollateralToken(_pid);
        address lpToken = factory.getPair(collateralToken[0], collateralToken[1]);

        bok = true;
        if(lpToken == address(0)) {
            bok = false;
        }
        if(lpToken != _lpTokenInPools) {
            bok = false;
        }
        if(collateralToken[1] != _baseToken) {
            bok = false;
        }
    }

    function checkDepositLimit(uint256 _pid, address _account, uint256 _lpAmount) 
            external view returns (bool bok) {
        _account;
        require(address(sconfig) != address(0), 'not config deposit limit');
        uint256 farmLimit = sconfig.getFarmPoolFactor(strategy, _pid);
        if(farmLimit <= 0) {
            return true;
        }
        (,,,,, uint256 totalLPRefund) = IStrategyLink(strategy).getPoolInfo(_pid);
        bok = totalLPRefund.add(_lpAmount) <= farmLimit;
    }

    function checkSlippageLimit(uint256 _pid, uint256 _desirePrice, uint256 _slippage) 
            external view returns (bool bok) {
        if(_slippage <= 0) {
            return true;
        }
        if(_slippage >= 1e9) {
            return false;
        }
        address[] memory collateralToken = IStrategyLink(strategy).getPoolCollateralToken(_pid);
        address pairs = factory.getPair(collateralToken[0], collateralToken[1]);
        (uint256 a, uint256 b,) = IMdexPair(pairs).getReserves();
        bok = (a.mul(1e18).div(b) < _desirePrice.mul(uint256(1e9).add(_slippage)).div(1e9)) &&
                (a.mul(1e18).div(b) > _desirePrice.mul(uint256(1e9).sub(_slippage)).div(1e9));
    }

    function checkBorrowLimit(uint256 _pid, address _account, address _borrowFrom, uint256 _borrowAmount) 
        public view returns (bool bok) {
        
        if(_borrowFrom == address(0) || _borrowAmount <= 0) {
            return true;
        }

        address baseToken = IStrategyLink(strategy).getBaseToken(_pid);
        uint256 holdAmount = checkBorrowGetHoldAmount(strategy, _pid, baseToken);

        uint256 totalAmount = IStrategyLink(strategy).getDepositAmount(_pid, _account);
        uint256 borrowAmount = IStrategyLink(strategy).getBorrowAmount(_pid, _account);
        totalAmount = totalAmount.add(holdAmount);

        uint256 borrowFactor = sconfig.getBorrowFactor(strategy, _pid);
        bok = borrowAmount.add(_borrowAmount) <= totalAmount.mul(borrowFactor).div(1e9);
    }

    function checkBorrowGetHoldAmount(address _strategy, uint256 _pid, address baseToken) 
        internal view returns (uint256 holdAmount) {
        
        address[] memory collateralToken = IStrategyLink(_strategy).getPoolCollateralToken(_pid);
        address token0 = collateralToken[0];
        address token1 = collateralToken[1];
        uint256 amount0 = IERC20(token0).balanceOf(_strategy);
        uint256 amount1 = IERC20(token1).balanceOf(_strategy);
        if(amount0 > 0) {
            holdAmount = holdAmount.add(getAmountIn(token0, amount0, baseToken));
        }
        if(amount1 > 0) {
            holdAmount = holdAmount.add(getAmountIn(token1, amount1, baseToken));
        }
    } 

    function checkLiquidationLimit(uint256 _pid, address _account, uint256 _borrowRate)
            external view returns (bool bok) {
        _account;
        require(address(sconfig) != address(0), 'not config liguidate');
        
        uint256 liquRate = sconfig.getLiquidationFactor(strategy, _pid);
        bok = (_borrowRate > liquRate);
    }

    function makeRepay(uint256 _pid, address _borrowFrom, address _account, uint256 _rate, bool _fast)
            external onlyOwner {
        if(_borrowFrom == address(0)) {
            return ;
        }
        uint256 bid = ISafeBox(_borrowFrom).getBorrowId(msg.sender, _pid, _account);
        if( bid <= 0) {
            return ;
        }

        ISafeBox(_borrowFrom).update();

        address[] memory collateralToken = IStrategyLink(strategy).getPoolCollateralToken(_pid);
        uint256 borrowAmount = IStrategyLink(strategy).getBorrowAmount(_pid, _account);
        uint256 repayAmount = borrowAmount.mul(_rate).div(1e9);
        if(repayAmount <= 0) {
            return ;
        }

        address token0 = collateralToken[0];
        address token1 = collateralToken[1];
        address baseToken = IStrategyLink(strategy).getBaseToken(_pid);
        uint256 baseTokenAmount = IERC20(baseToken).balanceOf(strategy);
        if( baseTokenAmount < repayAmount ) {
            // insufficient, sell off all the currency held to repay the debt
            uint256 amount0 = 0;
            if(_fast) {
                amount0 = getAmountOut(token0, token1, repayAmount.sub(baseTokenAmount));
            } else {
                amount0 = IERC20(token0).balanceOf(strategy);
            }
            if(amount0 > 0) {
                IERC20(token0).safeTransferFrom(address(strategy), address(this), amount0);
                getTokenInTo(address(this), token0, amount0, baseToken);
            }
            uint256 amount1 = IERC20(token1).balanceOf(strategy);
            IERC20(token1).safeTransferFrom(address(strategy), address(this), amount1);
        } else {
            IERC20(baseToken).safeTransferFrom(address(strategy), address(this), repayAmount);
        }
        IERC20(baseToken).safeTransfer(address(_borrowFrom), repayAmount);
        ISafeBox(_borrowFrom).repay(bid, repayAmount);
        uint256 free = IERC20(baseToken).balanceOf(address(this));
        if(free > 0) {
            IERC20(baseToken).safeTransfer(address(strategy), free);
        }
    }

    function getBorrowAmount(uint256 _pid, address _account) external view returns (uint256 value) {
        (address borrowFrom,uint256 bid) = IStrategyLink(strategy).getBorrowInfo(_pid, _account);
        if(borrowFrom != address(0) && bid != 0) {
            value = value.add(ISafeBox(borrowFrom).pendingBorrowAmount(bid));
            value = value.add(ISafeBox(borrowFrom).pendingBorrowRewards(bid));
        } else {
            value = 0;
        }
    }
 
    // helper function
    function transferFromAllToken(address _from, address _to, address _token0, address _token1)
        public onlyOwner {

        transferFromToken(_from, _to, _token0);
        transferFromToken(_from, _to, _token1);
    }

    function transferFromToken(address _from, address _to, address _token) public onlyOwner {
        uint256 amount = IERC20(_token).balanceOf(_from);
        if(amount <= 0) { 
            return ;
        }
        if(_from == address(this)) {
            IERC20(_token).safeTransfer(_to, amount);
        } else {
            IERC20(_token).safeTransferFrom(_from, _to, amount);
        }
    }

    /// @dev Compute optimal deposit amount
    /// @param lpToken amount
    /// @param amtA amount of token A desired to deposit
    /// @param amtB amount of token B desired to deposit
    function optimalDepositAmount(
        address lpToken,
        uint amtA,
        uint amtB
    ) public view returns (uint swapAmt, bool isReversed) {
        uint256 resA;
        uint256 resB;
        (resA, resB, ) = IMdexPair(lpToken).getReserves();
        if (amtA.mul(resB) >= amtB.mul(resA)) {
            swapAmt = _optimalDepositA(amtA, amtB, resA, resB);
            isReversed = false;
        } else {
            swapAmt = _optimalDepositA(amtB, amtA, resB, resA);
            isReversed = true;
        }
    }

    /// @dev Compute optimal deposit amount helper.
    /// @param amtA amount of token A desired to deposit
    /// @param amtB amount of token B desired to deposit
    /// @param resA amount of token A in reserve
    /// @param resB amount of token B in reserve
    /// Formula: https://blog.alphafinance.io/byot/
    function _optimalDepositA(
        uint amtA,
        uint amtB,
        uint resA,
        uint resB
    ) internal pure returns (uint) {
        require(amtA.mul(resB) >= amtB.mul(resA), 'Reversed');
        uint a = 997;
        uint b = uint(1997).mul(resA);
        uint _c = (amtA.mul(resB)).sub(amtB.mul(resA));
        uint c = _c.mul(1000).div(amtB.add(resB)).mul(resA);
        uint d = a.mul(c).mul(4);
        uint e = TenMath.sqrt(b.mul(b).add(d));
        uint numerator = e.sub(b);
        uint denominator = a.mul(2);
        return numerator.div(denominator);
    }

    function getLPToken2TokenAmount(address _lpToken, address _baseToken, uint256 _lpTokenAmount)
            public view returns (uint256 amount) {
        (uint256 a, uint256 b, ) = IMdexPair(_lpToken).getReserves();
        address token0 = IMdexPair(_lpToken).token0();
        address token1 = IMdexPair(_lpToken).token1();
        if(token0 == _baseToken) {
            amount = _lpTokenAmount.mul(a).div(ERC20(_lpToken).totalSupply()).mul(2);
        }else if(token1 == _baseToken) {
            amount = _lpTokenAmount.mul(b).div(ERC20(_lpToken).totalSupply()).mul(2);
        }
        else{
            require(false, 'unsupport baseToken not in pairs');
        }
    }

    function getAmountOut(address _tokenIn, address _tokenOut, uint256 _amountOut)
            public virtual view returns (uint256) {
        if(_tokenIn == _tokenOut) {
            return _amountOut;
        }
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        // SWC-114-Transaction Order Dependence: L345
        uint256[] memory result = router.getAmountsIn(_amountOut, path);
        if(result.length == 0) {
            return 0;
        }
        return result[0];
    }

    function getAmountIn(address _tokenIn, uint256 _amountIn, address _tokenOut)
            public virtual view returns (uint256) {
        if(_tokenIn == _tokenOut) {
            return _amountIn;
        }
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        uint256[] memory result = router.getAmountsOut(_amountIn, path);
        if(result.length == 0) {
            return 0;
        }
        return result[result.length-1];
    }
    
    function getTokenOut(address _tokenIn, address _tokenOut, uint256 _amountOut) 
            public virtual onlyOwner returns (uint256 value) {
        uint256 amountIn = getAmountOut(_tokenIn, _tokenOut, _amountOut);
        IERC20(_tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);
        value = getTokenInTo(msg.sender, _tokenIn, amountIn, _tokenOut);
        transferFromAllToken(address(this), msg.sender, _tokenIn, _tokenOut);
    }
    
    function getTokenIn(address _tokenIn, uint256 _amountIn, address _tokenOut) 
            public virtual onlyOwner returns (uint256 value) {
        IERC20(_tokenIn).safeTransferFrom(msg.sender, address(this), _amountIn);
        value = getTokenInTo(msg.sender, _tokenIn, _amountIn, _tokenOut);
        transferFromAllToken(address(this), msg.sender, _tokenIn, _tokenOut);
    }

    function getTokenInTo(address _toAddress, address _tokenIn, uint256 _amountIn, address _tokenOut) 
            internal virtual returns (uint256 value) {
        if(_tokenIn == _tokenOut) {
            value = _amountIn;
            return value;
        }
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        uint256 amountOutMin = 0;
        IERC20(_tokenIn).approve(address(router), uint256(-1));
        require(IERC20(_tokenIn).balanceOf(address(this)) >= _amountIn, 'getTokenInTo not amount in');
        // SWC-114-Transaction Order Dependence: L395
        uint256[] memory result = router.swapExactTokensForTokens(_amountIn, amountOutMin, path, _toAddress, block.timestamp.add(60));
        if(result.length == 0) {
            value = 0;
        } else {
            value = result[result.length-1];
        }
    }
}
