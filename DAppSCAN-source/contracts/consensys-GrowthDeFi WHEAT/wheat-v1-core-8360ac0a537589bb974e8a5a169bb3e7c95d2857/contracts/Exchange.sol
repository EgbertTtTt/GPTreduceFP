pragma solidity ^0.6.0;


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

interface IExchange {
	// view functions
	function calcConversionFromInput(address _from, address _to, uint256 _inputAmount) external view returns (uint256 _outputAmount);
	function calcConversionFromOutput(address _from, address _to, uint256 _outputAmount) external view returns (uint256 _inputAmount);
	function calcJoinPoolFromInput(address _pool, address _token, uint256 _inputAmount) external view returns (uint256 _outputShares);

	// open functions
	function convertFundsFromInput(address _from, address _to, uint256 _inputAmount, uint256 _minOutputAmount) external returns (uint256 _outputAmount);
	function convertFundsFromOutput(address _from, address _to, uint256 _outputAmount, uint256 _maxInputAmount) external returns (uint256 _inputAmount);
	function joinPoolFromInput(address _pool, address _token, uint256 _inputAmount, uint256 _minOutputShares) external returns (uint256 _outputShares);
}

library Math {
	function _min(uint256 _amount1, uint256 _amount2) internal pure returns (uint256 _minAmount)
	{
		return _amount1 < _amount2 ? _amount1 : _amount2;
	}

	function _max(uint256 _amount1, uint256 _amount2) internal pure returns (uint256 _maxAmount)
	{
		return _amount1 > _amount2 ? _amount1 : _amount2;
	}

	function _sqrt(uint256 _y) internal pure returns (uint256 _z)
	{
		if (_y > 3) {
			_z = _y;
			uint256 _x = _y / 2 + 1;
			while (_x < _z) {
				_z = _x;
				_x = (_y / _x + _x) / 2;
			}
			return _z;
		}
		if (_y > 0) return 1;
		return 0;
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

interface Router02 is Router01 {
	function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 _amountIn, uint256 _amountOutMin, address[] calldata _path, address _to, uint256 _deadline) external;
}

library UniswapV2ExchangeAbstraction {
	/**
	 * @dev Calculates how much output to be received from the given input
	 *      when converting between two assets.
	 * @param _router The router address.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _inputAmount The input asset amount to be provided.
	 * @return _outputAmount The output asset amount to be received.
	 */
	function _calcConversionFromInput(address _router, address _from, address _to, uint256 _inputAmount) internal view returns (uint256 _outputAmount)
	{
		address _WBNB = Router02(_router).WETH();
		address[] memory _path = _buildPath(_from, _WBNB, _to);
		return Router02(_router).getAmountsOut(_inputAmount, _path)[_path.length - 1];
	}

	/**
	 * @dev Calculates how much input to be received the given the output
	 *      when converting between two assets.
	 * @param _router The router address.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _outputAmount The output asset amount to be received.
	 * @return _inputAmount The input asset amount to be provided.
	 */
	function _calcConversionFromOutput(address _router, address _from, address _to, uint256 _outputAmount) internal view returns (uint256 _inputAmount)
	{
		address _WBNB = Router02(_router).WETH();
		address[] memory _path = _buildPath(_from, _WBNB, _to);
		return Router02(_router).getAmountsIn(_outputAmount, _path)[0];
	}

	/**
	 * @dev Convert funds between two assets given the exact input amount.
	 * @param _router The router address.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _inputAmount The input asset amount to be provided.
	 * @param _minOutputAmount The output asset minimum amount to be received.
	 * @return _outputAmount The output asset amount received.
	 */
	function _convertFundsFromInput(address _router, address _from, address _to, uint256 _inputAmount, uint256 _minOutputAmount) internal returns (uint256 _outputAmount)
	{
		address _WBNB = Router02(_router).WETH();
		address[] memory _path = _buildPath(_from, _WBNB, _to);
		Transfers._approveFunds(_from, _router, _inputAmount);
		uint256 _oldBalance = Transfers._getBalance(_path[_path.length - 1]);
		Router02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(_inputAmount, _minOutputAmount, _path, address(this), uint256(-1));
		uint256 _newBalance = Transfers._getBalance(_path[_path.length - 1]);
		assert(_newBalance >= _oldBalance);
		return _newBalance - _oldBalance;
	}

	/**
	 * @dev Convert funds between two assets given the exact output amount.
	 * @param _router The router address.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _outputAmount The output asset amount to be received.
	 * @param _maxInputAmount The input asset maximum amount to be provided.
	 * @return _inputAmount The input asset amount provided.
	 */
	function _convertFundsFromOutput(address _router, address _from, address _to, uint256 _outputAmount, uint256 _maxInputAmount) internal returns (uint256 _inputAmount)
	{
		address _WBNB = Router02(_router).WETH();
		address[] memory _path = _buildPath(_from, _WBNB, _to);
		Transfers._approveFunds(_from, _router, _maxInputAmount);
		_inputAmount = Router02(_router).swapTokensForExactTokens(_outputAmount, _maxInputAmount, _path, address(this), uint256(-1))[0];
		Transfers._approveFunds(_from, _router, 0);
		return _inputAmount;
	}

	/**
	 * @dev Builds a routing path for conversion possibly using an asset as intermediate.
	 * @param _from The input asset address.
	 * @param _through The middle asset address.
	 * @param _to The output asset address.
	 * @return _path The route to perform conversion.
	 */
	function _buildPath(address _from, address _through, address _to) private pure returns (address[] memory _path)
	{
		assert(_from != _to);
		if (_from == _through || _to == _through) {
			_path = new address[](2);
			_path[0] = _from;
			_path[1] = _to;
			return _path;
		} else {
			_path = new address[](3);
			_path[0] = _from;
			_path[1] = _through;
			_path[2] = _to;
			return _path;
		}
	}
}

interface Pair is PoolToken {
	function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
	function token0() external view returns (address _token0);
	function token1() external view returns (address _token1);

	function mint(address _to) external returns (uint256 _liquidity);
}

library UniswapV2LiquidityPoolAbstraction {
	using SafeMath for uint256;

	/**
	 * @dev Estimates the number of LP shares to be received by a single
	 *      asset deposit into a liquidity pool.
	 * @param _router The router address.
	 * @param _pair The liquidity pool address.
	 * @param _token The ERC-20 token for the asset being deposited.
	 * @param _amount The amount to be deposited.
	 * @return _shares The expected number of LP shares to be received.
	 */
	function _calcJoinPoolFromInput(address _router, address _pair, address _token, uint256 _amount) internal view returns (uint256 _shares)
	{
		if (_amount == 0) return 0;
		address _token0 = Pair(_pair).token0();
		address _token1 = Pair(_pair).token1();
		require(_token == _token0 || _token == _token1, "invalid token");
		(uint256 _reserve0, uint256 _reserve1,) = Pair(_pair).getReserves();
		uint256 _balance = _token == _token0 ? _reserve0 : _reserve1;
		uint256 _otherBalance = _token == _token0 ? _reserve1 : _reserve0;
		uint256 _totalSupply = Pair(_pair).totalSupply();
		uint256 _swapAmount = _calcSwapOutputFromInput(_balance, _amount);
		if (_swapAmount == 0) _swapAmount = _amount / 2;
		uint256 _leftAmount = _amount.sub(_swapAmount);
		uint256 _otherAmount = Router02(_router).getAmountOut(_swapAmount, _balance, _otherBalance);
		_shares = Math._min(_totalSupply.mul(_leftAmount) / _balance.add(_swapAmount), _totalSupply.mul(_otherAmount) / _otherBalance.sub(_otherAmount));
		return _shares;
	}

	/**
	 * @dev Estimates the amount of tokens to be received by a single
	 *      asset withdrawal from a liquidity pool.
	 * @param _router The router address.
	 * @param _pair The liquidity pool address.
	 * @param _token The ERC-20 token for the asset being withdrawn.
	 * @param _shares The number of LP shares provided to the withdrawal.
	 * @return _amount The expected amount to be received.
	 */
	function _calcExitPoolFromInput(address _router, address _pair, address _token, uint256 _shares) internal view returns (uint256 _amount)
	{
		if (_shares == 0) return 0;
		address _token0 = Pair(_pair).token0();
		address _token1 = Pair(_pair).token1();
		require(_token == _token0 || _token == _token1, "invalid token");
		(uint256 _reserve0, uint256 _reserve1,) = Pair(_pair).getReserves();
		uint256 _balance = _token == _token0 ? _reserve0 : _reserve1;
		uint256 _otherBalance = _token == _token0 ? _reserve1 : _reserve0;
		uint256 _totalSupply = Pair(_pair).totalSupply();
		uint256 _baseAmount = _balance.mul(_shares) / _totalSupply;
		uint256 _swapAmount = _otherBalance.mul(_shares) / _totalSupply;
		uint256 _additionalAmount = Router02(_router).getAmountOut(_swapAmount, _otherBalance.sub(_swapAmount), _balance.sub(_baseAmount));
		_amount = _baseAmount.add(_additionalAmount);
		return _amount;
	}

	/**
	 * @dev Deposits a single asset into a liquidity pool.
	 * @param _router The router address.
	 * @param _pair The liquidity pool address.
	 * @param _token The ERC-20 token for the asset being deposited.
	 * @param _amount The amount to be deposited.
	 * @param _minShares The minimum number of LP shares to be received.
	 * @return _shares The actual number of LP shares received.
	 */
	function _joinPoolFromInput(address _router, address _pair, address _token, uint256 _amount, uint256 _minShares) internal returns (uint256 _shares)
	{
		if (_amount == 0) return 0;
		address _token0 = Pair(_pair).token0();
		address _token1 = Pair(_pair).token1();
		require(_token == _token0 || _token == _token1, "invalid token");
		address _otherToken = _token == _token0 ? _token1 : _token0;
		(uint256 _reserve0, uint256 _reserve1,) = Pair(_pair).getReserves();
		uint256 _swapAmount = _calcSwapOutputFromInput(_token == _token0 ? _reserve0 : _reserve1, _amount);
		if (_swapAmount == 0) _swapAmount = _amount / 2;
		uint256 _leftAmount = _amount.sub(_swapAmount);
		Transfers._approveFunds(_token, _router, _amount);
		uint256 _otherAmount;
		{
			address[] memory _path = new address[](2);
			_path[0] = _token;
			_path[1] = _otherToken;
			uint256 _oldBalance = Transfers._getBalance(_otherToken);
			Router02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(_swapAmount, 1, _path, address(this), uint256(-1));
			uint256 _newBalance = Transfers._getBalance(_otherToken);
			assert(_newBalance >= _oldBalance);
			_otherAmount = _newBalance - _oldBalance;
		}
		Transfers._approveFunds(_otherToken, _router, _otherAmount);
		(,,_shares) = Router02(_router).addLiquidity(_token, _otherToken, _leftAmount, _otherAmount, 1, 1, address(this), uint256(-1));
		require(_shares >= _minShares, "high slippage");
		return _shares;
	}

	/**
	 * @dev Withdraws a single asset from a liquidity pool.
	 * @param _router The router address.
	 * @param _pair The liquidity pool address.
	 * @param _token The ERC-20 token for the asset being withdrawn.
	 * @param _shares The number of LP shares provided to the withdrawal.
	 * @param _minAmount The minimum amount to be received.
	 * @return _amount The actual amount received.
	 */
	function _exitPoolFromInput(address _router, address _pair, address _token, uint256 _shares, uint256 _minAmount) internal returns (uint256 _amount)
	{
		if (_shares == 0) return 0;
		address _token0 = Pair(_pair).token0();
		address _token1 = Pair(_pair).token1();
		require(_token == _token0 || _token == _token1, "invalid token");
		address _otherToken = _token == _token0 ? _token1 : _token0;
		Transfers._approveFunds(_pair, _router, _shares);
		(uint256 _baseAmount, uint256 _swapAmount) = Router02(_router).removeLiquidity(_token, _otherToken, _shares, 1, 1, address(this), uint256(-1));
		Transfers._approveFunds(_otherToken, _router, _swapAmount);
		uint256 _additionalAmount;
		{
			address[] memory _path = new address[](2);
			_path[0] = _otherToken;
			_path[1] = _token;
			uint256 _oldBalance = Transfers._getBalance(_token);
			Router02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(_swapAmount, 1, _path, address(this), uint256(-1));
			uint256 _newBalance = Transfers._getBalance(_token);
			assert(_newBalance >= _oldBalance);
			_additionalAmount = _newBalance - _oldBalance;
		}
		_amount = _baseAmount.add(_additionalAmount);
		require(_amount >= _minAmount, "high slippage");
		return _amount;
	}

	/**
	 * @dev Estimates the amount of tokens to be swapped in order to join
	 * the pool providing both assets.
         */
	function _calcSwapOutputFromInput(uint256 _reserveAmount, uint256 _inputAmount) private pure returns (uint256 _outputAmount)
	{
		return Math._sqrt(_reserveAmount.mul(_inputAmount.mul(3988000).add(_reserveAmount.mul(3988009)))).sub(_reserveAmount.mul(1997)) / 1994;
	}
}

/**
 * @notice This contract provides a helper exchange abstraction to be used by other
 *         contracts, so that it can be replaced to accomodate routing changes.
 */
contract Exchange is IExchange, Ownable {
	address public router;
	address public treasury;

	/**
	 * @dev Constructor for this exchange contract.
	 * @param _router The Uniswap V2 compatible router address to be used for operations.
	 * @param _treasury The treasury address used to recover lost funds.
	 */
	constructor (address _router, address _treasury) public
	{
		router = _router;
		treasury = _treasury;
	}

	/**
	 * @notice Calculates how much output to be received from the given input
	 *         when converting between two assets.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _inputAmount The input asset amount to be provided.
	 * @return _outputAmount The output asset amount to be received.
	 */
	function calcConversionFromInput(address _from, address _to, uint256 _inputAmount) external view override returns (uint256 _outputAmount)
	{
		return UniswapV2ExchangeAbstraction._calcConversionFromInput(router, _from, _to, _inputAmount);
	}

	/**
	 * @notice Calculates how much input to be received the given the output
	 *         when converting between two assets.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _outputAmount The output asset amount to be received.
	 * @return _inputAmount The input asset amount to be provided.
	 */
	function calcConversionFromOutput(address _from, address _to, uint256 _outputAmount) external view override returns (uint256 _inputAmount)
	{
		return UniswapV2ExchangeAbstraction._calcConversionFromOutput(router, _from, _to, _outputAmount);
	}

	/**
	 * @dev Estimates the number of LP shares to be received by a single
	 *      asset deposit into a liquidity pool.
	 * @param _pool The liquidity pool address.
	 * @param _token The ERC-20 token for the asset being deposited.
	 * @param _inputAmount The amount to be deposited.
	 * @return _outputShares The expected number of LP shares to be received.
	 */
	function calcJoinPoolFromInput(address _pool, address _token, uint256 _inputAmount) external view override returns (uint256 _outputShares)
	{
		return UniswapV2LiquidityPoolAbstraction._calcJoinPoolFromInput(router, _pool, _token, _inputAmount);
	}

	/**
	 * @notice Convert funds between two assets given the exact input amount.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _inputAmount The input asset amount to be provided.
	 * @param _minOutputAmount The output asset minimum amount to be received.
	 * @return _outputAmount The output asset amount received.
	 */
	// SWC-107-Reentrancy: L80-90
	function convertFundsFromInput(address _from, address _to, uint256 _inputAmount, uint256 _minOutputAmount) external override returns (uint256 _outputAmount)
	{
		address _sender = msg.sender;
		Transfers._pullFunds(_from, _sender, _inputAmount);
		_inputAmount = Math._min(_inputAmount, Transfers._getBalance(_from)); // deals with potential transfer tax
		_outputAmount = UniswapV2ExchangeAbstraction._convertFundsFromInput(router, _from, _to, _inputAmount, _minOutputAmount);
		_outputAmount = Math._min(_outputAmount, Transfers._getBalance(_to)); // deals with potential transfer tax
		Transfers._pushFunds(_to, _sender, _outputAmount);
		return _outputAmount;
	}

	/**
	 * @notice Convert funds between two assets given the exact output amount.
	 * @param _from The input asset address.
	 * @param _to The output asset address.
	 * @param _outputAmount The output asset amount to be received.
	 * @param _maxInputAmount The input asset maximum amount to be provided.
	 * @return _inputAmount The input asset amount provided.
	 */
	function convertFundsFromOutput(address _from, address _to, uint256 _outputAmount, uint256 _maxInputAmount) external override returns (uint256 _inputAmount)
	{
		address _sender = msg.sender;
		Transfers._pullFunds(_from, _sender, _maxInputAmount);
		_maxInputAmount = Math._min(_maxInputAmount, Transfers._getBalance(_from)); // deals with potential transfer tax
		_inputAmount = UniswapV2ExchangeAbstraction._convertFundsFromOutput(router, _from, _to, _outputAmount, _maxInputAmount);
		uint256 _refundAmount = _maxInputAmount - _inputAmount;
		_refundAmount = Math._min(_refundAmount, Transfers._getBalance(_from)); // deals with potential transfer tax
		Transfers._pushFunds(_from, _sender, _refundAmount);
		_outputAmount = Math._min(_outputAmount, Transfers._getBalance(_to)); // deals with potential transfer tax
		Transfers._pushFunds(_to, _sender, _outputAmount);
		return _inputAmount;
	}

	/**
	 * @dev Deposits a single asset into a liquidity pool.
	 * @param _pool The liquidity pool address.
	 * @param _token The ERC-20 token for the asset being deposited.
	 * @param _inputAmount The amount to be deposited.
	 * @param _minOutputShares The minimum number of LP shares to be received.
	 * @return _outputShares The actual number of LP shares received.
	 */
	function joinPoolFromInput(address _pool, address _token, uint256 _inputAmount, uint256 _minOutputShares) external override returns (uint256 _outputShares)
	{
		address _sender = msg.sender;
		Transfers._pullFunds(_token, _sender, _inputAmount);
		_inputAmount = Math._min(_inputAmount, Transfers._getBalance(_token)); // deals with potential transfer tax
		_outputShares = UniswapV2LiquidityPoolAbstraction._joinPoolFromInput(router, _pool, _token, _inputAmount, _minOutputShares);
		_outputShares = Math._min(_outputShares, Transfers._getBalance(_pool)); // deals with potential transfer tax
		Transfers._pushFunds(_pool, _sender, _outputShares);
		return _outputShares;
	}

	/**
	 * @notice Allows the recovery of tokens sent by mistake to this
	 *         contract, excluding tokens relevant to its operations.
	 *         The full balance is sent to the treasury address.
	 *         This is a privileged function.
	 * @param _token The address of the token to be recovered.
	 */
	function recoverLostFunds(address _token) external onlyOwner
	{
		uint256 _balance = Transfers._getBalance(_token);
		Transfers._pushFunds(_token, treasury, _balance);
	}

	/**
	 * @notice Updates the Uniswap V2 compatible router address.
	 *         This is a privileged function.
	 * @param _newRouter The new router address.
	 */
	function setRouter(address _newRouter) external onlyOwner
	{
		require(_newRouter != address(0), "invalid address");
		address _oldRouter = router;
		router = _newRouter;
		emit ChangeRouter(_oldRouter, _newRouter);
	}

	/**
	 * @notice Updates the treasury address used to recover lost funds.
	 *         This is a privileged function.
	 * @param _newTreasury The new treasury address.
	 */
	function setTreasury(address _newTreasury) external onlyOwner
	{
		require(_newTreasury != address(0), "invalid address");
		address _oldTreasury = treasury;
		treasury = _newTreasury;
		emit ChangeTreasury(_oldTreasury, _newTreasury);
	}

	// events emitted by this contract
	event ChangeRouter(address _oldRouter, address _newRouter);
	event ChangeTreasury(address _oldTreasury, address _newTreasury);
}
