pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


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

// SPDX-License-Identifier: MIT
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */

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

library Transfers {
	using SafeERC20 for IERC20;

	/**
	 * @dev Retrieves a given ERC-20 token balance for the current contract.
	 * @param _token An ERC-20 compatible token address.
	 * @return _balance The current contract balance of the given ERC-20 token.
	 */
	function _getBalance(address _token) internal view returns (uint256 _balance)
	{
		return IERC20(_token).balanceOf(address(this));
	}

	/**
	 * @dev Allows a spender to access a given ERC-20 balance for the current contract.
	 * @param _token An ERC-20 compatible token address.
	 * @param _to The spender address.
	 * @param _amount The exact spending allowance amount.
	 */
	function _approveFunds(address _token, address _to, uint256 _amount) internal
	{
		uint256 _allowance = IERC20(_token).allowance(address(this), _to);
		if (_allowance > _amount) {
			IERC20(_token).safeDecreaseAllowance(_to, _allowance - _amount);
		}
		else
		if (_allowance < _amount) {
			IERC20(_token).safeIncreaseAllowance(_to, _amount - _allowance);
		}
	}

	/**
	 * @dev Transfer a given ERC-20 token amount into the current contract.
	 * @param _token An ERC-20 compatible token address.
	 * @param _from The source address.
	 * @param _amount The amount to be transferred.
	 */
	function _pullFunds(address _token, address _from, uint256 _amount) internal
	{
		if (_amount == 0) return;
		IERC20(_token).safeTransferFrom(_from, address(this), _amount);
	}

	/**
	 * @dev Transfer a given ERC-20 token amount from the current contract.
	 * @param _token An ERC-20 compatible token address.
	 * @param _to The target address.
	 * @param _amount The amount to be transferred.
	 */
	function _pushFunds(address _token, address _to, uint256 _amount) internal
	{
		if (_amount == 0) return;
		IERC20(_token).safeTransfer(_to, _amount);
	}
}

interface SoloMargin {
	function getMarketTokenAddress(uint256 _marketId) external view returns (address _token);
	function getNumMarkets() external view returns (uint256 _numMarkets);
	function operate(Account.Info[] memory _accounts, Actions.ActionArgs[] memory _actions) external;
}

library Account {
	struct Info {
		address owner;
		uint256 number;
	}
}

library Actions {
	enum ActionType { Deposit, Withdraw, Transfer, Buy, Sell, Trade, Liquidate, Vaporize, Call }

	struct ActionArgs {
		ActionType actionType;
		uint256 accountId;
		Types.AssetAmount amount;
		uint256 primaryMarketId;
		uint256 secondaryMarketId;
		address otherAddress;
		uint256 otherAccountId;
		bytes data;
	}
}

library Types {
	enum AssetDenomination { Wei, Par }
	enum AssetReference { Delta, Target }

	struct AssetAmount {
		bool sign;
		AssetDenomination denomination;
		AssetReference ref;
		uint256 value;
	}
}

library $ {
	enum Network { Mainnet, Ropsten, Rinkeby, Kovan, Goerli }

	Network constant NETWORK = Network.Mainnet;

	bool constant DEBUG = NETWORK != Network.Mainnet;

	function debug(string memory _message) internal
	{
		address _from = msg.sender;
		if (DEBUG) emit Debug(_from, _message);
	}

	function debug(string memory _message, uint256 _value) internal
	{
		address _from = msg.sender;
		if (DEBUG) emit Debug(_from, _message, _value);
	}

	function debug(string memory _message, address _address) internal
	{
		address _from = msg.sender;
		if (DEBUG) emit Debug(_from, _message, _address);
	}

	event Debug(address indexed _from, string _message);
	event Debug(address indexed _from, string _message, uint256 _value);
	event Debug(address indexed _from, string _message, address _address);

	address constant GRO =
		NETWORK == Network.Mainnet ? 0x09e64c2B61a5f1690Ee6fbeD9baf5D6990F8dFd0 :
		NETWORK == Network.Ropsten ? 0x5BaF82B5Eddd5d64E03509F0a7dBa4Cbf88CF455 :
		NETWORK == Network.Rinkeby ? 0x020e317e70B406E23dF059F3656F6fc419411401 :
		NETWORK == Network.Kovan ? 0xFcB74f30d8949650AA524d8bF496218a20ce2db4 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant DAI =
		NETWORK == Network.Mainnet ? 0x6B175474E89094C44Da98b954EedeAC495271d0F :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant USDC =
		NETWORK == Network.Mainnet ? 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant USDT =
		NETWORK == Network.Mainnet ? 0xdAC17F958D2ee523a2206206994597C13D831ec7 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant SUSD =
		NETWORK == Network.Mainnet ? 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant TUSD =
		NETWORK == Network.Mainnet ? 0x0000000000085d4780B73119b644AE5ecd22b376 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant BUSD =
		NETWORK == Network.Mainnet ? 0x4Fabb145d64652a948d72533023f6E7A623C7C53 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant WBTC =
		NETWORK == Network.Mainnet ? 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant WETH =
		NETWORK == Network.Mainnet ? 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 :
		NETWORK == Network.Ropsten ? 0xc778417E063141139Fce010982780140Aa0cD5Ab :
		NETWORK == Network.Rinkeby ? 0xc778417E063141139Fce010982780140Aa0cD5Ab :
		NETWORK == Network.Kovan ? 0xd0A1E359811322d97991E03f863a0C30C2cF029C :
		NETWORK == Network.Goerli ? 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6 :
		0x0000000000000000000000000000000000000000;

	address constant BAT =
		NETWORK == Network.Mainnet ? 0x0D8775F648430679A709E98d2b0Cb6250d2887EF :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant ENJ =
		NETWORK == Network.Mainnet ? 0xF629cBd94d3791C9250152BD8dfBDF380E2a3B9c :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant KNC =
		NETWORK == Network.Mainnet ? 0xdd974D5C2e2928deA5F71b9825b8b646686BD200 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant AAVE =
		NETWORK == Network.Mainnet ? 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant LEND =
		NETWORK == Network.Mainnet ? 0x80fB784B7eD66730e8b1DBd9820aFD29931aab03 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant LINK =
		NETWORK == Network.Mainnet ? 0x514910771AF9Ca656af840dff83E8264EcF986CA :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant MANA =
		NETWORK == Network.Mainnet ? 0x0F5D2fB29fb7d3CFeE444a200298f468908cC942 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant MKR =
		NETWORK == Network.Mainnet ? 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant REN =
		NETWORK == Network.Mainnet ? 0x408e41876cCCDC0F92210600ef50372656052a38 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant REP =
		NETWORK == Network.Mainnet ? 0x1985365e9f78359a9B6AD760e32412f4a445E862 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant SNX =
		NETWORK == Network.Mainnet ? 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant ZRX =
		NETWORK == Network.Mainnet ? 0xE41d2489571d322189246DaFA5ebDe1F4699F498 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant UNI =
		NETWORK == Network.Mainnet ? 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant YFI =
		NETWORK == Network.Mainnet ? 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aETH =
		NETWORK == Network.Mainnet ? 0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04 :
		NETWORK == Network.Ropsten ? 0x2433A1b6FcF156956599280C3Eb1863247CFE675 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xD483B49F2d55D2c53D32bE6efF735cB001880F79 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aDAI =
		NETWORK == Network.Mainnet ? 0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d :
		NETWORK == Network.Ropsten ? 0xcB1Fe6F440c49E9290c3eb7f158534c2dC374201 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x58AD4cB396411B691A9AAb6F74545b2C5217FE6a :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aUSDC =
		NETWORK == Network.Mainnet ? 0x9bA00D6856a4eDF4665BcA2C2309936572473B7E :
		NETWORK == Network.Ropsten ? 0x2dB6a31f973Ec26F5e17895f0741BB5965d5Ae15 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x02F626c6ccb6D2ebC071c068DC1f02Bf5693416a :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aSUSD =
		NETWORK == Network.Mainnet ? 0x625aE63000f46200499120B906716420bd059240 :
		NETWORK == Network.Ropsten ? 0x5D17e0ea2d886F865E40176D71dbc0b59a54d8c1 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aTUSD =
		NETWORK == Network.Mainnet ? 0x4DA9b813057D04BAef4e5800E36083717b4a0341 :
		NETWORK == Network.Ropsten ? 0x9265d51F5ABf1E23bE64418827859bc83ae70a57 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x4c76f1b48316489E8a3304Db21cdAeC271cF6eC3 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aUSDT =
		NETWORK == Network.Mainnet ? 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8 :
		NETWORK == Network.Ropsten ? 0x790744bC4257B4a0519a3C5649Ac1d16DDaFAE0D :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xA01bA9fB493b851F4Ac5093A324CB081A909C34B :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aBUSD =
		NETWORK == Network.Mainnet ? 0x6Ee0f7BB50a54AB5253dA0667B0Dc2ee526C30a8 :
		NETWORK == Network.Ropsten ? 0x81E065164bAC7203c3bFEB1a749F48a64383c6eE :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aBAT =
		NETWORK == Network.Mainnet ? 0xE1BA0FB44CCb0D11b80F92f4f8Ed94CA3fF51D00 :
		NETWORK == Network.Ropsten ? 0x0D0Ff1C81F2Fbc8cbafA8Df4bF668f5ba963Dab4 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x5ad67de6Fb697e92a7dE99d991F7CdB77EdF5F74 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aENJ =
		NETWORK == Network.Mainnet ? 0x712DB54daA836B53Ef1EcBb9c6ba3b9Efb073F40 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aKNC =
		NETWORK == Network.Mainnet ? 0x9D91BE44C06d373a8a226E1f3b146956083803eB :
		NETWORK == Network.Ropsten ? 0xCf6efd4528d27Df440fdd585a116D3c1fC5aDdEe :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xB08EC9EdB6BD7971220FEa04644174f3EbfbDe96 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aAAVE =
		NETWORK == Network.Mainnet ? 0xba3D9687Cf50fE253cd2e1cFeEdE1d6787344Ed5 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aLEND =
		// NETWORK == Network.Mainnet ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Ropsten ? 0x383261d0e287f0A641322AEB15E3da50147Dd36b :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xcBa131C7FB05fe3c9720375cD86C99773faAbF23 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aLINK =
		NETWORK == Network.Mainnet ? 0xA64BD6C70Cb9051F6A9ba1F163Fdc07E0DfB5F84 :
		NETWORK == Network.Ropsten ? 0x52fd99c15e6FFf8D4CF1B83b2263a501FDd78973 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xEC23855Ff01012E1823807CE19a790CeBc4A64dA :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aMANA =
		NETWORK == Network.Mainnet ? 0x6FCE4A401B6B80ACe52baAefE4421Bd188e76F6f :
		NETWORK == Network.Ropsten ? 0x8e96a4068da80F66ef1CFc7987f0F834c26106fa :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xe68204D69Cbfaf6124190EFa65ad9C591C0D48e4 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aMKR =
		NETWORK == Network.Mainnet ? 0x7deB5e830be29F91E298ba5FF1356BB7f8146998 :
		NETWORK == Network.Ropsten ? 0xEd6A5d671f7c55aa029cbAEa2e5E9A18E9d6a1CE :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xfB762B5BAb463f7F35610Ba65e2534993a1c09C6 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aREN =
		NETWORK == Network.Mainnet ? 0x69948cC03f478B95283F7dbf1CE764d0fc7EC54C :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aREP =
		NETWORK == Network.Mainnet ? 0x71010A9D003445aC60C4e6A7017c1E89A477B438 :
		NETWORK == Network.Ropsten ? 0xE4B92BcDB2f972e1ccc069D4dB33d5f6363738dE :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x0578469469Db1129271f4eb3EB9D97426506c44c :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aSNX =
		NETWORK == Network.Mainnet ? 0x328C4c80BC7aCa0834Db37e6600A6c49E12Da4DE :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xb4D480f963f4F685F1D51d2B6159D126658B1dA8 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aUNI =
		NETWORK == Network.Mainnet ? 0xB124541127A0A657f056D9Dd06188c4F1b0e5aab :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aWBTC =
		NETWORK == Network.Mainnet ? 0xFC4B8ED459e00e5400be803A9BB3954234FD50e3 :
		NETWORK == Network.Ropsten ? 0xA1c4dB01F8344eCb11219714706C82f0c0c64841 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0xCD5C52C7B30468D16771193C47eAFF43EFc47f5C :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aYFI =
		NETWORK == Network.Mainnet ? 0x12e51E77DAAA58aA0E9247db7510Ea4B46F9bEAd :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant aZRX =
		NETWORK == Network.Mainnet ? 0x6Fb0855c404E09c47C3fBCA25f08d4E41f9F062f :
		NETWORK == Network.Ropsten ? 0x5BDC773c9D3515a5e3Dd415428F92a90E8e63Ae4 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x0F456900c6bdFddfA27E1E4E4c84EB823a2eE13c :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant cDAI =
		NETWORK == Network.Mainnet ? 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643 :
		NETWORK == Network.Ropsten ? 0xdb5Ed4605C11822811a39F94314fDb8F0fb59A2C :
		NETWORK == Network.Rinkeby ? 0x6D7F0754FFeb405d23C51CE938289d4835bE3b14 :
		NETWORK == Network.Kovan ? 0xF0d0EB522cfa50B716B3b1604C4F0fA6f04376AD :
		NETWORK == Network.Goerli ? 0x822397d9a55d0fefd20F5c4bCaB33C5F65bd28Eb :
		0x0000000000000000000000000000000000000000;

	address constant cUSDC =
		NETWORK == Network.Mainnet ? 0x39AA39c021dfbaE8faC545936693aC917d5E7563 :
		NETWORK == Network.Ropsten ? 0x8aF93cae804cC220D1A608d4FA54D1b6ca5EB361 :
		NETWORK == Network.Rinkeby ? 0x5B281A6DdA0B271e91ae35DE655Ad301C976edb1 :
		NETWORK == Network.Kovan ? 0x4a92E71227D294F041BD82dd8f78591B75140d63 :
		NETWORK == Network.Goerli ? 0xCEC4a43eBB02f9B80916F1c718338169d6d5C1F0 :
		0x0000000000000000000000000000000000000000;

	address constant cUSDT =
		NETWORK == Network.Mainnet ? 0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9 :
		NETWORK == Network.Ropsten ? 0x135669c2dcBd63F639582b313883F101a4497F76 :
		NETWORK == Network.Rinkeby ? 0x2fB298BDbeF468638AD6653FF8376575ea41e768 :
		NETWORK == Network.Kovan ? 0x3f0A0EA2f86baE6362CF9799B523BA06647Da018 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant cETH =
		NETWORK == Network.Mainnet ? 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 :
		NETWORK == Network.Ropsten ? 0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3 :
		NETWORK == Network.Rinkeby ? 0xd6801a1DfFCd0a410336Ef88DeF4320D6DF1883e :
		NETWORK == Network.Kovan ? 0x41B5844f4680a8C38fBb695b7F9CFd1F64474a72 :
		NETWORK == Network.Goerli ? 0x20572e4c090f15667cF7378e16FaD2eA0e2f3EfF :
		0x0000000000000000000000000000000000000000;

	address constant cWBTC =
		NETWORK == Network.Mainnet ? 0xC11b1268C1A384e55C48c2391d8d480264A3A7F4 :
		NETWORK == Network.Ropsten ? 0x58145Bc5407D63dAF226e4870beeb744C588f149 :
		NETWORK == Network.Rinkeby ? 0x0014F450B8Ae7708593F4A46F8fa6E5D50620F96 :
		NETWORK == Network.Kovan ? 0xa1fAA15655B0e7b6B6470ED3d096390e6aD93Abb :
		NETWORK == Network.Goerli ? 0x6CE27497A64fFFb5517AA4aeE908b1E7EB63B9fF :
		0x0000000000000000000000000000000000000000;

	address constant cBAT =
		NETWORK == Network.Mainnet ? 0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E :
		NETWORK == Network.Ropsten ? 0x9E95c0b2412cE50C37a121622308e7a6177F819D :
		NETWORK == Network.Rinkeby ? 0xEBf1A11532b93a529b5bC942B4bAA98647913002 :
		NETWORK == Network.Kovan ? 0x4a77fAeE9650b09849Ff459eA1476eaB01606C7a :
		NETWORK == Network.Goerli ? 0xCCaF265E7492c0d9b7C2f0018bf6382Ba7f0148D :
		0x0000000000000000000000000000000000000000;

	address constant cZRX =
		NETWORK == Network.Mainnet ? 0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407 :
		NETWORK == Network.Ropsten ? 0x00e02a5200CE3D5b5743F5369Deb897946C88121 :
		NETWORK == Network.Rinkeby ? 0x52201ff1720134bBbBB2f6BC97Bf3715490EC19B :
		NETWORK == Network.Kovan ? 0xAf45ae737514C8427D373D50Cd979a242eC59e5a :
		NETWORK == Network.Goerli ? 0xA253295eC2157B8b69C44b2cb35360016DAa25b1 :
		0x0000000000000000000000000000000000000000;

	address constant cUNI =
		NETWORK == Network.Mainnet ? 0x35A18000230DA775CAc24873d00Ff85BccdeD550 :
		NETWORK == Network.Ropsten ? 0x22531F0f3a9c36Bfc3b04c4c60df5168A1cFCec3 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant cCOMP =
		NETWORK == Network.Mainnet ? 0x70e36f6BF80a52b3B46b3aF8e106CC0ed743E8e4 :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant COMP =
		NETWORK == Network.Mainnet ? 0xc00e94Cb662C3520282E6f5717214004A7f26888 :
		NETWORK == Network.Ropsten ? 0x1Fe16De955718CFAb7A44605458AB023838C2793 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x61460874a7196d6a22D1eE4922473664b3E95270 :
		NETWORK == Network.Goerli ? 0xe16C7165C8FeA64069802aE4c4c9C320783f2b6e :
		0x0000000000000000000000000000000000000000;

	address constant Aave_AAVE_LENDING_POOL_ADDRESSES_PROVIDER =
		NETWORK == Network.Mainnet ? 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8 :
		NETWORK == Network.Ropsten ? 0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant Aave_AAVE_LENDING_POOL =
		NETWORK == Network.Mainnet ? 0x398eC7346DcD622eDc5ae82352F02bE94C62d119 :
		NETWORK == Network.Ropsten ? 0x9E5C7835E4b13368fd628196C4f1c6cEc89673Fa :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x580D4Fdc4BF8f9b5ae2fb9225D584fED4AD5375c :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant Aave_AAVE_LENDING_POOL_CORE =
		NETWORK == Network.Mainnet ? 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3 :
		NETWORK == Network.Ropsten ? 0x4295Ee704716950A4dE7438086d6f0FBC0BA9472 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant Balancer_FACTORY =
		NETWORK == Network.Mainnet ? 0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Rinkeby ? 0x9C84391B443ea3a48788079a5f98e2EaD55c9309 :
		NETWORK == Network.Kovan ? 0x8f7F78080219d4066A8036ccD30D588B416a40DB :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant Compound_COMPTROLLER =
		NETWORK == Network.Mainnet ? 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B :
		NETWORK == Network.Ropsten ? 0x54188bBeDD7b68228fa89CbDDa5e3e930459C6c6 :
		NETWORK == Network.Rinkeby ? 0x2EAa9D77AE4D8f9cdD9FAAcd44016E746485bddb :
		NETWORK == Network.Kovan ? 0x5eAe89DC1C671724A672ff0630122ee834098657 :
		NETWORK == Network.Goerli ? 0x627EA49279FD0dE89186A58b8758aD02B6Be2867 :
		0x0000000000000000000000000000000000000000;

	address constant Dydx_SOLO_MARGIN =
		NETWORK == Network.Mainnet ? 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		NETWORK == Network.Kovan ? 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant Sushiswap_ROUTER02 =
		NETWORK == Network.Mainnet ? 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F :
		// NETWORK == Network.Ropsten ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Rinkeby ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Kovan ? 0x0000000000000000000000000000000000000000 :
		// NETWORK == Network.Goerli ? 0x0000000000000000000000000000000000000000 :
		0x0000000000000000000000000000000000000000;

	address constant UniswapV2_ROUTER02 =
		NETWORK == Network.Mainnet ? 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D :
		NETWORK == Network.Ropsten ? 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D :
		NETWORK == Network.Rinkeby ? 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D :
		NETWORK == Network.Kovan ? 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D :
		NETWORK == Network.Goerli ? 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D :
		0x0000000000000000000000000000000000000000;
}

/**
 * @dev This library abstracts the Dydx flash loan functionality. It has a
 *      standardized flash loan interface. See GFlashBorrower.sol,
 *      FlashLoans.sol, and AaveFlashLoanAbstraction.sol for further documentation.
 */
library DydxFlashLoanAbstraction {
	using SafeMath for uint256;

	/**
	 * @dev Estimates the flash loan fee given the reserve token and required amount.
	 * @param _token The ERC-20 token to flash borrow from.
	 * @param _netAmount The amount to be borrowed without considering repay fees.
	 * @param _feeAmount the expected fee to be payed in excees of the loan amount.
	 */
	function _estimateFlashLoanFee(address _token, uint256 _netAmount) internal pure returns (uint256 _feeAmount)
	{
		_token; _netAmount; // silences warnings
		return 2; // dydx has no fees, 2 wei is just a recommendation
	}

	/**
	 * @dev Retrieves the current market liquidity for a given reserve.
	 * @param _token The reserve token to flash borrow from.
	 * @return _liquidityAmount The reserve token available market liquidity.
	 */
	function _getFlashLoanLiquidity(address _token) internal view returns (uint256 _liquidityAmount)
	{
		address _solo = $.Dydx_SOLO_MARGIN;
		return IERC20(_token).balanceOf(_solo);
	}

	/**
	 * @dev Triggers a flash loan. The current contract will receive a call
	 *      back with the loan amount and should repay it, including fees,
	 *      before returning. See GFlashBorrow.sol.
	 * @param _token The reserve token to flash borrow from.
	 * @param _netAmount The amount to be borrowed without considering repay fees.
	 * @param _context Additional data to be passed to the call back.
	 * @return _success A boolean indicating whether or not the operation suceeded.
         */
	function _requestFlashLoan(address _token, uint256 _netAmount, bytes memory _context) internal returns (bool _success)
	{
		address _solo = $.Dydx_SOLO_MARGIN;
		uint256 _feeAmount = 2;
		uint256 _grossAmount = _netAmount.add(_feeAmount);
		// attempts to find the market id given a reserve token
		uint256 _marketId = uint256(-1);
		uint256 _numMarkets = SoloMargin(_solo).getNumMarkets();
		// SWC-128-DoS With Block Gas Limit: L64-70
		for (uint256 _i = 0; _i < _numMarkets; _i++) {
			address _address = SoloMargin(_solo).getMarketTokenAddress(_i);
			if (_address == _token) {
				_marketId = _i;
				break;
			}
		}
		if (_marketId == uint256(-1)) return false;
		// a flash loan on Dydx is achieved by the following sequence of
		// actions: withdrawal, user call back, and finally a deposit;
		// which is configured below
		Account.Info[] memory _accounts = new Account.Info[](1);
		_accounts[0] = Account.Info({ owner: address(this), number: 1 });
		Actions.ActionArgs[] memory _actions = new Actions.ActionArgs[](3);
		_actions[0] = Actions.ActionArgs({
			actionType: Actions.ActionType.Withdraw,
			accountId: 0,
			amount: Types.AssetAmount({
				sign: false,
				denomination: Types.AssetDenomination.Wei,
				ref: Types.AssetReference.Delta,
				value: _netAmount
			}),
			primaryMarketId: _marketId,
			secondaryMarketId: 0,
			otherAddress: address(this),
			otherAccountId: 0,
			data: ""
		});
		_actions[1] = Actions.ActionArgs({
			actionType: Actions.ActionType.Call,
			accountId: 0,
			amount: Types.AssetAmount({
				sign: false,
				denomination: Types.AssetDenomination.Wei,
				ref: Types.AssetReference.Delta,
				value: 0
			}),
			primaryMarketId: 0,
			secondaryMarketId: 0,
			otherAddress: address(this),
			otherAccountId: 0,
			data: abi.encode(_token, _netAmount, _feeAmount, _context)
		});
		_actions[2] = Actions.ActionArgs({
			actionType: Actions.ActionType.Deposit,
			accountId: 0,
			amount: Types.AssetAmount({
				sign: true,
				denomination: Types.AssetDenomination.Wei,
				ref: Types.AssetReference.Delta,
				value: _grossAmount
			}),
			primaryMarketId: _marketId,
			secondaryMarketId: 0,
			otherAddress: address(this),
			otherAccountId: 0,
			data: ""
		});
		try SoloMargin(_solo).operate(_accounts, _actions) {
			return true;
		} catch (bytes memory /* _data */) {
			return false;
		}
	}

	/**
	 * @dev This function should be called as the final step of the flash
	 *      loan to properly implement the repay of the loan.
	 * @param _token The reserve token.
	 * @param _grossAmount The amount to be repayed including repay fees.
	 */
	function _paybackFlashLoan(address _token, uint256 _grossAmount) internal
	{
		address _solo = $.Dydx_SOLO_MARGIN;
		Transfers._approveFunds(_token, _solo, _grossAmount);
	}
}
