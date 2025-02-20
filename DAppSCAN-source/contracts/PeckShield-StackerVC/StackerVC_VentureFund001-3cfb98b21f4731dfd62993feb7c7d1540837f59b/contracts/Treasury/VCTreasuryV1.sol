pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;


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

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

interface IMinter {
	function minters(address) external returns (bool);
	function mint(address, uint256) external;
}

/*
This is a Stacker.vc VC Treasury version 1 contract. It initiates a 3 year VC Fund that makes investments in ETH, and tries to sell previously acquired ERC20's at a profit.
This fund also has veto functionality by SVC001 token holders. A token holder can stop all buys and sells OR even close the fund early.
*/
// for memory return types
// call ERC20 safely
contract VCTreasuryV1 is ERC20, ReentrancyGuard {
	using SafeERC20 for IERC20;
	using Address for address;
    using SafeMath for uint256;

	address public councilMultisig;
	address public deployer;
	address payable public treasury;

	enum FundStates {setup, active, paused, closed}
	FundStates public currentState;

	uint256 public fundStartTime;
	uint256 public fundCloseTime;

	uint256 public totalStakedToPause;
	uint256 public totalStakedToKill;
	mapping(address => uint256) stakedToPause;
	mapping(address => uint256) stakedToKill;
	bool public killed;
	address public constant BET_TOKEN = 0xfdd4E938Bb067280a52AC4e02AaF1502Cc882bA6;
	address public constant STACK_TOKEN = 0x514910771AF9Ca656af840dff83E8264EcF986CA; // TODO: need to deploy this contract, incorrect address, this is LINK token

	// we have some looping in the contract. have a limit for loops so that they succeed.
	// loops & especially unbounded loops are bad solidity design.
	uint256 public constant LOOP_LIMIT = 50; 

	// fixed once set
	uint256 public initETH;
	uint256 public constant investmentCap = 200; // percentage of initETH that can be invested of "max"
	uint256 public maxInvestment;

	uint256 public constant pauseQuorum = 300; // must be over this percent for a pause to take effect (of "max")
	uint256 public constant killQuorum = 500; // must be over this percent for a kill to take effect (of "max")
	uint256 public constant max = 1000;

	// used to determine total amount invested in last 30 days
	uint256 public currentInvestmentUtilization;
	uint256 public lastInvestTime;

	uint256 public constant ONE_YEAR = 365 days; // 365 days * 24 hours * 60 minutes * 60 seconds = 31,536,000
	uint256 public constant THIRTY_DAYS = 30 days; // 30 days * 24 hours * 60 minutes * 60 seconds = 2,592,000
	uint256 public constant THREE_DAYS = 3 days; // 3 days * 24 hours * 60 minutes * 60 seconds = 259,200
	uint256 public constant ONE_WEEK = 7 days; // 7 days * 24 hours * 60 minutes * 60 seconds = 604,800

	struct BuyProposal {
		uint256 buyId;
		address tokenAccept;
		uint256 amountInMin;
		uint256 ethOut;
		address taker;
		uint256 maxTime;
	}

	BuyProposal public currentBuyProposal; // only one buy proposal at a time, unlike sells
	uint256 public nextBuyId;
	mapping(address => bool) public boughtTokens; // a list of all tokens purchased (executed successfully)

	struct SellProposal {
		address tokenSell;
		uint256 ethInMin;
		uint256 amountOut;
		address taker;
		uint256 vetoTime;
		uint256 maxTime;
	}

	mapping(uint256 => SellProposal) public currentSellProposals; // can have multiple sells at a time
	uint256 public nextSellId;

	// fees, assessed after one year. fraction of `max`
	uint256 public constant stackFee = 25;
	uint256 public constant councilFee = 25;

	event InvestmentProposed(uint256 buyId, address tokenAccept, uint256 amountInMin, uint256 amountOut, address taker, uint256 maxTime);
	event InvestmentRevoked(uint256 buyId, uint256 time);
	event InvestmentExecuted(uint256 buyId, address tokenAccept, uint256 amountIn, uint256 amountOut, address taker, uint256 time);
	event DevestmentProposed(uint256 sellId, address tokenSell, uint256 ethInMin, uint256 amountOut, address taker, uint256 vetoTime, uint256 maxTime);
	event DevestmentRevoked(uint256 sellId, uint256 time);
	event DevestmentExecuted(uint256 sellId, address tokenSell, uint256 ethIn, uint256 amountOut, address taker, uint256 time);

	constructor(address _multisig, address payable _treasury) public ERC20("Stacker.vc Fund001", "SVC001") {
		deployer = msg.sender;
		councilMultisig = _multisig;
		treasury = _treasury;

		currentState = FundStates.setup;
		
		_setupDecimals(18);
	}

	// receive ETH, do nothing
	receive() payable external {
		return;
	}

	// change the multisig account
	function setCouncilMultisig(address _new) external {
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");
		councilMultisig = _new;
	}

	// change deployer account, only used for setup (no need to funnel setup calls thru multisig)
	function setDeployer(address _new) external {
		require(msg.sender == councilMultisig || msg.sender == deployer, "TREASURYV1: !(councilMultisig || deployer)");
		deployer = _new;
	}

	function setTreasury(address payable _new) external {
		require(msg.sender == treasury, "TREASURYV1: !treasury");
		treasury = _new;
	}

	// mark a token as bought and able to be distributed when the fund closes. this would be for some sort of airdrop or "freely" acquired token sent to the contract
	function setBoughtToken(address _new) external {
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");
		boughtTokens[_new] = true;
	}

	// basic mapping get functions

	function getBoughtToken(address _token) external view returns (bool){
		return boughtTokens[_token];
	}

	function getStakedToPause(address _user) external view returns (uint256){
		return stakedToPause[_user];
	}

	function getStakedToKill(address _user) external view returns (uint256){
		return stakedToKill[_user];
	}

	function getSellProposal(uint256 _sellId) external view returns (SellProposal memory){
		return currentSellProposals[_sellId];
	}

	// start main logic
	
	// mint SVC001 tokens to users, fund cannot be started. SVC001 distribution must be audited and checked before the funds is started. Cannot mint tokens after fund starts.
	function issueTokens(address[] calldata _user, uint256[] calldata _amount) external {
		require(currentState == FundStates.setup, "TREASURYV1: !FundStates.setup");
		require(msg.sender == deployer, "TREASURYV1: !deployer");
		require(_user.length == _amount.length, "TREASURYV1: length mismatch");
		require(_user.length <= LOOP_LIMIT, "TREASURYV1: length > LOOP_LIMIT"); // don't allow unbounded loops, bad design, gas issues

		for (uint256 i = 0; i < _user.length; i++){
			_mint(_user[i], _amount[i]);
		}
	}

	// seed the fund with ETH and start it up. 3 years until the fund is dissolved
	function startFund() payable external {
		require(currentState == FundStates.setup, "TREASURYV1: !FundStates.setup");
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");
		require(totalSupply() > 0, "TREASURYV1: invalid setup"); // means fund tokens were not issued

		fundStartTime = block.timestamp;
		fundCloseTime = block.timestamp.add(ONE_YEAR);

		initETH = msg.value;
		//SWC-101-Integer Overflow and Underflow: L181
		maxInvestment = msg.value.div(max).mul(investmentCap);

		_changeFundState(FundStates.active); // set fund active!
	}

	// make an offer to invest in a project by sending ETH to the project in exchange for tokens. one investment at a time. get ERC20, give ETH
	function investPropose(address _tokenAccept, uint256 _amountInMin, uint256 _ethOut, address _taker) external {
		_checkCloseTime();
		require(currentState == FundStates.active, "TREASURYV1: !FundStates.active");
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");

		// checks that the investment utilization (30 day rolling average) isn't exceeded. will revert(). otherwise will update to new rolling average
		_updateInvestmentUtilization(_ethOut);

		BuyProposal memory _buy;
		_buy.buyId = nextBuyId;
		_buy.tokenAccept = _tokenAccept;
		_buy.amountInMin = _amountInMin;
		_buy.ethOut = _ethOut;
		_buy.taker = _taker;
		_buy.maxTime = block.timestamp.add(THREE_DAYS); // three days maximum to accept a buy

		currentBuyProposal = _buy;
		nextBuyId = nextBuyId.add(1);
		
		InvestmentProposed(_buy.buyId, _tokenAccept, _amountInMin, _ethOut, _taker, _buy.maxTime);
	}

	// revoke an uncompleted investment offer
	function investRevoke(uint256 _buyId) external {
		_checkCloseTime();
		require(currentState == FundStates.active || currentState == FundStates.paused, "TREASURYV1: !(FundStates.active || FundStates.paused)");
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");

		BuyProposal memory _buy = currentBuyProposal;
		require(_buyId == _buy.buyId, "TREASURYV1: buyId not active");

		BuyProposal memory _reset;
		currentBuyProposal = _reset;

		InvestmentRevoked(_buy.buyId, block.timestamp);
	}

	// execute an investment offer by sending tokens to the contract, in exchange for ETH
	function investExecute(uint256 _buyId, uint256 _amount) nonReentrant external  {
		_checkCloseTime();
		require(currentState == FundStates.active, "TREASURYV1: !FundStates.active");

		BuyProposal memory _buy = currentBuyProposal;
		require(_buyId == _buy.buyId, "TREASURYV1: buyId not active");
		require(_buy.tokenAccept != address(0), "TREASURYV1: !tokenAccept");
		require(_amount >= _buy.amountInMin, "TREASURYV1: _amount < amountInMin");
		require(_buy.taker == msg.sender || _buy.taker == address(0), "TREASURYV1: !taker"); // if taker is set to 0x0, anyone can accept this investment
		require(block.timestamp <= _buy.maxTime, "TREASURYV1: time > maxTime");

		BuyProposal memory _reset;
		currentBuyProposal = _reset; // set investment proposal to a blank proposal, re-entrancy guard

		uint256 _before = IERC20(_buy.tokenAccept).balanceOf(address(this));
		IERC20(_buy.tokenAccept).safeTransferFrom(msg.sender, address(this), _amount);
		uint256 _after = IERC20(_buy.tokenAccept).balanceOf(address(this));
		require(_after.sub(_before) >= _buy.amountInMin, "TREASURYV1: received < amountInMin"); // check again to verify received amount was correct

		boughtTokens[_buy.tokenAccept] = true;

		InvestmentExecuted(_buy.buyId, _buy.tokenAccept, _amount, _buy.ethOut, msg.sender, block.timestamp);

		msg.sender.transfer(_buy.ethOut); // send the ETH out 
	}

	// allow advisory multisig to propose a new sell. get ETH, give ERC20 prior investment
	function devestPropose(address _tokenSell, uint256 _ethInMin, uint256 _amountOut, address _taker) external {
		_checkCloseTime();
		require(currentState == FundStates.active, "TREASURYV1: !FundStates.active");
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");

		SellProposal memory _sell;
		_sell.tokenSell = _tokenSell;
		_sell.ethInMin = _ethInMin;
		_sell.amountOut = _amountOut;
		_sell.taker = _taker;
		_sell.vetoTime = block.timestamp.add(THREE_DAYS);
		_sell.maxTime = block.timestamp.add(THREE_DAYS).add(THREE_DAYS);

		currentSellProposals[nextSellId] = _sell;
		
		DevestmentProposed(nextSellId, _tokenSell, _ethInMin, _amountOut, _taker, _sell.vetoTime, _sell.maxTime);

		nextSellId = nextSellId.add(1);
	}

	// revoke an uncompleted sell offer
	function devestRevoke(uint256 _sellId) external {
		_checkCloseTime();
		require(currentState == FundStates.active || currentState == FundStates.paused, "TREASURYV1: !(FundStates.active || FundStates.paused)");
		require(msg.sender == councilMultisig, "TREASURYV1: !councilMultisig");
		require(_sellId < nextSellId, "TREASURYV1: !sellId");

		SellProposal memory _reset;
		currentSellProposals[_sellId] = _reset;

		DevestmentRevoked(_sellId, block.timestamp);
	}

	// execute a divestment of funds
	function devestExecute(uint256 _sellId) nonReentrant external payable {
		_checkCloseTime();
		require(currentState == FundStates.active, "TREASURYV1: !FundStates.active");

		SellProposal memory _sell = currentSellProposals[_sellId];
		require(_sell.tokenSell != address(0), "TREASURYV1: !tokenSell");
		require(msg.value >= _sell.ethInMin, "TREASURYV1: <ethInMin");
		require(_sell.taker == msg.sender || _sell.taker == address(0), "TREASURYV1: !taker"); // if taker is set to 0x0, anyone can accept this devestment
		require(block.timestamp > _sell.vetoTime, "TREASURYV1: time < vetoTime");
		require(block.timestamp <= _sell.maxTime, "TREASURYV1: time > maxTime");

		SellProposal memory _reset;
		currentSellProposals[_sellId] = _reset; // set devestment proposal to a blank proposal, re-entrancy guard

		DevestmentExecuted(_sellId, _sell.tokenSell, msg.value, _sell.amountOut, msg.sender, block.timestamp);
		IERC20(_sell.tokenSell).safeTransfer(msg.sender, _sell.amountOut); // we already received msg.value >= _sell.ethInMin, by above assertions

		// if we completely sell out of an asset, mark this as not owned anymore
		if (IERC20(_sell.tokenSell).balanceOf(address(this)) == 0){
			boughtTokens[_sell.tokenSell] = false;
		}
	}

	// stake SVC001 tokens to the fund. this signals unhappyness with the fund management
	// Pause: if 30% of SVC tokens are staked here, then all sells & buys will be disabled. They will be reenabled when tokens staked drops under 30%
	// tokens staked to stakeToKill() count as 
	function stakeToPause(uint256 _amount) external {
		_checkCloseTime();
		require(currentState == FundStates.active || currentState == FundStates.paused, "TREASURYV1: !(FundStates.active || FundStates.paused)");
		require(balanceOf(msg.sender) >= _amount, "TREASURYV1: insufficient balance to stakeToPause");

		_transfer(msg.sender, address(this), _amount);

		stakedToPause[msg.sender] = stakedToPause[msg.sender].add(_amount);
		totalStakedToPause = totalStakedToPause.add(_amount);

		_updateFundStateAfterStake();
	}

	// Kill: if 50% of SVC tokens are staked here, then the fund will close, and assets will be retreived
	// if 30% of tokens are staked here, then the fund will be paused. See above stakeToPause()
	function stakeToKill(uint256 _amount) external {
		_checkCloseTime();
		require(currentState == FundStates.active || currentState == FundStates.paused, "TREASURYV1: !(FundStates.active || FundStates.paused)");
		require(balanceOf(msg.sender) >= _amount, "TREASURYV1: insufficient balance to stakeToKill");

		_transfer(msg.sender, address(this), _amount);

		stakedToKill[msg.sender] = stakedToKill[msg.sender].add(_amount);
		totalStakedToKill = totalStakedToKill.add(_amount);

		_updateFundStateAfterStake();
	}

	function unstakeToPause(uint256 _amount) external {
		_checkCloseTime();
		require(currentState != FundStates.setup, "TREASURYV1: FundStates.setup");
		require(stakedToPause[msg.sender] >= _amount, "TREASURYV1: insufficent balance to unstakeToPause");

		_transfer(address(this), msg.sender, _amount);

		stakedToPause[msg.sender] = stakedToPause[msg.sender].sub(_amount);
		totalStakedToPause = totalStakedToPause.sub(_amount);

		_updateFundStateAfterStake();
	}

	function unstakeToKill(uint256 _amount) external {
		_checkCloseTime();
		require(currentState != FundStates.setup, "TREASURYV1: FundStates.setup");
		require(stakedToKill[msg.sender] >= _amount, "TREASURYV1: insufficent balance to unstakeToKill");

		_transfer(address(this), msg.sender, _amount);

		stakedToKill[msg.sender] = stakedToKill[msg.sender].sub(_amount);
		totalStakedToKill = totalStakedToKill.sub(_amount);

		_updateFundStateAfterStake();
	}

	function _updateFundStateAfterStake() internal {
		// closes are final, cannot unclose
		if (currentState == FundStates.closed){
			return;
		}
		// check if the fund will irreversibly close
		if (totalStakedToKill > killQuorumRequirement()){
			killed = true;
			_changeFundState(FundStates.closed);
			return;
		}
		// check if the fund will pause/unpause
		uint256 _pausedStake = totalStakedToPause.add(totalStakedToKill);
		if (_pausedStake > pauseQuorumRequirement() && currentState == FundStates.active){
			_changeFundState(FundStates.paused);
			return;
		}
		if (_pausedStake <= pauseQuorumRequirement() && currentState == FundStates.paused){
			_changeFundState(FundStates.active);
			return;
		}
	}

	function killQuorumRequirement() public view returns (uint256) {
		return totalSupply().div(max).mul(killQuorum);
	}

	function pauseQuorumRequirement() public view returns (uint256) {
		return totalSupply().div(max).mul(pauseQuorum);
	}

	function checkCloseTime() external {
		_checkCloseTime();
	}

	// maintenance function: check if the fund is out of time, if so, close it.
	function _checkCloseTime() internal {
		if (block.timestamp >= fundCloseTime && currentState != FundStates.setup){
			_changeFundState(FundStates.closed);
		}
	}

	function _changeFundState(FundStates _state) internal {
		// cannot be changed AWAY FROM closed or TO setup
		if (currentState == FundStates.closed || _state == FundStates.setup){
			return;
		}
		currentState = _state;

		// if closing the fund AND the fund was not `killed`, assess the fee.
		if (_state == FundStates.closed && !killed){
			_assessFee();
		}
	}

	// when closing the fund, assess the fee for STACK holders/council. then close fund.
	function _assessFee() internal {
		uint256 _stackAmount = totalSupply().div(max).mul(stackFee);
		uint256 _councilAmount = totalSupply().div(max).mul(councilFee);

		_mint(treasury, _stackAmount);
		_mint(councilMultisig, _councilAmount);
	}

	// fund is over, claim your proportional proceeds with SVC001 tokens. if fund is not closed but time's up, this will also close the fund
	function claim(address[] calldata _tokens) nonReentrant external {
		_checkCloseTime();
		require(currentState == FundStates.closed, "TREASURYV1: !FundStates.closed");
		require(_tokens.length <= LOOP_LIMIT, "TREASURYV1: length > LOOP_LIMIT"); // don't allow unbounded loops, bad design, gas issues

		// we should be able to send about 50 ERC20 tokens at a maximum in a loop
		// if we have more tokens than this in the fund, we can find a solution...
			// one would be wrapping all "valueless" tokens in another token (via sell / buy flow)
			// users can claim this bundled token, and if a "valueless" token ever has value, then they can do a similar cash out to the valueless token
			// there is a very low chance that there's >50 tokens that users want to claim. Probably more like 5-10 (given a normal VC story of many fails, some big successes)
		// we could alternatively make a different claim flow that doesn't use loops, but the gas and hassle of making 50 txs to claim 50 tokens is way worse

		uint256 _balance = balanceOf(msg.sender);
		uint256 _proportionE18 = _balance.mul(1e18).div(totalSupply());

		_burn(msg.sender, _balance);

		// automatically send a user their ETH balance, everyone wants ETH, the goal of the fund is to make ETH.
		uint256 _proportionToken = address(this).balance.mul(_proportionE18).div(1e18);
		msg.sender.transfer(_proportionToken);

		for (uint256 i = 0; i < _tokens.length; i++){
			require(_tokens[i] != address(this), "can't claim address(this)");
			require(boughtTokens[_tokens[i]], "!boughtToken");
			// don't allow BET/STACK to be claimed if the fund was "killed"
			if (_tokens[i] == BET_TOKEN || _tokens[i] == STACK_TOKEN){
				require(!killed, "BET/STACK can only be claimed if fund wasn't killed");
			}

			_proportionToken = IERC20(_tokens[i]).balanceOf(address(this)).mul(_proportionE18).div(1e18);
			IERC20(_tokens[i]).safeTransfer(msg.sender, _proportionToken);
		}
	}

	// updates currentInvestmentUtilization based on a 30 day rolling average. If there are 30 days since the last investment, the utilization is zero. otherwise, deprec. it at a constant rate.
	function _updateInvestmentUtilization(uint256 _newInvestment) internal {
		uint256 proposedUtilization = getUtilization(_newInvestment);
		require(proposedUtilization <= maxInvestment, "TREASURYV1: utilization > maxInvestment");

		currentInvestmentUtilization = proposedUtilization;
		lastInvestTime = block.timestamp;
	}

	// get the total utilization from a possible _newInvestment
	function getUtilization(uint256 _newInvestment) public view returns (uint256){
		uint256 _lastInvestTimeDiff = block.timestamp.sub(lastInvestTime);
		if (_lastInvestTimeDiff >= THIRTY_DAYS){
			return _newInvestment;
		}
		else {
			// current * ((thirty_days - time elapsed) / thirty_days)
			uint256 _depreciateUtilization = currentInvestmentUtilization.div(THIRTY_DAYS).mul(THIRTY_DAYS.sub(_lastInvestTimeDiff));
			return _newInvestment.add(_depreciateUtilization);
		}
	}

	// get the maximum amount possible to invest at this time
	function availableToInvest() external view returns (uint256){
		return maxInvestment.sub(getUtilization(0));
	}

	// only called in emergencies. if the contract is bricked or for some reason cannot function, we escape all assets and will return to their owners manually.
	// prioritize fund safety & retreivability of assets
	// the checks are: only callable by councilMultisig, and the fund must be closed, and the fund must not be `killed` by SVC001 holders
	function emergencyEscape(address _tokenContract, uint256 _amount) nonReentrant external {
		require(msg.sender == councilMultisig && !killed && currentState == FundStates.closed, "TREASURYV1: escape check failed");

		if (_tokenContract != address(0)){
			IERC20(_tokenContract).safeTransfer(treasury, _amount);
		}
		else { // if _tokenContract is 0x0, then escape ETH
			treasury.transfer(_amount);
		}
	}
}
