pragma solidity ^0.6.0;


// SPDX-License-Identifier: MIT
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

/// @title Fee collector interface
interface IFeeCollector {
    /// @notice Adds specified `amount` as reward to `receiver`
    function updateReward(address receiver, uint256 amount) external;
    /// @notice Same as `updateReward` but for multiple accounts
    function updateRewards(address[] calldata receivers, uint256[] calldata amounts) external;
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

library UniERC20 {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    function isETH(IERC20 token) internal pure returns(bool) {
        return (address(token) == address(0));
    }

    function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
        if (isETH(token)) {
            return account.balance;
        } else {
            return token.balanceOf(account);
        }
    }

    function uniTransfer(IERC20 token, address payable to, uint256 amount) internal {
        if (amount > 0) {
            if (isETH(token)) {
                to.transfer(amount);
            } else {
                token.safeTransfer(to, amount);
            }
        }
    }

    function uniTransferFrom(IERC20 token, address payable from, address to, uint256 amount) internal {
        if (amount > 0) {
            if (isETH(token)) {
                require(msg.value >= amount, "UniERC20: not enough value");
                require(from == msg.sender, "from is not msg.sender");
                require(to == address(this), "to is not this");
                if (msg.value > amount) {
                    // Return remainder if exist
                    from.transfer(msg.value.sub(amount));
                }
            } else {
                token.safeTransferFrom(from, to, amount);
            }
        }
    }

    function uniSymbol(IERC20 token) internal view returns(string memory) {
        if (isETH(token)) {
            return "ETH";
        }

        (bool success, bytes memory data) = address(token).staticcall{ gas: 20000 }(
            abi.encodeWithSignature("symbol()")
        );
        if (!success) {
            (success, data) = address(token).staticcall{ gas: 20000 }(
                abi.encodeWithSignature("SYMBOL()")
            );
        }

        if (success && data.length >= 96) {
            (uint256 offset, uint256 len) = abi.decode(data, (uint256, uint256));
            if (offset == 0x20 && len > 0 && len <= 256) {
                return string(abi.decode(data, (bytes)));
            }
        }

        if (success && data.length == 32) {
            uint len = 0;
            while (len < data.length && data[len] >= 0x20 && data[len] <= 0x7E) {
                len++;
            }

            if (len > 0) {
                bytes memory result = new bytes(len);
                for (uint i = 0; i < len; i++) {
                    result[i] = data[i];
                }
                return string(result);
            }
        }

        return _toHex(address(token));
    }

    function _toHex(address account) private pure returns(string memory) {
        return _toHex(abi.encodePacked(account));
    }

    function _toHex(bytes memory data) private pure returns(string memory) {
        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        uint j = 2;
        for (uint i = 0; i < data.length; i++) {
            uint a = uint8(data[i]) >> 4;
            uint b = uint8(data[i]) & 0x0f;
            str[j++] = byte(uint8(a + 48 + (a/10)*39));
            str[j++] = byte(uint8(b + 48 + (b/10)*39));
        }

        return string(str);
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

library Sqrt {
    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256) {
        if (y > 3) {
            uint256 z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
            return z;
        } else if (y != 0) {
            return 1;
        } else {
            return 0;
        }
    }
}

library SafeCast {
    function toUint216(uint256 value) internal pure returns (uint216) {
        require(value < 2**216, "value does not fit in 216 bits");
        return uint216(value);
    }

    function toUint104(uint256 value) internal pure returns (uint104) {
        require(value < 2**104, "value does not fit in 104 bits");
        return uint104(value);
    }

    function toUint48(uint256 value) internal pure returns (uint48) {
        require(value < 2**48, "value does not fit in 48 bits");
        return uint48(value);
    }

    function toUint40(uint256 value) internal pure returns (uint40) {
        require(value < 2**40, "value does not fit in 40 bits");
        return uint40(value);
    }
}

library VirtualBalance {
    using SafeMath for uint256;
    using SafeCast for uint256;

    struct Data {
        uint216 balance;
        uint40 time;
    }

    function set(VirtualBalance.Data storage self, uint256 balance) internal {
        (self.balance, self.time) = (
            balance.toUint216(),
            block.timestamp.toUint40()
        );
    }

    function update(VirtualBalance.Data storage self, uint256 decayPeriod, uint256 realBalance) internal {
        set(self, current(self, decayPeriod, realBalance));
    }

    function scale(VirtualBalance.Data storage self, uint256 decayPeriod, uint256 realBalance, uint256 num, uint256 denom) internal {
        set(self, current(self, decayPeriod, realBalance).mul(num).add(denom.sub(1)).div(denom));
    }

    function current(VirtualBalance.Data memory self, uint256 decayPeriod, uint256 realBalance) internal view returns(uint256) {
        uint256 timePassed = Math.min(decayPeriod, block.timestamp.sub(self.time));
        uint256 timeRemain = decayPeriod.sub(timePassed);
        return uint256(self.balance).mul(timeRemain).add(
            realBalance.mul(timePassed)
        ).div(decayPeriod);
    }
}

/// @title Describes methods that provide all the information about current governance contract state
interface IMooniswapFactoryGovernance {
    /// @notice Returns information about mooniswap shares
    /// @return referralShare Referrals share
    /// @return governanceShare Governance share
    /// @return governanceWallet Governance wallet address
    /// @return referralFeeReceiver Fee collector address
    function shareParameters() external view returns(uint256 referralShare, uint256 governanceShare, address governanceWallet, address referralFeeReceiver);
    /// @notice Initial settings that contract was created
    /// @return defaultFee Default fee
    /// @return defaultSlippageFee Default slippage fee
    /// @return defaultDecayPeriod Decay period for virtual amounts
    function defaults() external view returns(uint256 defaultFee, uint256 defaultSlippageFee, uint256 defaultDecayPeriod);

    /// @notice Same as `defaults` but only returns fee
    function defaultFee() external view returns(uint256);
    /// @notice Same as `defaults` but only returns slippage fee
    function defaultSlippageFee() external view returns(uint256);
    /// @notice Same as `defaults` but only returns decay period
    function defaultDecayPeriod() external view returns(uint256);

    /// @notice Describes previous default fee that had place, current one and time on which this changed
    function virtualDefaultFee() external view returns(uint104, uint104, uint48);
    /// @notice Describes previous default slippage fee that had place, current one and time on which this changed
    function virtualDefaultSlippageFee() external view returns(uint104, uint104, uint48);
    /// @notice Describes previous default decay amount that had place, current one and time on which this changed
    function virtualDefaultDecayPeriod() external view returns(uint104, uint104, uint48);

    /// @notice Same as `shareParameters` but only returns referral share
    function referralShare() external view returns(uint256);
    /// @notice Same as `shareParameters` but only returns governance share
    function governanceShare() external view returns(uint256);
    /// @notice Same as `shareParameters` but only returns governance wallet address
    function governanceWallet() external view returns(address);
    /// @notice Same as `shareParameters` but only returns fee collector address
    function feeCollector() external view returns(address);

    /// @notice True if address is current fee collector or was in the past. Otherwise, false
    function isFeeCollector(address) external view returns(bool);
    /// @notice True if contract is currently working and wasn't stopped. Otherwise, false
    function isActive() external view returns (bool);
}

library VirtualVote {
    using SafeMath for uint256;

    uint256 private constant _VOTE_DECAY_PERIOD = 1 days;

    struct Data {
        uint104 oldResult;
        uint104 result;
        uint48 time;
    }

    function current(VirtualVote.Data memory self) internal view returns(uint256) {
        uint256 timePassed = Math.min(_VOTE_DECAY_PERIOD, block.timestamp.sub(self.time));
        uint256 timeRemain = _VOTE_DECAY_PERIOD.sub(timePassed);
        return uint256(self.oldResult).mul(timeRemain).add(
            uint256(self.result).mul(timePassed)
        ).div(_VOTE_DECAY_PERIOD);
    }
}

library Vote {
    struct Data {
        uint256 value;
    }

    function eq(Vote.Data memory self, Vote.Data memory vote) internal pure returns(bool) {
        return self.value == vote.value;
    }

    function init() internal pure returns(Vote.Data memory data) {
        return Vote.Data({
            value: 0
        });
    }

    function init(uint256 vote) internal pure returns(Vote.Data memory data) {
        return Vote.Data({
            value: vote + 1
        });
    }

    function isDefault(Data memory self) internal pure returns(bool) {
        return self.value == 0;
    }

    function get(Data memory self, uint256 defaultVote) internal pure returns(uint256) {
        if (self.value > 0) {
            return self.value - 1;
        }
        return defaultVote;
    }

    function get(Data memory self, function() external view returns(uint256) defaultVoteFn) internal view returns(uint256) {
        if (self.value > 0) {
            return self.value - 1;
        }
        return defaultVoteFn();
    }
}

library LiquidVoting {
    using SafeMath for uint256;
    using SafeCast for uint256;
    using Vote for Vote.Data;
    using VirtualVote for VirtualVote.Data;

    struct Data {
        VirtualVote.Data data;
        uint256 _weightedSum;
        uint256 _defaultVotes;
        mapping(address => Vote.Data) votes;
    }

    function updateVote(
        LiquidVoting.Data storage self,
        address user,
        Vote.Data memory oldVote,
        Vote.Data memory newVote,
        uint256 balance,
        uint256 totalSupply,
        uint256 defaultVote,
        function(address, uint256, bool, uint256) emitEvent
    ) internal {
        return _update(self, user, oldVote, newVote, balance, balance, totalSupply, defaultVote, emitEvent);
    }

    function updateBalance(
        LiquidVoting.Data storage self,
        address user,
        Vote.Data memory oldVote,
        uint256 oldBalance,
        uint256 newBalance,
        uint256 newTotalSupply,
        uint256 defaultVote,
        function(address, uint256, bool, uint256) emitEvent
    ) internal {
        return _update(self, user, oldVote, newBalance == 0 ? Vote.init() : oldVote, oldBalance, newBalance, newTotalSupply, defaultVote, emitEvent);
    }

    function _update(
        LiquidVoting.Data storage self,
        address user,
        Vote.Data memory oldVote,
        Vote.Data memory newVote,
        uint256 oldBalance,
        uint256 newBalance,
        uint256 newTotalSupply,
        uint256 defaultVote,
        function(address, uint256, bool, uint256) emitEvent
    ) private {
        uint256 oldWeightedSum = self._weightedSum;
        uint256 newWeightedSum = oldWeightedSum;
        uint256 oldDefaultVotes = self._defaultVotes;
        uint256 newDefaultVotes = oldDefaultVotes;

        if (oldVote.isDefault()) {
            newDefaultVotes = newDefaultVotes.sub(oldBalance);
        } else {
            newWeightedSum = newWeightedSum.sub(oldBalance.mul(oldVote.get(defaultVote)));
        }

        if (newVote.isDefault()) {
            newDefaultVotes = newDefaultVotes.add(newBalance);
        } else {
            newWeightedSum = newWeightedSum.add(newBalance.mul(newVote.get(defaultVote)));
        }

        if (newWeightedSum != oldWeightedSum) {
            self._weightedSum = newWeightedSum;
        }

        if (newDefaultVotes != oldDefaultVotes) {
            self._defaultVotes = newDefaultVotes;
        }

        {
            uint256 newResult = newTotalSupply == 0 ? defaultVote : newWeightedSum.add(newDefaultVotes.mul(defaultVote)).div(newTotalSupply);
            VirtualVote.Data memory data = self.data;

            if (newResult != data.result) {
                VirtualVote.Data storage sdata = self.data;
                (sdata.oldResult, sdata.result, sdata.time) = (
                    data.current().toUint104(),
                    newResult.toUint104(),
                    block.timestamp.toUint48()
                );
            }
        }

        if (!newVote.eq(oldVote)) {
            self.votes[user] = newVote;
        }

        emitEvent(user, newVote.get(defaultVote), newVote.isDefault(), newBalance);
    }
}

library MooniswapConstants {
    uint256 internal constant _FEE_DENOMINATOR = 1e18;

    uint256 internal constant _MIN_REFERRAL_SHARE = 0.05e18; // 5%
    uint256 internal constant _MIN_DECAY_PERIOD = 1 minutes;

    uint256 internal constant _MAX_FEE = 0.01e18; // 1%
    uint256 internal constant _MAX_SLIPPAGE_FEE = 1e18;  // 100%
    uint256 internal constant _MAX_SHARE = 0.1e18; // 10%
    uint256 internal constant _MAX_DECAY_PERIOD = 5 minutes;

    uint256 internal constant _DEFAULT_FEE = 0;
    uint256 internal constant _DEFAULT_SLIPPAGE_FEE = 1e18;  // 100%
    uint256 internal constant _DEFAULT_REFERRAL_SHARE = 0.1e18; // 10%
    uint256 internal constant _DEFAULT_GOVERNANCE_SHARE = 0;
    uint256 internal constant _DEFAULT_DECAY_PERIOD = 1 minutes;
}

/// @title 1inch Mooniswap governance
abstract contract MooniswapGovernance is ERC20, Ownable, ReentrancyGuard {
    using Vote for Vote.Data;
    using LiquidVoting for LiquidVoting.Data;
    using VirtualVote for VirtualVote.Data;
    using SafeCast for uint256;

    event FeeVoteUpdate(address indexed user, uint256 fee, bool isDefault, uint256 amount);
    event SlippageFeeVoteUpdate(address indexed user, uint256 slippageFee, bool isDefault, uint256 amount);
    event DecayPeriodVoteUpdate(address indexed user, uint256 decayPeriod, bool isDefault, uint256 amount);

    IMooniswapFactoryGovernance public mooniswapFactoryGovernance;
    LiquidVoting.Data private _fee;
    LiquidVoting.Data private _slippageFee;
    LiquidVoting.Data private _decayPeriod;

    constructor(IMooniswapFactoryGovernance _mooniswapFactoryGovernance) internal {
        mooniswapFactoryGovernance = _mooniswapFactoryGovernance;
        _fee.data.result = _mooniswapFactoryGovernance.defaultFee().toUint104();
        _slippageFee.data.result = _mooniswapFactoryGovernance.defaultSlippageFee().toUint104();
        _decayPeriod.data.result = _mooniswapFactoryGovernance.defaultDecayPeriod().toUint104();
    }

    function setMooniswapFactoryGovernance(IMooniswapFactoryGovernance newMooniswapFactoryGovernance) external onlyOwner {
        mooniswapFactoryGovernance = newMooniswapFactoryGovernance;
        this.discardFeeVote();
        this.discardSlippageFeeVote();
        this.discardDecayPeriodVote();
    }

    /// @notice Current fee
    function fee() public view returns(uint256) {
        return _fee.data.current();
    }

    /// @notice Current slippage
    function slippageFee() public view returns(uint256) {
        return _slippageFee.data.current();
    }

    /// @notice Current decay period
    function decayPeriod() public view returns(uint256) {
        return _decayPeriod.data.current();
    }

    /// @notice Describes previous fee that had place, current one and time on which this changed
    function virtualFee() external view returns(uint104, uint104, uint48) {
        return (_fee.data.oldResult, _fee.data.result, _fee.data.time);
    }

    /// @notice Describes previous slippage fee that had place, current one and time on which this changed
    function virtualSlippageFee() external view returns(uint104, uint104, uint48) {
        return (_slippageFee.data.oldResult, _slippageFee.data.result, _slippageFee.data.time);
    }

    /// @notice Describes previous decay period that had place, current one and time on which this changed
    function virtualDecayPeriod() external view returns(uint104, uint104, uint48) {
        return (_decayPeriod.data.oldResult, _decayPeriod.data.result, _decayPeriod.data.time);
    }

    /// @notice Returns user stance to preferred fee
    function feeVotes(address user) external view returns(uint256) {
        return _fee.votes[user].get(mooniswapFactoryGovernance.defaultFee);
    }

    /// @notice Returns user stance to preferred slippage fee
    function slippageFeeVotes(address user) external view returns(uint256) {
        return _slippageFee.votes[user].get(mooniswapFactoryGovernance.defaultSlippageFee);
    }

    /// @notice Returns user stance to preferred decay period
    function decayPeriodVotes(address user) external view returns(uint256) {
        return _decayPeriod.votes[user].get(mooniswapFactoryGovernance.defaultDecayPeriod);
    }

    /// @notice Records `msg.senders`'s vote for fee
    function feeVote(uint256 vote) external {
        require(vote <= MooniswapConstants._MAX_FEE, "Fee vote is too high");

        _fee.updateVote(msg.sender, _fee.votes[msg.sender], Vote.init(vote), balanceOf(msg.sender), totalSupply(), mooniswapFactoryGovernance.defaultFee(), _emitFeeVoteUpdate);
    }

    /// @notice Records `msg.senders`'s vote for slippage fee
    function slippageFeeVote(uint256 vote) external {
        require(vote <= MooniswapConstants._MAX_SLIPPAGE_FEE, "Slippage fee vote is too high");

        _slippageFee.updateVote(msg.sender, _slippageFee.votes[msg.sender], Vote.init(vote), balanceOf(msg.sender), totalSupply(), mooniswapFactoryGovernance.defaultSlippageFee(), _emitSlippageFeeVoteUpdate);
    }

    /// @notice Records `msg.senders`'s vote for decay period
    function decayPeriodVote(uint256 vote) external {
        require(vote <= MooniswapConstants._MAX_DECAY_PERIOD, "Decay period vote is too high");
        require(vote >= MooniswapConstants._MIN_DECAY_PERIOD, "Decay period vote is too low");

        _decayPeriod.updateVote(msg.sender, _decayPeriod.votes[msg.sender], Vote.init(vote), balanceOf(msg.sender), totalSupply(), mooniswapFactoryGovernance.defaultDecayPeriod(), _emitDecayPeriodVoteUpdate);
    }

    /// @notice Retracts `msg.senders`'s vote for fee
    function discardFeeVote() external {
        _fee.updateVote(msg.sender, _fee.votes[msg.sender], Vote.init(), balanceOf(msg.sender), totalSupply(), mooniswapFactoryGovernance.defaultFee(), _emitFeeVoteUpdate);
    }

    /// @notice Retracts `msg.senders`'s vote for slippage fee
    function discardSlippageFeeVote() external {
        _slippageFee.updateVote(msg.sender, _slippageFee.votes[msg.sender], Vote.init(), balanceOf(msg.sender), totalSupply(), mooniswapFactoryGovernance.defaultSlippageFee(), _emitSlippageFeeVoteUpdate);
    }

    /// @notice Retracts `msg.senders`'s vote for decay period
    function discardDecayPeriodVote() external {
        _decayPeriod.updateVote(msg.sender, _decayPeriod.votes[msg.sender], Vote.init(), balanceOf(msg.sender), totalSupply(), mooniswapFactoryGovernance.defaultDecayPeriod(), _emitDecayPeriodVoteUpdate);
    }

    function _emitFeeVoteUpdate(address account, uint256 newFee, bool isDefault, uint256 newBalance) private {
        emit FeeVoteUpdate(account, newFee, isDefault, newBalance);
    }

    function _emitSlippageFeeVoteUpdate(address account, uint256 newSlippageFee, bool isDefault, uint256 newBalance) private {
        emit SlippageFeeVoteUpdate(account, newSlippageFee, isDefault, newBalance);
    }

    function _emitDecayPeriodVoteUpdate(address account, uint256 newDecayPeriod, bool isDefault, uint256 newBalance) private {
        emit DecayPeriodVoteUpdate(account, newDecayPeriod, isDefault, newBalance);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if (from == to) {
            // ignore transfers to self
            return;
        }

        IMooniswapFactoryGovernance _mooniswapFactoryGovernance = mooniswapFactoryGovernance;
        bool updateFrom = !(from == address(0) || _mooniswapFactoryGovernance.isFeeCollector(from));
        bool updateTo = !(to == address(0) || _mooniswapFactoryGovernance.isFeeCollector(to));

        if (!updateFrom && !updateTo) {
            // mint to feeReceiver or burn from feeReceiver
            return;
        }

        uint256 balanceFrom = (from != address(0)) ? balanceOf(from) : 0;
        uint256 balanceTo = (to != address(0)) ? balanceOf(to) : 0;
        uint256 newTotalSupply = totalSupply()
            .add(from == address(0) ? amount : 0)
            .sub(to == address(0) ? amount : 0);

        ParamsHelper memory params = ParamsHelper({
            from: from,
            to: to,
            updateFrom: updateFrom,
            updateTo: updateTo,
            amount: amount,
            balanceFrom: balanceFrom,
            balanceTo: balanceTo,
            newTotalSupply: newTotalSupply
        });

        (uint256 defaultFee, uint256 defaultSlippageFee, uint256 defaultDecayPeriod) = _mooniswapFactoryGovernance.defaults();

        _updateOnTransfer(params, defaultFee, _emitFeeVoteUpdate, _fee);
        _updateOnTransfer(params, defaultSlippageFee, _emitSlippageFeeVoteUpdate, _slippageFee);
        _updateOnTransfer(params, defaultDecayPeriod, _emitDecayPeriodVoteUpdate, _decayPeriod);
    }

    struct ParamsHelper {
        address from;
        address to;
        bool updateFrom;
        bool updateTo;
        uint256 amount;
        uint256 balanceFrom;
        uint256 balanceTo;
        uint256 newTotalSupply;
    }

    function _updateOnTransfer(
        ParamsHelper memory params,
        uint256 defaultValue,
        function(address, uint256, bool, uint256) internal emitEvent,
        LiquidVoting.Data storage votingData
    ) private {
        Vote.Data memory voteFrom = votingData.votes[params.from];
        Vote.Data memory voteTo = votingData.votes[params.to];

        if (voteFrom.isDefault() && voteTo.isDefault() && params.updateFrom && params.updateTo) {
            emitEvent(params.from, voteFrom.get(defaultValue), true, params.balanceFrom.sub(params.amount));
            emitEvent(params.to, voteTo.get(defaultValue), true, params.balanceTo.add(params.amount));
            return;
        }

        if (params.updateFrom) {
            votingData.updateBalance(params.from, voteFrom, params.balanceFrom, params.balanceFrom.sub(params.amount), params.newTotalSupply, defaultValue, emitEvent);
        }

        if (params.updateTo) {
            votingData.updateBalance(params.to, voteTo, params.balanceTo, params.balanceTo.add(params.amount), params.newTotalSupply, defaultValue, emitEvent);
        }
    }
}

/// @title 1inch Mooniswap pool
contract Mooniswap is MooniswapGovernance {
    using Sqrt for uint256;
    using SafeMath for uint256;
    using UniERC20 for IERC20;
    using VirtualBalance for VirtualBalance.Data;

    struct Balances {
        uint256 src;
        uint256 dst;
    }

    struct SwapVolumes {
        uint128 confirmed;
        uint128 result;
    }

    struct Fees {
        uint256 fee;
        uint256 slippageFee;
    }

    event Error(string reason);

    event Deposited(
        address indexed sender,
        address indexed receiver,
        uint256 share,
        uint256 token0Amount,
        uint256 token1Amount
    );

    event Withdrawn(
        address indexed sender,
        address indexed receiver,
        uint256 share,
        uint256 token0Amount,
        uint256 token1Amount
    );

    event Swapped(
        address indexed sender,
        address indexed receiver,
        address indexed srcToken,
        address dstToken,
        uint256 amount,
        uint256 result,
        uint256 srcAdditionBalance,
        uint256 dstRemovalBalance,
        address referral
    );

    event Sync(
        uint256 srcBalance,
        uint256 dstBalance,
        uint256 fee,
        uint256 slippageFee,
        uint256 referralShare,
        uint256 governanceShare
    );

    uint256 private constant _BASE_SUPPLY = 1000;  // Total supply on first deposit

    IERC20 public immutable token0;
    IERC20 public immutable token1;
    mapping(IERC20 => SwapVolumes) public volumes;
    mapping(IERC20 => VirtualBalance.Data) public virtualBalancesForAddition;
    mapping(IERC20 => VirtualBalance.Data) public virtualBalancesForRemoval;

    modifier whenNotShutdown {
        require(mooniswapFactoryGovernance.isActive(), "Mooniswap: factory shutdown");
        _;
    }

    constructor(
        IERC20 _token0,
        IERC20 _token1,
        string memory name,
        string memory symbol,
        IMooniswapFactoryGovernance _mooniswapFactoryGovernance
    )
        public
        ERC20(name, symbol)
        MooniswapGovernance(_mooniswapFactoryGovernance)
    {
        require(bytes(name).length > 0, "Mooniswap: name is empty");
        require(bytes(symbol).length > 0, "Mooniswap: symbol is empty");
        require(_token0 != _token1, "Mooniswap: duplicate tokens");
        token0 = _token0;
        token1 = _token1;
    }

    /// @notice Returns pair of tokens as [token0, token1]
    function getTokens() external view returns(IERC20[] memory tokens) {
        tokens = new IERC20[](2);
        tokens[0] = token0;
        tokens[1] = token1;
    }

    /// @notice Same as token0 or token1
    function tokens(uint256 i) external view returns(IERC20) {
        if (i == 0) {
            return token0;
        } else if (i == 1) {
            return token1;
        } else {
            revert("Pool has two tokens");
        }
    }

    /// @notice Returns actual addition balance
    function getBalanceForAddition(IERC20 token) public view returns(uint256) {
        uint256 balance = token.uniBalanceOf(address(this));
        return Math.max(virtualBalancesForAddition[token].current(decayPeriod(), balance), balance);
    }

    /// @notice Returns actual removal balance
    function getBalanceForRemoval(IERC20 token) public view returns(uint256) {
        uint256 balance = token.uniBalanceOf(address(this));
        return Math.min(virtualBalancesForRemoval[token].current(decayPeriod(), balance), balance);
    }

    /// @notice Returns how many `dst` tokens will be returned for `amount` of `src` tokens
    function getReturn(IERC20 src, IERC20 dst, uint256 amount) external view returns(uint256) {
        return _getReturn(src, dst, amount, getBalanceForAddition(src), getBalanceForRemoval(dst), fee(), slippageFee());
    }

    /// @notice Same as `depositFor` but for `msg.sender`
    function deposit(uint256[2] memory maxAmounts, uint256[2] memory minAmounts) external payable returns(uint256 fairSupply, uint256[2] memory receivedAmounts) {
        return depositFor(maxAmounts, minAmounts, msg.sender);
    }

    /// @notice Deposits from `minAmounts` to `maxAmounts` tokens to the pool
    /// @param maxAmounts Maximum allowed amounts sender is ready to deposit
    /// @param minAmounts Minimum allowed amounts sender is ready to deposit
    /// @param target Address that receives LP tokens
    /// @return fairSupply Amount of LP tokens minted
    /// @return receivedAmounts Actual amount somewhere in allowed boundaries
    function depositFor(uint256[2] memory maxAmounts, uint256[2] memory minAmounts, address target) public payable nonReentrant returns(uint256 fairSupply, uint256[2] memory receivedAmounts) {
        IERC20[2] memory _tokens = [token0, token1];
        require(msg.value == (_tokens[0].isETH() ? maxAmounts[0] : (_tokens[1].isETH() ? maxAmounts[1] : 0)), "Mooniswap: wrong value usage");

        uint256 totalSupply = totalSupply();

        if (totalSupply == 0) {
            fairSupply = _BASE_SUPPLY.mul(99);
            _mint(address(this), _BASE_SUPPLY); // Donate up to 1%

            for (uint i = 0; i < maxAmounts.length; i++) {
                fairSupply = Math.max(fairSupply, maxAmounts[i]);

                require(maxAmounts[i] > 0, "Mooniswap: amount is zero");
                require(maxAmounts[i] >= minAmounts[i], "Mooniswap: minAmount not reached");

                _tokens[i].uniTransferFrom(msg.sender, address(this), maxAmounts[i]);
                receivedAmounts[i] = maxAmounts[i];
            }
        }
        else {
            uint256[2] memory realBalances;
            for (uint i = 0; i < realBalances.length; i++) {
                realBalances[i] = _tokens[i].uniBalanceOf(address(this)).sub(_tokens[i].isETH() ? msg.value : 0);
            }

            // Pre-compute fair supply
            fairSupply = type(uint256).max;
            for (uint i = 0; i < maxAmounts.length; i++) {
                fairSupply = Math.min(fairSupply, totalSupply.mul(maxAmounts[i]).div(realBalances[i]));
            }

            uint256 fairSupplyCached = fairSupply;

            for (uint i = 0; i < maxAmounts.length; i++) {
                require(maxAmounts[i] > 0, "Mooniswap: amount is zero");
                uint256 amount = realBalances[i].mul(fairSupplyCached).add(totalSupply - 1).div(totalSupply);
                require(amount >= minAmounts[i], "Mooniswap: minAmount not reached");

                _tokens[i].uniTransferFrom(msg.sender, address(this), amount);
                receivedAmounts[i] = _tokens[i].uniBalanceOf(address(this)).sub(realBalances[i]);
                fairSupply = Math.min(fairSupply, totalSupply.mul(receivedAmounts[i]).div(realBalances[i]));
            }

            uint256 _decayPeriod = decayPeriod();  // gas savings
            for (uint i = 0; i < maxAmounts.length; i++) {
                virtualBalancesForRemoval[_tokens[i]].scale(_decayPeriod, realBalances[i], totalSupply.add(fairSupply), totalSupply);
                virtualBalancesForAddition[_tokens[i]].scale(_decayPeriod, realBalances[i], totalSupply.add(fairSupply), totalSupply);
            }
        }

        require(fairSupply > 0, "Mooniswap: result is not enough");
        _mint(target, fairSupply);

        emit Deposited(msg.sender, target, fairSupply, receivedAmounts[0], receivedAmounts[1]);
    }

    /// @notice Same as `withdrawFor` but for `msg.sender`
    function withdraw(uint256 amount, uint256[] memory minReturns) external returns(uint256[2] memory withdrawnAmounts) {
        return withdrawFor(amount, minReturns, msg.sender);
    }

    /// @notice Withdraws funds from the pool
    /// @param amount Amount of LP tokens to withdraw
    /// @param minReturns Minimum amounts sender is ready to receive
    /// @param target Address that receives funds
    /// @return withdrawnAmounts Actual amount that were withdrawn
    function withdrawFor(uint256 amount, uint256[] memory minReturns, address payable target) public nonReentrant returns(uint256[2] memory withdrawnAmounts) {
        IERC20[2] memory _tokens = [token0, token1];

        uint256 totalSupply = totalSupply();
        uint256 _decayPeriod = decayPeriod();  // gas savings
        _burn(msg.sender, amount);

        for (uint i = 0; i < _tokens.length; i++) {
            IERC20 token = _tokens[i];

            uint256 preBalance = token.uniBalanceOf(address(this));
            uint256 value = preBalance.mul(amount).div(totalSupply);
            token.uniTransfer(target, value);
            withdrawnAmounts[i] = value;
            require(i >= minReturns.length || value >= minReturns[i], "Mooniswap: result is not enough");

            virtualBalancesForAddition[token].scale(_decayPeriod, preBalance, totalSupply.sub(amount), totalSupply);
            virtualBalancesForRemoval[token].scale(_decayPeriod, preBalance, totalSupply.sub(amount), totalSupply);
        }

        emit Withdrawn(msg.sender, target, amount, withdrawnAmounts[0], withdrawnAmounts[1]);
    }

    /// @notice Same as `swapFor` but for `msg.sender`
    function swap(IERC20 src, IERC20 dst, uint256 amount, uint256 minReturn, address referral) external payable returns(uint256 result) {
        return swapFor(src, dst, amount, minReturn, referral, msg.sender);
    }

    /// @notice Swaps specified amount of source tokens to destination tokens
    /// @param src Source token
    /// @param dst Destination token
    /// @param amount Amount of source tokens to swap
    /// @param minReturn Minimum amounts sender is ready to receive
    /// @param referral Swap referral
    /// @param receiver Address that receives funds
    /// @return result Amount of `dst` tokens that were transferred to `receiver`
    function swapFor(IERC20 src, IERC20 dst, uint256 amount, uint256 minReturn, address referral, address payable receiver) public payable nonReentrant whenNotShutdown returns(uint256 result) {
        require(msg.value == (src.isETH() ? amount : 0), "Mooniswap: wrong value usage");

        Balances memory balances = Balances({
            src: src.uniBalanceOf(address(this)).sub(src.isETH() ? msg.value : 0),
            dst: dst.uniBalanceOf(address(this))
        });
        uint256 confirmed;
        Balances memory virtualBalances;
        Fees memory fees = Fees({
            fee: fee(),
            slippageFee: slippageFee()
        });
        (confirmed, result, virtualBalances) = _doTransfers(src, dst, amount, minReturn, receiver, balances, fees);
        emit Swapped(msg.sender, receiver, address(src), address(dst), confirmed, result, virtualBalances.src, virtualBalances.dst, referral);
        _mintRewards(confirmed, result, referral, balances, fees);

        // Overflow of uint128 is desired
        volumes[src].confirmed += uint128(confirmed);
        volumes[src].result += uint128(result);
    }

    function _doTransfers(IERC20 src, IERC20 dst, uint256 amount, uint256 minReturn, address payable receiver, Balances memory balances, Fees memory fees)
        private returns(uint256 confirmed, uint256 result, Balances memory virtualBalances)
    {
        uint256 _decayPeriod = decayPeriod();
        virtualBalances.src = virtualBalancesForAddition[src].current(_decayPeriod, balances.src);
        virtualBalances.src = Math.max(virtualBalances.src, balances.src);
        virtualBalances.dst = virtualBalancesForRemoval[dst].current(_decayPeriod, balances.dst);
        virtualBalances.dst = Math.min(virtualBalances.dst, balances.dst);
        src.uniTransferFrom(msg.sender, address(this), amount);
        confirmed = src.uniBalanceOf(address(this)).sub(balances.src);
        result = _getReturn(src, dst, confirmed, virtualBalances.src, virtualBalances.dst, fees.fee, fees.slippageFee);
        require(result > 0 && result >= minReturn, "Mooniswap: return is not enough");
        dst.uniTransfer(receiver, result);

        // Update virtual balances to the same direction only at imbalanced state
        if (virtualBalances.src != balances.src) {
            virtualBalancesForAddition[src].set(virtualBalances.src.add(confirmed));
        }
        if (virtualBalances.dst != balances.dst) {
            virtualBalancesForRemoval[dst].set(virtualBalances.dst.sub(result));
        }
        // Update virtual balances to the opposite direction
        virtualBalancesForRemoval[src].update(_decayPeriod, balances.src);
        virtualBalancesForAddition[dst].update(_decayPeriod, balances.dst);
    }

    function _mintRewards(uint256 confirmed, uint256 result, address referral, Balances memory balances, Fees memory fees) private {
        (uint256 referralShare, uint256 governanceShare, address govWallet, address feeCollector) = mooniswapFactoryGovernance.shareParameters();

        uint256 refReward;
        uint256 govReward;

        uint256 invariantRatio = uint256(1e36);
        invariantRatio = invariantRatio.mul(balances.src.add(confirmed)).div(balances.src);
        invariantRatio = invariantRatio.mul(balances.dst.sub(result)).div(balances.dst);
        if (invariantRatio > 1e36) {
            // calculate share only if invariant increased
            invariantRatio = invariantRatio.sqrt();
            uint256 invIncrease = totalSupply().mul(invariantRatio.sub(1e18)).div(invariantRatio);

            refReward = (referral != address(0)) ? invIncrease.mul(referralShare).div(MooniswapConstants._FEE_DENOMINATOR) : 0;
            govReward = (govWallet != address(0)) ? invIncrease.mul(governanceShare).div(MooniswapConstants._FEE_DENOMINATOR) : 0;

            if (feeCollector == address(0)) {
                if (refReward > 0) {
                    _mint(referral, refReward);
                }
                if (govReward > 0) {
                    _mint(govWallet, govReward);
                }
            }
            else if (refReward > 0 || govReward > 0) {
                uint256 len = (refReward > 0 ? 1 : 0) + (govReward > 0 ? 1 : 0);
                address[] memory wallets = new address[](len);
                uint256[] memory rewards = new uint256[](len);

                wallets[0] = referral;
                rewards[0] = refReward;
                if (govReward > 0) {
                    wallets[len - 1] = govWallet;
                    rewards[len - 1] = govReward;
                }

                try IFeeCollector(feeCollector).updateRewards(wallets, rewards) {
                    _mint(feeCollector, refReward.add(govReward));
                }
                catch {
                    emit Error("updateRewards() failed");
                }
            }
        }

        emit Sync(balances.src, balances.dst, fees.fee, fees.slippageFee, refReward, govReward);
    }

    /*
        spot_ret = dx * y / x
        uni_ret = dx * y / (x + dx)
        slippage = (spot_ret - uni_ret) / spot_ret
        slippage = dx * dx * y / (x * (x + dx)) / (dx * y / x)
        slippage = dx / (x + dx)
        ret = uni_ret * (1 - slip_fee * slippage)
        ret = dx * y / (x + dx) * (1 - slip_fee * dx / (x + dx))
        ret = dx * y / (x + dx) * (x + dx - slip_fee * dx) / (x + dx)

        x = amount * denominator
        dx = amount * (denominator - fee)
    */
    function _getReturn(IERC20 src, IERC20 dst, uint256 amount, uint256 srcBalance, uint256 dstBalance, uint256 fee, uint256 slippageFee) internal view returns(uint256) {
        if (src > dst) {
            (src, dst) = (dst, src);
        }
        if (amount > 0 && src == token0 && dst == token1) {
            uint256 taxedAmount = amount.sub(amount.mul(fee).div(MooniswapConstants._FEE_DENOMINATOR));
            uint256 srcBalancePlusTaxedAmount = srcBalance.add(taxedAmount);
            uint256 ret = taxedAmount.mul(dstBalance).div(srcBalancePlusTaxedAmount);
            uint256 feeNumerator = MooniswapConstants._FEE_DENOMINATOR.mul(srcBalancePlusTaxedAmount).sub(slippageFee.mul(taxedAmount));
            uint256 feeDenominator = MooniswapConstants._FEE_DENOMINATOR.mul(srcBalancePlusTaxedAmount);
            return ret.mul(feeNumerator).div(feeDenominator);
        }
    }

    /// @notice Allows contract owner to withdraw funds that was send to contract by mistake
    function rescueFunds(IERC20 token, uint256 amount) external nonReentrant onlyOwner {
        uint256 balance0 = token0.uniBalanceOf(address(this));
        uint256 balance1 = token1.uniBalanceOf(address(this));

        token.uniTransfer(msg.sender, amount);

        require(token0.uniBalanceOf(address(this)) >= balance0, "Mooniswap: access denied");
        require(token1.uniBalanceOf(address(this)) >= balance1, "Mooniswap: access denied");
        require(balanceOf(address(this)) >= _BASE_SUPPLY, "Mooniswap: access denied");
    }
}

/// @title Extends `IMooniswapFactoryGovernance` with information about pools
interface IMooniswapFactory is IMooniswapFactoryGovernance {
    /// @notice returns a pool for tokens pair. Zero address result means that pool doesn't exist yet
    function pools(IERC20 token0, IERC20 token1) external view returns (Mooniswap);
    /// @notice True if address is currently listed as a moonswap pool. Otherwise, false
    function isPool(Mooniswap mooniswap) external view returns (bool);
}

/// @title Base contract for maintaining tokens whitelist
abstract contract Converter is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using UniERC20 for IERC20;
    using VirtualBalance for VirtualBalance.Data;

    uint256 private constant _ONE = 1e18;
    uint256 private constant _MAX_SPREAD = 0.01e18;
    uint256 private constant _MAX_LIQUIDITY_SHARE = 100;

    IERC20 public immutable inchToken;
    IMooniswapFactory public immutable mooniswapFactory;
    mapping(IERC20 => bool) public pathWhitelist;

    constructor (IERC20 _inchToken, IMooniswapFactory _mooniswapFactory) public {
        inchToken = _inchToken;
        mooniswapFactory = _mooniswapFactory;
    }

    receive() external payable {
        // solhint-disable-next-line avoid-tx-origin
        require(msg.sender != tx.origin, "ETH transfer forbidden");
    }

    modifier validSpread(Mooniswap mooniswap) {
        require(_validateSpread(mooniswap), "Spread is too high");

        _;
    }

    modifier validPool(Mooniswap mooniswap) {
        require(mooniswapFactory.isPool(mooniswap), "Invalid mooniswap");

        _;
    }

    modifier validPath(IERC20[] memory path) {
        require(path.length > 0, "Min path length is 1");
        require(path.length < 5, "Max path length is 4");
        require(path[path.length - 1] == inchToken, "Should swap to target token");

        for (uint256 i = 1; i + 1 < path.length; i += 1) {
            require(pathWhitelist[path[i]], "Token is not whitelisted");
        }

        _;
    }

    function updatePathWhitelist(IERC20 token, bool whitelisted) external onlyOwner {
        pathWhitelist[token] = whitelisted;
    }

    function _validateSpread(Mooniswap mooniswap) internal view returns(bool) {
        IERC20[] memory tokens = mooniswap.getTokens();

        uint256 buyPrice;
        uint256 sellPrice;
        uint256 spotPrice;
        {
            uint256 token0Balance = tokens[0].uniBalanceOf(address(mooniswap));
            uint256 token1Balance = tokens[1].uniBalanceOf(address(mooniswap));
            uint256 decayPeriod = mooniswap.decayPeriod();
            VirtualBalance.Data memory vb;
            (vb.balance, vb.time) = mooniswap.virtualBalancesForAddition(tokens[0]);
            uint256 token0BalanceForAddition = Math.max(vb.current(decayPeriod, token0Balance), token0Balance);
            (vb.balance, vb.time) = mooniswap.virtualBalancesForAddition(tokens[1]);
            uint256 token1BalanceForAddition = Math.max(vb.current(decayPeriod, token1Balance), token1Balance);
            (vb.balance, vb.time) = mooniswap.virtualBalancesForRemoval(tokens[0]);
            uint256 token0BalanceForRemoval = Math.min(vb.current(decayPeriod, token0Balance), token0Balance);
            (vb.balance, vb.time) = mooniswap.virtualBalancesForRemoval(tokens[1]);
            uint256 token1BalanceForRemoval = Math.min(vb.current(decayPeriod, token1Balance), token1Balance);

            buyPrice = _ONE.mul(token1BalanceForAddition).div(token0BalanceForRemoval);
            sellPrice = _ONE.mul(token1BalanceForRemoval).div(token0BalanceForAddition);
            spotPrice = _ONE.mul(token1Balance).div(token0Balance);
        }

        return buyPrice.sub(sellPrice).mul(_ONE) < _MAX_SPREAD.mul(spotPrice);
    }

    function _maxAmountForSwap(IERC20[] memory path, uint256 amount) internal view returns(uint256 srcAmount, uint256 dstAmount) {
        srcAmount = amount;
        dstAmount = amount;
        uint256 pathLength = path.length;

        for (uint256 i = 0; i + 1 < pathLength; i += 1) {
            Mooniswap mooniswap = mooniswapFactory.pools(path[i], path[i+1]);
            uint256 maxCurStepAmount = path[i].uniBalanceOf(address(mooniswap)).div(_MAX_LIQUIDITY_SHARE);
            if (maxCurStepAmount < dstAmount) {
                srcAmount = srcAmount.mul(maxCurStepAmount).div(dstAmount);
                dstAmount = maxCurStepAmount;
            }
            dstAmount = mooniswap.getReturn(path[i], path[i+1], dstAmount);
        }
    }

    function _swap(IERC20[] memory path, uint256 initialAmount, address payable destination) internal returns(uint256 amount)
    {
        amount = initialAmount;

        for (uint256 i = 0; i + 1 < path.length; i += 1) {
            Mooniswap mooniswap = mooniswapFactory.pools(path[i], path[i+1]);

            require(_validateSpread(mooniswap), "Spread is too high");

            uint256 value = amount;
            if (!path[i].isETH()) {
                path[i].safeApprove(address(mooniswap), amount);
                value = 0;
            }

            if (i + 2 < path.length) {
                amount = mooniswap.swap{value: value}(path[i], path[i+1], amount, 0, address(0));
            }
            else {
                amount = mooniswap.swapFor{value: value}(path[i], path[i+1], amount, 0, address(0), destination);
            }
        }

        if (path.length == 1) {
            path[0].transfer(destination, amount);
        }
    }
}

/// @title Referral fee collector
// SWC-107-Reentrancy: L11
contract ReferralFeeReceiver is IFeeCollector, Converter, ReentrancyGuard {
    using UniERC20 for IERC20;

    struct UserInfo {
        uint256 balance;
        mapping(IERC20 => mapping(uint256 => uint256)) share;
        mapping(IERC20 => uint256) firstUnprocessedEpoch;
    }

    struct EpochBalance {
        uint256 totalSupply;
        uint256 token0Balance;
        uint256 token1Balance;
        uint256 inchBalance;
    }

    struct TokenInfo {
        mapping(uint256 => EpochBalance) epochBalance;
        uint256 firstUnprocessedEpoch;
        uint256 currentEpoch;
    }

    mapping(address => UserInfo) public userInfo;
    mapping(IERC20 => TokenInfo) public tokenInfo;

    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 _inchToken, IMooniswapFactory _mooniswapFactory) public Converter(_inchToken, _mooniswapFactory) {}

    /// @inheritdoc IFeeCollector
    function updateRewards(address[] calldata receivers, uint256[] calldata amounts) external override {
        for (uint i = 0; i < receivers.length; i++) {
            updateReward(receivers[i], amounts[i]);
        }
    }

    /// @inheritdoc IFeeCollector
    function updateReward(address referral, uint256 amount) public override {
        Mooniswap mooniswap = Mooniswap(msg.sender);
        TokenInfo storage token = tokenInfo[mooniswap];
        UserInfo storage user = userInfo[referral];
        uint256 currentEpoch = token.currentEpoch;

        // Add new reward to current epoch
        user.share[mooniswap][currentEpoch] = user.share[mooniswap][currentEpoch].add(amount);
        token.epochBalance[currentEpoch].totalSupply = token.epochBalance[currentEpoch].totalSupply.add(amount);

        // Collect all processed epochs and advance user token epoch
        _collectProcessedEpochs(user, token, mooniswap, currentEpoch);
    }

    /// @notice Freezes current epoch and creates new as an active one
    function freezeEpoch(Mooniswap mooniswap) external nonReentrant validPool(mooniswap) validSpread(mooniswap) {
        TokenInfo storage token = tokenInfo[mooniswap];
        uint256 currentEpoch = token.currentEpoch;
        require(token.firstUnprocessedEpoch == currentEpoch, "Previous epoch is not finalized");

        IERC20[] memory tokens = mooniswap.getTokens();
        uint256 token0Balance = tokens[0].uniBalanceOf(address(this));
        uint256 token1Balance = tokens[1].uniBalanceOf(address(this));
        mooniswap.withdraw(mooniswap.balanceOf(address(this)), new uint256[](0));
        token.epochBalance[currentEpoch].token0Balance = tokens[0].uniBalanceOf(address(this)).sub(token0Balance);
        token.epochBalance[currentEpoch].token1Balance = tokens[1].uniBalanceOf(address(this)).sub(token1Balance);
        token.currentEpoch = currentEpoch.add(1);
    }

    /// @notice Perform chain swap described by `path`. First element of `path` should match either token of the `mooniswap`.
    /// The last token in chain should always be `1INCH`
    function trade(Mooniswap mooniswap, IERC20[] memory path) external nonReentrant validPool(mooniswap) validPath(path) {
        TokenInfo storage token = tokenInfo[mooniswap];
        uint256 firstUnprocessedEpoch = token.firstUnprocessedEpoch;
        EpochBalance storage epochBalance = token.epochBalance[firstUnprocessedEpoch];
        require(firstUnprocessedEpoch.add(1) == token.currentEpoch, "Prev epoch already finalized");

        IERC20[] memory tokens = mooniswap.getTokens();
        uint256 availableBalance;
        if (path[0] == tokens[0]) {
            availableBalance = epochBalance.token0Balance;
        } else if (path[0] == tokens[1]) {
            availableBalance = epochBalance.token1Balance;
        } else {
            revert("Invalid first token");
        }

        (uint256 amount, uint256 returnAmount) = _maxAmountForSwap(path, availableBalance);
        if (returnAmount == 0) {
            // get rid of dust
            if (availableBalance > 0) {
                require(availableBalance == amount, "availableBalance is not dust");
                for (uint256 i = 0; i + 1 < path.length; i += 1) {
                    Mooniswap _mooniswap = mooniswapFactory.pools(path[i], path[i+1]);
                    require(_validateSpread(_mooniswap), "Spread is too high");
                }
                if (path[0].isETH()) {
                    tx.origin.transfer(availableBalance);  // solhint-disable-line avoid-tx-origin
                } else {
                    path[0].safeTransfer(address(mooniswap), availableBalance);
                }
            }
        } else {
            uint256 receivedAmount = _swap(path, amount, payable(address(this)));
            epochBalance.inchBalance = epochBalance.inchBalance.add(receivedAmount);
        }

        if (path[0] == tokens[0]) {
            epochBalance.token0Balance = epochBalance.token0Balance.sub(amount);
        } else {
            epochBalance.token1Balance = epochBalance.token1Balance.sub(amount);
        }

        if (epochBalance.token0Balance == 0 && epochBalance.token1Balance == 0) {
            token.firstUnprocessedEpoch = firstUnprocessedEpoch.add(1);
        }
    }

    /// @notice Collects `msg.sender`'s tokens from pools and transfers them to him
    function claim(Mooniswap[] memory pools) external {
        UserInfo storage user = userInfo[msg.sender];
        for (uint256 i = 0; i < pools.length; ++i) {
            Mooniswap mooniswap = pools[i];
            TokenInfo storage token = tokenInfo[mooniswap];
            _collectProcessedEpochs(user, token, mooniswap, token.currentEpoch);
        }

        uint256 balance = user.balance;
        if (balance > 1) {
            // Avoid erasing storage to decrease gas footprint for referral payments
            user.balance = 1;
            inchToken.transfer(msg.sender, balance - 1);
        }
    }

    /// @notice Collects current epoch `msg.sender`'s tokens from pool and transfers them to him
    function claimCurrentEpoch(Mooniswap mooniswap) external nonReentrant validPool(mooniswap) {
        TokenInfo storage token = tokenInfo[mooniswap];
        UserInfo storage user = userInfo[msg.sender];
        uint256 currentEpoch = token.currentEpoch;
        uint256 balance = user.share[mooniswap][currentEpoch];
        if (balance > 0) {
            user.share[mooniswap][currentEpoch] = 0;
            token.epochBalance[currentEpoch].totalSupply = token.epochBalance[currentEpoch].totalSupply.sub(balance);
            mooniswap.transfer(msg.sender, balance);
        }
    }

    /// @notice Collects frozen epoch `msg.sender`'s tokens from pool and transfers them to him
    function claimFrozenEpoch(Mooniswap mooniswap) external nonReentrant validPool(mooniswap) {
        TokenInfo storage token = tokenInfo[mooniswap];
        UserInfo storage user = userInfo[msg.sender];
        uint256 firstUnprocessedEpoch = token.firstUnprocessedEpoch;
        uint256 currentEpoch = token.currentEpoch;

        require(firstUnprocessedEpoch.add(1) == currentEpoch, "Epoch already finalized");
        require(user.firstUnprocessedEpoch[mooniswap] == firstUnprocessedEpoch, "Epoch funds already claimed");

        user.firstUnprocessedEpoch[mooniswap] = currentEpoch;
        uint256 share = user.share[mooniswap][firstUnprocessedEpoch];

        if (share > 0) {
            EpochBalance storage epochBalance = token.epochBalance[firstUnprocessedEpoch];
            uint256 totalSupply = epochBalance.totalSupply;
            user.share[mooniswap][firstUnprocessedEpoch] = 0;
            epochBalance.totalSupply = totalSupply.sub(share);

            IERC20[] memory tokens = mooniswap.getTokens();
            epochBalance.token0Balance = _transferTokenShare(tokens[0], epochBalance.token0Balance, share, totalSupply);
            epochBalance.token1Balance = _transferTokenShare(tokens[1], epochBalance.token1Balance, share, totalSupply);
            epochBalance.inchBalance = _transferTokenShare(inchToken, epochBalance.inchBalance, share, totalSupply);
        }
    }

    function _transferTokenShare(IERC20 token, uint256 balance, uint256 share, uint256 totalSupply) private returns(uint256 newBalance) {
        uint256 amount = balance.mul(share).div(totalSupply);
        if (amount > 0) {
            token.uniTransfer(msg.sender, amount);
        }
        return balance.sub(amount);
    }

    function _collectProcessedEpochs(UserInfo storage user, TokenInfo storage token, Mooniswap mooniswap, uint256 currentEpoch) private {
        uint256 userEpoch = user.firstUnprocessedEpoch[mooniswap];

        // Early return for the new users
        if (user.share[mooniswap][userEpoch] == 0) {
            user.firstUnprocessedEpoch[mooniswap] = currentEpoch;
            return;
        }

        uint256 tokenEpoch = token.firstUnprocessedEpoch;
        if (tokenEpoch <= userEpoch) {
            return;
        }
        uint256 epochCount = Math.min(2, tokenEpoch - userEpoch); // 0, 1 or 2 epochs

        // Claim 1 or 2 processed epochs for the user
        uint256 collected = _collectEpoch(user, token, mooniswap, userEpoch);
        if (epochCount > 1) {
            collected = collected.add(_collectEpoch(user, token, mooniswap, userEpoch + 1));
        }
        user.balance = user.balance.add(collected);

        // Update user token epoch counter
        bool emptySecondEpoch = user.share[mooniswap][userEpoch + 1] == 0;
        user.firstUnprocessedEpoch[mooniswap] = (epochCount == 2 || emptySecondEpoch) ? currentEpoch : userEpoch + 1;
    }

    function _collectEpoch(UserInfo storage user, TokenInfo storage token, Mooniswap mooniswap, uint256 epoch) private returns(uint256 collected) {
        uint256 share = user.share[mooniswap][epoch];
        if (share > 0) {
            uint256 inchBalance = token.epochBalance[epoch].inchBalance;
            uint256 totalSupply = token.epochBalance[epoch].totalSupply;

            collected = inchBalance.mul(share).div(totalSupply);

            user.share[mooniswap][epoch] = 0;
            token.epochBalance[epoch].totalSupply = totalSupply.sub(share);
            token.epochBalance[epoch].inchBalance = inchBalance.sub(collected);
        }
    }
}
