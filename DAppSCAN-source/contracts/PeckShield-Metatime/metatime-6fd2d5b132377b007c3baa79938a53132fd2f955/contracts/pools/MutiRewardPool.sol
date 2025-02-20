pragma solidity =0.6.12;
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

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

interface IERC20Metadata {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

}

contract PoolVault is Ownable {

    constructor() public {}

    function approve(address token) public onlyOwner returns (uint256) {
        IERC20(token).approve(msg.sender, uint256(-1));
    }
}

contract BasicMetaTransaction {

    using SafeMath for uint256;

    event MetaTransactionExecuted(address userAddress, address payable relayerAddress, bytes functionSignature);
    mapping(address => uint256) private nonces;

    function getChainID() public pure returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    /**
     * Main function to be called when user wants to execute meta transaction.
     * The actual function to be called should be passed as param with name functionSignature
     * Here the basic signature recovery is being used. Signature is expected to be generated using
     * personal_sign method.
     * @param userAddress Address of user trying to do meta transaction
     * @param functionSignature Signature of the actual function to be called via meta transaction
     * @param sigR R part of the signature
     * @param sigS S part of the signature
     * @param sigV V part of the signature
     */
    function executeMetaTransaction(address userAddress, bytes memory functionSignature,
        bytes32 sigR, bytes32 sigS, uint8 sigV) public payable returns(bytes memory) {

        require(verify(userAddress, nonces[userAddress], getChainID(), functionSignature, sigR, sigS, sigV), "Signer and signature do not match");
        nonces[userAddress] = nonces[userAddress].add(1);

        // Append userAddress at the end to extract it from calling context
        (bool success, bytes memory returnData) = address(this).call(abi.encodePacked(functionSignature, userAddress));

        require(success, "Function call not successful");
        emit MetaTransactionExecuted(userAddress, msg.sender, functionSignature);
        return returnData;
    }

    function getNonce(address user) external view returns(uint256 nonce) {
        nonce = nonces[user];
    }

    // Builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function verify(address owner, uint256 nonce, uint256 chainID, bytes memory functionSignature,
        bytes32 sigR, bytes32 sigS, uint8 sigV) public view returns (bool) {

        bytes32 hash = prefixed(keccak256(abi.encodePacked(nonce, this, chainID, functionSignature)));
        address signer = ecrecover(hash, sigV, sigR, sigS);
        require(signer != address(0), "Invalid signature");
		return (owner == signer);
    }

    function msgSender() internal view returns(address sender) {
        if(msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
            }
        } else {
            return msg.sender;
        }
    }
}

contract MutiRewardPool is Ownable, IERC20, BasicMetaTransaction {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    using EnumerableSet for EnumerableSet.UintSet;

    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _callers;

    // Info of each user.
    struct UserInfo {
        EnumerableSet.UintSet stakingIds;
    }

    struct StakingInfo {
        uint256 pid;
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 token0RewardDebt; // Reward debt. See explanation below.
        uint256 token1RewardDebt; // Reward debt. See explanation below.
        uint256 time; //Pledge start time
    }

    struct StakingView {
        uint256 pid;
        uint256 stakingId;
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 token0UnclaimedRewards;
        uint256 token1UnclaimedRewards;
        uint256 time; //Pledge start time
        uint256 unlockTime;
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken;           // Address of LP token contract.
        uint256 totalDeposit;
        uint256 duration;           //The duration of minimum pledge time.
        uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
        uint256 lastRewardBlock;  // Last block number that Tokens distribution occurs.
        uint256 token0AccRewardsPerShare; // Accumulated RewardTokens per share, times 1e12. See below.
        uint256 token1AccRewardsPerShare; // Accumulated RewardTokens per share, times 1e12. See below.
        uint256 token0AccAdditionalRewardsPerShare; // Accumulated Additional RewardTokens per share, times 1e12. See below.
        uint256 token1AccAdditionalRewardsPerShare; // Accumulated Additional RewardTokens per share, times 1e12. See below.
        uint256 token0AccDonateAmount;
        uint256 token1AccDonateAmount;
    }

    struct PoolView {
        uint256 pid;
        address lpToken;
        uint256 totalDeposit;
        uint256 duration; 
        uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
        uint256 lastRewardBlock;  // Last block number that Tokens distribution occurs.
        uint256 token0AccRewardsPerShare; // Accumulated RewardTokens per share, times 1e12. See below.
        uint256 token1AccRewardsPerShare; // Accumulated RewardTokens per share, times 1e12. See below.
        uint256 token0AccAdditionalRewardsPerShare; // Accumulated Additional RewardTokens per share, times 1e12. See below.
        uint256 token1AccAdditionalRewardsPerShare; // Accumulated Additional RewardTokens per share, times 1e12. See below.
        uint256 token0AccDonateAmount;
        uint256 token1AccDonateAmount;
        uint256 token0RewardsPerBlock;
        uint256 token1RewardsPerBlock;
        uint256 token0AdditionalRewardPerBlock;
        uint256 token1AdditionalRewardPerBlock;
        string lpSymbol;
        string lpName;
        uint8 lpDecimals;
        string rewardToken0Symbol;
        string rewardToken0Name;
        uint8 rewardToken0Decimals;
        string rewardToken1Symbol;
        string rewardToken1Name;
        uint8 rewardToken1Decimals;
    }

    IERC20 public depositToken;
    IERC20 public rewardToken0;
    IERC20 public rewardToken1;
    PoolVault public poolVault;

    // uint256 public maxStaking;

    // tokens created per block.
    uint256 public token0RewardPerBlock;
    uint256 public token1RewardPerBlock;

    // Additional bonus per block
    uint256 public token0AdditionalRewardPerBlock;
    uint256 public token1AdditionalRewardPerBlock;

    // Additional bonus end block
    uint256 public token0AdditionalRewardEndBlock;
    uint256 public token1AdditionalRewardEndBlock;

    // Bonus muliplier for early makers.
    uint256 public BONUS_MULTIPLIER = 1;

    // Info of each pool.
    PoolInfo[] public poolInfo;

    // Info of each user that stakes LP tokens.
    mapping (address => UserInfo) private userInfo;
    mapping (uint256 => StakingInfo) public stakingInfo;

    uint256 private lastStakingId;

    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 private totalAllocPoint = 0;


    // The block number when mining starts.
    uint256 public startBlock;
    // The block number when mining ends.
    uint256 public bonusEndBlock;

    event Deposit(address indexed user, uint256 pid, uint256 stakingId, uint256 amount);
    event Withdraw(address indexed user, uint256 pid, uint256 stakingId, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 pid, uint256 stakingId, uint256 amount);
    event Harvest(address indexed user, uint256 pid, uint256 stakingId, uint256 reward0Amount, uint256 reward1Amount);
    event Donate(address indexed user, uint256 pid, address donteToken, uint256 donateAmount, uint256 realAmount);

    constructor(
        IERC20 _depositToken,
        IERC20 _rewardToken0,
        IERC20 _rewardToken1,
        uint256 _token0RewardPerBlock,
        uint256 _token1RewardPerBlock,
        uint256 _startBlock,
        uint256 _bonusEndBlock
    ) public {
        depositToken = _depositToken;
        rewardToken0 = _rewardToken0;
        rewardToken1 = _rewardToken1;
        token0RewardPerBlock = _token0RewardPerBlock;
        token1RewardPerBlock = _token1RewardPerBlock;
        startBlock = _startBlock;
        bonusEndBlock = _bonusEndBlock;

        poolVault = new PoolVault();
        poolVault.approve(address(depositToken));
    }

    // function stopReward() public onlyOwner {
    //     bonusEndBlock = block.number;
    // }


    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        if (_to <= bonusEndBlock) {
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        } else if (_from >= bonusEndBlock) {
            return 0;
        } else {
            return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER);
        }
    }

    function updateMultiplier(uint256 multiplierNumber) public onlyOwner {
        massUpdatePools();
        BONUS_MULTIPLIER = multiplierNumber;
    }
    //SWC-135-Code With No Effects: L178-L200
    function addPool(
        uint256 _stakingDuration,
        uint256 _allocPoint
    ) public onlyOwner {
        massUpdatePools();

        // staking pool
        poolInfo.push(PoolInfo({
            lpToken: depositToken,
            totalDeposit: 0,
            duration: _stakingDuration,
            allocPoint: _allocPoint,
            lastRewardBlock: block.number > startBlock? block.number: startBlock,
            token0AccRewardsPerShare: 0,
            token1AccRewardsPerShare: 0,
            token0AccAdditionalRewardsPerShare: 0,
            token1AccAdditionalRewardsPerShare: 0,
            token0AccDonateAmount: 0,
            token1AccDonateAmount: 0
        }));

        totalAllocPoint = totalAllocPoint.add(_allocPoint);
    }

    // View function to see token0 pending Reward on frontend.
    function token0PendingReward(uint256 _stakingId) public view returns (uint256) {
        
        StakingInfo storage user = stakingInfo[_stakingId];
        PoolInfo storage pool = poolInfo[user.pid];
        uint256 lpSupply = pool.totalDeposit;

        if (user.amount == 0) {
            return 0;
        }

        uint256 amount;
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            
            uint256 accRewardsPerShare = pool.token0AccRewardsPerShare;
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 tokenReward = multiplier.mul(token0RewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accRewardsPerShare = accRewardsPerShare.add(tokenReward.mul(1e12).div(lpSupply));
            amount = user.amount.mul(accRewardsPerShare);
            
            uint256 endBlock = block.number > token0AdditionalRewardEndBlock? token0AdditionalRewardEndBlock : block.number;
            uint256 accAdditionalRewardsPerShare = pool.token0AccAdditionalRewardsPerShare;
            if (endBlock > pool.lastRewardBlock) {
                uint256 additionalMultiplier = getMultiplier(pool.lastRewardBlock, endBlock);
                uint256 additionalTokenReward = additionalMultiplier.mul(token0AdditionalRewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
                accAdditionalRewardsPerShare = accAdditionalRewardsPerShare.add(additionalTokenReward.mul(1e12).div(lpSupply));
            }
            amount = amount.add(user.amount.mul(accAdditionalRewardsPerShare));
        }

        return amount.div(1e12).sub(user.token0RewardDebt);
    }

    // View function to see token1 pending Reward on frontend.
    function token1PendingReward(uint256 _stakingId) public view returns (uint256) {
        StakingInfo storage user = stakingInfo[_stakingId];
        PoolInfo storage pool = poolInfo[user.pid];
        uint256 lpSupply = pool.totalDeposit;

        if (user.amount == 0) {
            return 0;
        }

        uint256 amount;
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            
            uint256 accRewardsPerShare = pool.token1AccRewardsPerShare;
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 tokenReward = multiplier.mul(token1RewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accRewardsPerShare = accRewardsPerShare.add(tokenReward.mul(1e12).div(lpSupply));
            amount = user.amount.mul(accRewardsPerShare);
            
            uint256 endBlock = block.number > token1AdditionalRewardEndBlock? token1AdditionalRewardEndBlock : block.number;
            uint256 accAdditionalRewardsPerShare = pool.token1AccAdditionalRewardsPerShare;
            if (endBlock > pool.lastRewardBlock) {
                uint256 additionalMultiplier = getMultiplier(pool.lastRewardBlock, endBlock);
                uint256 additionalTokenReward = additionalMultiplier.mul(token1AdditionalRewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
                accAdditionalRewardsPerShare = accAdditionalRewardsPerShare.add(additionalTokenReward.mul(1e12).div(lpSupply));
            }
            amount = amount.add(user.amount.mul(accAdditionalRewardsPerShare));
        }

        return amount.div(1e12).sub(user.token1RewardDebt);
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.totalDeposit;
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);

        uint256 token0Reward = multiplier.mul(token0RewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        pool.token0AccRewardsPerShare = pool.token0AccRewardsPerShare.add(token0Reward.mul(1e12).div(lpSupply));
        {
            uint256 endBlock = block.number > token0AdditionalRewardEndBlock? token0AdditionalRewardEndBlock : block.number;
            if (endBlock > pool.lastRewardBlock) {
                uint256 additionalMultiplier = getMultiplier(pool.lastRewardBlock, endBlock);
                uint256 additionalTokenReward = additionalMultiplier.mul(token0AdditionalRewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
                pool.token0AccAdditionalRewardsPerShare = pool.token0AccAdditionalRewardsPerShare.add(additionalTokenReward.mul(1e12).div(lpSupply));
            }

            if (block.number >= token0AdditionalRewardEndBlock) {
                token0AdditionalRewardPerBlock = 0;
            }
        }
        
        uint256 token1Reward = multiplier.mul(token1RewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        pool.token1AccRewardsPerShare = pool.token1AccRewardsPerShare.add(token1Reward.mul(1e12).div(lpSupply));
        {
            uint256 endBlock = block.number > token1AdditionalRewardEndBlock? token1AdditionalRewardEndBlock : block.number;
            if (endBlock > pool.lastRewardBlock) {
                uint256 additionalMultiplier = getMultiplier(pool.lastRewardBlock, endBlock);
                uint256 additionalTokenReward = additionalMultiplier.mul(token1AdditionalRewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
                pool.token1AccAdditionalRewardsPerShare = pool.token1AccAdditionalRewardsPerShare.add(additionalTokenReward.mul(1e12).div(lpSupply));
            }

            if (block.number >= token1AdditionalRewardEndBlock) {
                token1AdditionalRewardPerBlock = 0;
            }
        }

        pool.lastRewardBlock = block.number;
    }

    // Update reward variables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    // Stake tokens to Pool
    function deposit(uint256 pid, uint256 _amount) public {
        require(_amount > 0, "bad amount");

        PoolInfo storage pool = poolInfo[pid];
        UserInfo storage user = userInfo[msgSender()];

        // require (_amount.add(user.amount) <= maxStaking, 'exceed max stake');

        updatePool(pid);

        uint256 oldBal = pool.lpToken.balanceOf(address(poolVault));
        pool.lpToken.safeTransferFrom(address(msgSender()), address(poolVault), _amount);
        _amount = pool.lpToken.balanceOf(address(poolVault)).sub(oldBal);

        lastStakingId++;
        pool.totalDeposit = pool.totalDeposit.add(_amount);

        stakingInfo[lastStakingId] = StakingInfo({
            pid: pid,
            amount: _amount,
            token0RewardDebt: _amount.mul(pool.token0AccRewardsPerShare).add(_amount.mul(pool.token0AccAdditionalRewardsPerShare)).div(1e12),
            token1RewardDebt: _amount.mul(pool.token1AccRewardsPerShare).add(_amount.mul(pool.token1AccAdditionalRewardsPerShare)).div(1e12),
            time: block.timestamp
        });
        user.stakingIds.add(lastStakingId);

        emit Deposit(msgSender(), pid, lastStakingId, _amount);
        emit Transfer(address(0), msgSender(), _amount);
    }

    function harvestAll() public {
        UserInfo storage user = userInfo[msgSender()];

        uint256 len = user.stakingIds.length();

        for(uint256 i = 0; i < len; ++i) {
            harvest(user.stakingIds.at(i));
        }
    }

    function harvestPool(uint256 pid) public {
        UserInfo storage user = userInfo[msgSender()];

        uint256 len = user.stakingIds.length();

        for(uint256 i = 0; i < len; ++i) {
            uint256 id = user.stakingIds.at(i);
            if (stakingInfo[id].pid != pid) {
                continue;
            }
            harvest(id);
        }
    }

    function harvest(uint256 _stakingId) public {
        
        UserInfo storage user = userInfo[msgSender()];
        require(user.stakingIds.contains(_stakingId), "not the staking owner");
        StakingInfo storage staking = stakingInfo[_stakingId];
        PoolInfo storage pool = poolInfo[staking.pid];

        updatePool(staking.pid);

        uint256 reward0;
        uint256 reward1;
        if (staking.amount > 0) {
            {
                uint256 pending = staking.amount.mul(pool.token0AccRewardsPerShare).add(staking.amount.mul(pool.token0AccAdditionalRewardsPerShare)).div(1e12).sub(staking.token0RewardDebt);
                if(pending > 0) {
                    uint256 bal = rewardToken0.balanceOf(address(this));
                    if(bal >= pending) {
                        reward0 = pending;
                    } else {
                        reward0 = bal;
                    }
                }
            }
            
            {
                uint256 pending = staking.amount.mul(pool.token1AccRewardsPerShare).add(staking.amount.mul(pool.token1AccAdditionalRewardsPerShare)).div(1e12).sub(staking.token1RewardDebt);
                if(pending > 0) {
                    uint256 bal = rewardToken1.balanceOf(address(this));
                    if(bal >= pending) {
                        reward1 = pending;
                    } else {
                        reward1 = bal;
                    }
                }
            }
        }

        staking.token0RewardDebt = staking.amount.mul(pool.token0AccRewardsPerShare).add(staking.amount.mul(pool.token0AccAdditionalRewardsPerShare)).div(1e12);
        staking.token1RewardDebt = staking.amount.mul(pool.token1AccRewardsPerShare).add(staking.amount.mul(pool.token1AccAdditionalRewardsPerShare)).div(1e12);

        if (reward0 > 0) {
            rewardToken0.safeTransfer(address(msgSender()), reward0);
        }

         if (reward1 > 0) {
            rewardToken1.safeTransfer(address(msgSender()), reward1);
        }

        emit Harvest(msgSender(), staking.pid, _stakingId, reward0, reward1);
    }

    // Withdraw tokens from STAKING.
    function withdraw(uint256 _stakingId) public {
        UserInfo storage user = userInfo[msgSender()];
        require(user.stakingIds.contains(_stakingId), "not the staking owner");
        StakingInfo storage staking = stakingInfo[_stakingId];
        PoolInfo storage pool = poolInfo[staking.pid];

        require(block.timestamp.sub(staking.time) >= pool.duration, "not time");

        harvest(_stakingId);

        uint256 _amount = staking.amount;
        staking.amount = 0;
        pool.totalDeposit = pool.totalDeposit.sub(_amount);
        pool.lpToken.safeTransferFrom(address(poolVault), address(msgSender()), _amount);
        
        staking.token0RewardDebt = _amount.mul(pool.token0AccRewardsPerShare).add(_amount.mul(pool.token0AccAdditionalRewardsPerShare)).div(1e12);
        staking.token1RewardDebt = _amount.mul(pool.token1AccRewardsPerShare).add(_amount.mul(pool.token1AccAdditionalRewardsPerShare)).div(1e12);

        user.stakingIds.remove(_stakingId);

        emit Withdraw(msgSender(), staking.pid, _stakingId, _amount);
        emit Transfer(msgSender(), address(0), _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _stakingId) public {
        UserInfo storage user = userInfo[msgSender()];
        require(user.stakingIds.contains(_stakingId), "not the staking owner");
        StakingInfo storage staking = stakingInfo[_stakingId];
        PoolInfo storage pool = poolInfo[staking.pid];
        require(block.number.sub(staking.time) >= pool.duration, "not time");

        uint256 amount = staking.amount;
        
        if(pool.totalDeposit >= staking.amount) {
            pool.totalDeposit = pool.totalDeposit.sub(staking.amount);
        } else {
            pool.totalDeposit = 0;
        }
        staking.amount = 0;
        staking.token0RewardDebt = 0;
        staking.token1RewardDebt = 0;

        user.stakingIds.remove(_stakingId);

        pool.lpToken.safeTransferFrom(address(poolVault), address(msgSender()), amount);

        emit EmergencyWithdraw(msgSender(),  staking.pid, _stakingId, amount);
        emit Transfer(msgSender(), address(0), amount);
    }

    // Withdraw reward. EMERGENCY ONLY.
    function emergencyRewardWithdrawToken0(uint256 _amount) public onlyOwner {
        require(_amount <= rewardToken0.balanceOf(address(this)), 'not enough token');
        rewardToken0.safeTransfer(address(msgSender()), _amount);
    }

    // Withdraw reward. EMERGENCY ONLY.
    function emergencyRewardWithdrawToken1(uint256 _amount) public onlyOwner {
        require(_amount <= rewardToken1.balanceOf(address(this)), 'not enough token');
        rewardToken1.safeTransfer(address(msgSender()), _amount);
    }

    function totalStaking(address account) public view returns(uint256 amount) {
        UserInfo storage user = userInfo[account];
        uint ln = user.stakingIds.length();

        for (uint i = 0; i < ln; ++i) {
            amount = amount.add(stakingInfo[user.stakingIds.at(i)].amount);
        }
    }

    function donate(IERC20 token, uint256 donateAmount) public {
        require(token == rewardToken0 || token == rewardToken1, "not support token");

        uint256 oldBal = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransferFrom(msgSender(), address(this), donateAmount);
        uint256 realAmount = IERC20(token).balanceOf(address(this)) - oldBal;

        bool isToken0 = token == rewardToken0 ? true : false;
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);

            PoolInfo storage pool = poolInfo[pid];
            if(pool.allocPoint == 0) {
                continue;
            }

            if(pool.totalDeposit == 0) {
                continue;
            }

            uint256 tokenReward = realAmount.mul(1e12).mul(pool.allocPoint).div(totalAllocPoint);
            if (isToken0) {
                pool.token0AccRewardsPerShare = pool.token0AccRewardsPerShare.add(tokenReward.div(pool.totalDeposit));
                pool.token0AccDonateAmount = pool.token0AccDonateAmount.add(tokenReward);
            } else {
                pool.token1AccRewardsPerShare = pool.token1AccRewardsPerShare.add(tokenReward.div(pool.totalDeposit));
                pool.token1AccDonateAmount = pool.token1AccDonateAmount.add(tokenReward);
            }
            emit Donate(msgSender(), pid, address(token), tokenReward.div(1e12), tokenReward.div(1e12));
        }
    }

    function addAdditionalRewards(IERC20 token, uint256 amount, uint256 rewardsBlocks) public onlyCaller {
        require(token == rewardToken0 || token == rewardToken1, "not support token");

        massUpdatePools();

        uint256 oldBal = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransferFrom(msgSender(), address(this), amount);
        uint256 realAmount = IERC20(token).balanceOf(address(this)).sub(oldBal);

        if (token == rewardToken0) {
            uint256 remainingBlocks = token0AdditionalRewardEndBlock > block.number ? token0AdditionalRewardEndBlock.sub(block.number) : 0;
            uint256 remainingBal = token0AdditionalRewardPerBlock.mul(remainingBlocks);

            if(remainingBal > 0) {
                rewardsBlocks = rewardsBlocks.add(remainingBlocks);
            }
            remainingBal = remainingBal.add(realAmount);

            token0AdditionalRewardPerBlock = remainingBal.div(rewardsBlocks);

            if(block.number >= startBlock) {
                token0AdditionalRewardEndBlock = block.number.add(rewardsBlocks);
            } else {
                token0AdditionalRewardEndBlock = startBlock.add(rewardsBlocks);
            }
        } else {
            uint256 remainingBlocks = token1AdditionalRewardEndBlock > block.number ? token1AdditionalRewardEndBlock.sub(block.number) : 0;
            uint256 remainingBal = token1AdditionalRewardPerBlock.mul(remainingBlocks);

            if(remainingBal > 0) {
                rewardsBlocks = rewardsBlocks.add(remainingBlocks);
            }
            remainingBal = remainingBal.add(realAmount);

            token1AdditionalRewardPerBlock = remainingBal.div(rewardsBlocks);

            if(block.number >= startBlock) {
                token1AdditionalRewardEndBlock = block.number.add(rewardsBlocks);
            } else {
                token1AdditionalRewardEndBlock = startBlock.add(rewardsBlocks);
            }
        }
    }

    function getBaseInfo() public view 
    returns (
        address depositToken_, 
        address rewardToken0_, 
        address rewardToken1_, 
        uint256 token0RewardPerBlock_,
        uint256 token1RewardPerBlock_,
        uint256 token0AdditionalRewardPerBlock_,
        uint256 token1AdditionalRewardPerBlock_,
        uint256 token0AdditionalRewardEndBlock_,
        uint256 token1AdditionalRewardEndBlock_,
        uint256 totalAllocPoint_,
        uint256 startBlock_,
        uint256 bonusEndBlock_
    ) {
        depositToken_ = address(depositToken);
        rewardToken0_ = address(rewardToken0);
        rewardToken1_ = address(rewardToken1);
        token0RewardPerBlock_ = token0RewardPerBlock;
        token1RewardPerBlock_ = token1RewardPerBlock;
        token0AdditionalRewardPerBlock_ = token0AdditionalRewardPerBlock;
        token1AdditionalRewardPerBlock_ = token1AdditionalRewardPerBlock;
        token0AdditionalRewardEndBlock_ = token0AdditionalRewardEndBlock;
        token1AdditionalRewardEndBlock_ = token1AdditionalRewardEndBlock;
        totalAllocPoint_ = totalAllocPoint;
        startBlock_ = startBlock;
        bonusEndBlock_ = bonusEndBlock;
    }

    function getPoolView(uint256 pid) public view returns(PoolView memory) {
        require(pid < poolInfo.length, "MutiRewardPool: pid out of range");

        PoolInfo memory pool = poolInfo[pid];

        string memory symbol = IERC20Metadata(address(pool.lpToken)).symbol();
        string memory name = IERC20Metadata(address(pool.lpToken)).name();
        uint8 decimals = IERC20Metadata(address(pool.lpToken)).decimals();

        uint256 rewardsPerBlock0 = pool.allocPoint.mul(token0RewardPerBlock).div(totalAllocPoint);
        uint256 rewardsPerBlock1 = pool.allocPoint.mul(token1RewardPerBlock).div(totalAllocPoint);

        uint256 additionalRewardsPerBlock0 = pool.allocPoint.mul(token0AdditionalRewardPerBlock).div(totalAllocPoint);
        uint256 additionalRewardsPerBlock1 = pool.allocPoint.mul(token1AdditionalRewardPerBlock).div(totalAllocPoint);

        return
            PoolView({
                pid: pid,
                lpToken: address(pool.lpToken),
                totalDeposit: pool.totalDeposit,
                duration: pool.duration,
                allocPoint: pool.allocPoint,
                lastRewardBlock: pool.lastRewardBlock,
                token0AccRewardsPerShare: pool.token0AccRewardsPerShare,
                token1AccRewardsPerShare: pool.token1AccRewardsPerShare,
                token0AccAdditionalRewardsPerShare: pool.token0AccAdditionalRewardsPerShare,
                token1AccAdditionalRewardsPerShare: pool.token1AccAdditionalRewardsPerShare,
                token0AccDonateAmount: pool.token0AccDonateAmount,
                token1AccDonateAmount: pool.token1AccDonateAmount,
                token0RewardsPerBlock: rewardsPerBlock0,
                token1RewardsPerBlock: rewardsPerBlock1,
                token0AdditionalRewardPerBlock: additionalRewardsPerBlock0,
                token1AdditionalRewardPerBlock: additionalRewardsPerBlock1,
                lpSymbol: symbol,
                lpName: name,
                lpDecimals: decimals,
                rewardToken0Symbol: IERC20Metadata(address(rewardToken0)).symbol(),
                rewardToken0Name: IERC20Metadata(address(rewardToken0)).name(),
                rewardToken0Decimals: IERC20Metadata(address(rewardToken0)).decimals(),
                rewardToken1Symbol: IERC20Metadata(address(rewardToken1)).symbol(),
                rewardToken1Name: IERC20Metadata(address(rewardToken1)).name(),
                rewardToken1Decimals: IERC20Metadata(address(rewardToken1)).decimals()
            });
    }

    function getAllPoolViews() external view returns (PoolView[] memory) {
        PoolView[] memory views = new PoolView[](poolInfo.length);
        for (uint256 i = 0; i < poolInfo.length; i++) {
            views[i] = getPoolView(i);
        }
        return views;
    }

    function getStakingView(uint256 stakingId) public view returns(StakingView memory) {
        StakingInfo memory staking = stakingInfo[stakingId];

        uint256 token0UnclaimedRewards = token0PendingReward(stakingId);
        uint256 token1UnclaimedRewards = token1PendingReward(stakingId);

        return StakingView({
            pid: staking.pid,
            stakingId: stakingId,
            amount: staking.amount,
            token0UnclaimedRewards: token0UnclaimedRewards,
            token1UnclaimedRewards: token1UnclaimedRewards,
            time: staking.time,
            unlockTime: poolInfo[staking.pid].duration.add(staking.time)
        });

    }

    function getStakingViews(address account) public view returns(StakingView[] memory) {
        UserInfo storage user = userInfo[account];

        uint256 len = user.stakingIds.length();

        StakingView[] memory views = new StakingView[](len);

        for (uint i = 0; i < len; ++i) {
            views[i] = getStakingView(user.stakingIds.at(i));
        }
        return views;
    }

    /******************************   ERC20   ******************************/

    function name() public view virtual returns (string memory) {
        return string( abi.encodePacked( "Staked ", IERC20Metadata(address(depositToken)).symbol() ));
    }

    function symbol() public view virtual returns (string memory) {
        return string( abi.encodePacked( "ve", IERC20Metadata(address(depositToken)).symbol() ));
    }

    function decimals() public view virtual returns (uint8) {
        return IERC20Metadata(address(depositToken)).decimals();
    }

    function totalSupply() public view override returns (uint256) {
        uint256 totalDeposit;
        for(uint i = 0; i < poolInfo.length; ++i) {
            totalDeposit = totalDeposit.add(poolInfo[i].totalDeposit.mul(poolInfo[i].allocPoint));
        }
        return totalDeposit;
    }

    function balanceOf(address account) public view override returns (uint256) {
        
        UserInfo storage user = userInfo[account];
        uint ln = user.stakingIds.length();

        uint256 bal;
        for (uint i = 0; i < ln; ++i) {
            StakingInfo memory staking = stakingInfo[user.stakingIds.at(i)];
            bal = bal.add(staking.amount.mul(poolInfo[staking.pid].allocPoint));
        }

        return bal;
    }

    function transfer(address, uint256) public override returns (bool) {
        revert("can not allow transfer");
    }

    function allowance(address, address) public view override returns (uint256) {
        return 0;
    }

    function approve(address, uint256) public override returns (bool) {
        revert("can not allow approve");
    }

    function transferFrom(address, address, uint256) public override returns (bool) {
        revert("can not allow transfer");
    }


    /******************************   Caller   ******************************/

    modifier onlyCaller() {
        require(isCaller(msgSender()), "Treasury: not the caller");
        _;
    }

    function addCaller(address _newCaller) public onlyOwner returns (bool) {
        require(_newCaller != address(0), "MutiRewardPool: address is zero");
        return EnumerableSet.add(_callers, _newCaller);
    }

    function delCaller(address _delCaller) public onlyOwner returns (bool) {
        require(_delCaller != address(0), "MutiRewardPool: address is zero");
        return EnumerableSet.remove(_callers, _delCaller);
    }

    function getCallerLength() public view returns (uint256) {
        return EnumerableSet.length(_callers);
    }

    function isCaller(address _caller) public view returns (bool) {
        return EnumerableSet.contains(_callers, _caller);
    }

    function getCaller(uint256 _index) public view returns (address) {
        require(_index <= getCallerLength() - 1, "MutiRewardPool: index out of bounds");
        return EnumerableSet.at(_callers, _index);
    }
}
