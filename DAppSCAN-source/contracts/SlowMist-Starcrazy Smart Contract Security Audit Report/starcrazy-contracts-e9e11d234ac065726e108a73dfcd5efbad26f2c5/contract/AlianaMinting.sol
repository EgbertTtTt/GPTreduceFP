pragma solidity ^0.5.0;


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

/// @title A facet of AlianaCore that manages special access privileges.
/// @dev See the AlianaCore contract documentation to understand how the various contract facets are arranged.
contract GFAccessControl {
    mapping(address => bool) public whitelist;

    event WhitelistedAddressAdded(address addr);
    event WhitelistedAddressRemoved(address addr);

    /**
     * @dev Throws if called by any account that's not whitelisted.
     */
    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "not whitelisted");
        _;
    }

    /**
     * @dev add an address to the whitelist
     * @param addr address
     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
     */
    function addAddressToWhitelist(address addr)
        external
        onlyCEO
        returns (bool success)
    {
        return _addAddressToWhitelist(addr);
    }

    /**
     * @dev add an address to the whitelist
     * @param addr address
     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
     */
    function _addAddressToWhitelist(address addr)
        private
        onlyCEO
        returns (bool success)
    {
        if (!whitelist[addr]) {
            whitelist[addr] = true;
            emit WhitelistedAddressAdded(addr);
            success = true;
        }
    }

    /**
     * @dev add addresses to the whitelist
     * @param addrs addresses
     * @return true if at least one address was added to the whitelist,
     * false if all addresses were already in the whitelist
     */
    function addAddressesToWhitelist(address[] calldata addrs)
        external
        onlyCEO
        returns (bool success)
    {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (_addAddressToWhitelist(addrs[i])) {
                success = true;
            }
        }
    }

    /**
     * @dev remove an address from the whitelist
     * @param addr address
     * @return true if the address was removed from the whitelist,
     * false if the address wasn't in the whitelist in the first place
     */
    function removeAddressFromWhitelist(address addr)
        external
        onlyCEO
        returns (bool success)
    {
        return _removeAddressFromWhitelist(addr);
    }

    /**
     * @dev remove an address from the whitelist
     * @param addr address
     * @return true if the address was removed from the whitelist,
     * false if the address wasn't in the whitelist in the first place
     */
    function _removeAddressFromWhitelist(address addr)
        private
        onlyCEO
        returns (bool success)
    {
        if (whitelist[addr]) {
            whitelist[addr] = false;
            emit WhitelistedAddressRemoved(addr);
            success = true;
        }
    }

    /**
     * @dev remove addresses from the whitelist
     * @param addrs addresses
     * @return true if at least one address was removed from the whitelist,
     * false if all addresses weren't in the whitelist in the first place
     */
    function removeAddressesFromWhitelist(address[] calldata addrs)
        external
        onlyCEO
        returns (bool success)
    {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (_removeAddressFromWhitelist(addrs[i])) {
                success = true;
            }
        }
    }

    // This facet controls access control for GameAlianas. There are four roles managed here:
    //
    //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
    //         contracts. It is also the only role that can unpause the smart contract. It is initially
    //         set to the address that created the smart contract in the AlianaCore constructor.
    //
    //     - The CFO: The CFO can withdraw funds from AlianaCore and its auction contracts.
    //
    //     - The COO: The COO can release gen0 alianas to auction, and mint promo cats.
    //
    // It should be noted that these roles are distinct without overlap in their access abilities, the
    // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
    // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
    // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
    // convenience. The less we use an address, the less likely it is that we somehow compromise the
    // account.

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public ceoAddress;
    address public candidateCEOAddress;

    address public cfoAddress;
    address public cooAddress;

    event SetCandidateCEO(address addr);
    event AcceptCEO(address addr);
    event SetCFO(address addr);
    event SetCOO(address addr);

    event Pause(address operator);
    event Unpause(address operator);

    // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public paused = false;

    /**
     * @dev The Ownable constructor sets the original `ceoAddress` of the contract to the sender
     * account.
     */
    constructor() public {
        ceoAddress = msg.sender;
        emit AcceptCEO(ceoAddress);
    }

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress, "not ceo");
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(msg.sender == cfoAddress, "not cfo");
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(msg.sender == cooAddress, "not coo");
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
                msg.sender == ceoAddress ||
                msg.sender == cfoAddress,
            "not c level"
        );
        _;
    }

    modifier onlyCLevelOrWhitelisted() {
        require(
            msg.sender == cooAddress ||
                msg.sender == ceoAddress ||
                msg.sender == cfoAddress ||
                whitelist[msg.sender],
            "not c level or whitelisted"
        );
        _;
    }

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _candidateCEO The address of the new CEO
    function setCandidateCEO(address _candidateCEO) external onlyCEO {
        require(_candidateCEO != address(0), "addr can't be 0");

        candidateCEOAddress = _candidateCEO;
        emit SetCandidateCEO(candidateCEOAddress);
    }

    /// @dev Accept CEO invite.
    function acceptCEO() external {
        require(msg.sender == candidateCEOAddress, "you are not the candidate");

        ceoAddress = candidateCEOAddress;
        emit AcceptCEO(ceoAddress);
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0), "addr can't be 0");

        cfoAddress = _newCFO;
        emit SetCFO(cfoAddress);
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0), "addr can't be 0");

        cooAddress = _newCOO;
        emit SetCOO(cooAddress);
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused, "paused");
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused() {
        require(paused, "not paused");
        _;
    }

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function pause() external onlyCEO whenNotPaused {
        paused = true;
        emit Pause(msg.sender);
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
        emit Unpause(msg.sender);
    }

    // Set in case the core contract is broken and an upgrade is required
    address public newContractAddress;

    /// @dev Used to mark the smart contract as upgraded, in case there is a serious
    ///  breaking bug. This method does nothing but keep track of the new contract and
    ///  emit a message indicating that the new address is set. It's up to clients of this
    ///  contract to update to the new contract address in that case. (This contract will
    ///  be paused indefinitely if such an upgrade takes place.)
    /// @param _v2Address new address
    function setNewAddress(address _v2Address) external onlyCEO whenPaused {
        // See README.md for updgrade plan
        newContractAddress = _v2Address;
        emit ContractUpgrade(_v2Address);
    }

    //////////
    // Safety Methods
    //////////

    /// @notice This method can be used by the owner to extract mistakenly
    ///  sent tokens to this contract.
    /// @param token_ The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract ether.
    function claimTokens(address token_) external onlyCEO {
        if (token_ == address(0)) {
            address(msg.sender).transfer(address(this).balance);
            return;
        }

        IERC20 token = IERC20(token_);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(address(msg.sender), balance);

        emit ClaimedTokens(token_, address(msg.sender), balance);
    }

    function withdrawTokens(
        IERC20 token_,
        address to_,
        uint256 amount_
    ) external onlyCEO {
        assert(token_.transfer(to_, amount_));
        emit WithdrawTokens(address(token_), address(msg.sender), to_, amount_);
    }

    ////////////////
    // Events
    ////////////////

    event ClaimedTokens(
        address indexed token_,
        address indexed controller_,
        uint256 amount_
    );

    event WithdrawTokens(
        address indexed token_,
        address indexed controller_,
        address indexed to_,
        uint256 amount_
    );
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
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
      * - `from` cannot be the zero address.
      * - `to` cannot be the zero address.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

/// @title SEKRETOOOO
contract IAliana is IERC721 {
    function createOfficialAliana(uint256 _genes, address _owner)
        public
        returns (uint256);

    function burn(uint256 _tokenID) external;

    function isAliana() public returns (bool);

    function geneLpLabor(int256 _id, uint256 _gene)
        public
        view
        returns (uint256);

    function geneLpLabors(int256[] memory _ids, uint256[] memory _genes)
        public
        view
        returns (uint256[] memory);

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory ownerTokens);

    function getAliana(uint256 _id)
        external
        view
        returns (
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 genes,
            uint256 lpLabor
        );
}

/// @title all functions related to creating kittens
contract AlianaMinting is GFAccessControl {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // The gae TOKEN
    IERC20 public gftToken;
    IAliana public aliana;

    struct itmap {
        mapping(uint256 => IndexValue) data;
        KeyFlag[] keys;
        uint256 size;
    }
    struct IndexValue {
        uint256 keyIndex;
        uint256 value;
    }
    struct KeyFlag {
        uint256 key;
        bool deleted;
    }

    function insert(
        itmap storage self,
        uint256 key,
        uint256 value
    ) internal returns (bool replaced) {
        uint256 keyIndex = self.data[key].keyIndex;
        self.data[key].value = value;
        if (keyIndex > 0) return true;
        else {
            keyIndex = self.keys.length++;
            self.data[key].keyIndex = keyIndex + 1;
            self.keys[keyIndex].key = key;
            self.size++;
            return false;
        }
    }

    function remove(itmap storage self, uint256 key)
        internal
        returns (bool success)
    {
        uint256 keyIndex = self.data[key].keyIndex;
        if (keyIndex == 0) return false;
        delete self.data[key];
        self.keys[keyIndex - 1].deleted = true;
        self.size--;
        return true;
    }

    function contains(itmap storage self, uint256 key)
        internal
        view
        returns (bool)
    {
        return self.data[key].keyIndex > 0;
    }

    function iterate_start(itmap storage self)
        internal
        view
        returns (uint256 keyIndex)
    {
        return iterate_next(self, uint256(-1));
    }

    function iterate_valid(itmap storage self, uint256 keyIndex)
        internal
        view
        returns (bool)
    {
        return keyIndex < self.keys.length;
    }

    function iterate_next(itmap storage self, uint256 keyIndex)
        internal
        view
        returns (uint256 r_keyIndex)
    {
        keyIndex++;
        while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
            keyIndex++;
        return keyIndex;
    }

    function iterate_get(itmap storage self, uint256 keyIndex)
        internal
        view
        returns (uint256 key, uint256 value)
    {
        key = self.keys[keyIndex].key;
        value = self.data[key].value;
    }

    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        itmap amountToken;
        uint256 rewardDebt; // Reward debt. See explanation below.
        uint256 balance;
        //
        // We do some fancy math here. Basically, any point in time, the amount of GFTs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * accGFTPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. Update accGFTPerShare and lastRewardBlock
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    // Accumulated GFTs per share, times 1e12. See below.
    uint256 public accGFTPerShare;
    // Last block reward block height
    uint256 public lastRewardBlock;
    // Reward per block
    uint256 public rewardPerBlock;
    // This Mine total labor force
    uint256 public labor;
    // Reward to distribute
    uint256 public rewardToDistribute;
    uint256 public maxMintingNumPerAddress = 9;

    // Info of each user that stakes LP tokens.
    mapping(address => UserInfo) userInfo;

    event RewardAdded(uint256 amount, bool isBlockReward);
    event Deposit(
        address indexed user,
        uint256 indexed tokenId,
        uint256 amount,
        uint256 pending
    );
    event Withdraw(
        address indexed user,
        uint256 indexed tokenId,
        uint256 amount,
        uint256 pending
    );
    event WithdrawPending(address indexed user, uint256 pending);
    event EmergencyWithdraw(address indexed user, uint256 amount);

    constructor(IERC20 _gftToken, IAliana _alianaAddr) public {
        require(_alianaAddr.isAliana(), "AlianaMinting: isAliana false");
        gftToken = _gftToken;
        aliana = _alianaAddr;
        lastRewardBlock = block.number;
        // times 1e10. See below.
        uint256 defaultPerDayIn5SecBlock = 2000;
        setRewardPerBlock(
            defaultPerDayIn5SecBlock.mul(1e18).div((24 * 60 * 60) / 5)
        );
    }

    function setMaxMintingNumPerAddress(uint256 _maxMintingNumPerAddress)
        public
        onlyCEO
    {
        maxMintingNumPerAddress = _maxMintingNumPerAddress;
    }

    function setRewardPerBlock(uint256 _rewardPerBlock) public onlyCEO {
        updateBlockReward();
        rewardPerBlock = _rewardPerBlock;
    }

    // View function to see pending reward on frontend.
    function pendingReward(address _user) external view returns (uint256) {
        UserInfo storage user = userInfo[_user];
        if (rewardPerBlock == 0) {
            return 0;
        }
        uint256 acps = accGFTPerShare;
        if (rewardPerBlock > 0) {
            uint256 lpSupply = labor;
            if (block.number > lastRewardBlock && lpSupply > 0) {
                acps = acps.add(rewardPending().mul(1e12).div(lpSupply));
            }
        }
        return user.amount.mul(acps).div(1e12).sub(user.rewardDebt);
    }

    function rewardPending() internal view returns (uint256) {
        uint256 reward = block.number.sub(lastRewardBlock).mul(rewardPerBlock);
        uint256 gaeBalance = gftToken.balanceOf(address(this)).sub(
            rewardToDistribute
        );
        if (gaeBalance < reward) {
            return gaeBalance;
        }
        return reward;
    }

    // Update reward variables to be up-to-date.
    function updateBlockReward() public {
        if (block.number <= lastRewardBlock || rewardPerBlock == 0) {
            return;
        }
        uint256 lpSupply = labor;
        uint256 reward = rewardPending();
        if (lpSupply == 0 || reward == 0) {
            lastRewardBlock = block.number;
            return;
        }
        rewardToDistribute = rewardToDistribute.add(reward);
        emit RewardAdded(reward, true);
        lastRewardBlock = block.number;
        accGFTPerShare = accGFTPerShare.add(reward.mul(1e12).div(lpSupply));
    }

    function _depositFrom(address _from, uint256 _tokenId)
        internal
        whenNotPaused
    {
        require(
            aliana.ownerOf(_tokenId) == _from,
            "AlianaMinting: must be the owner"
        );
        UserInfo storage user = userInfo[_from];
        if (maxMintingNumPerAddress > 0) {
            require(
                user.amountToken.size < maxMintingNumPerAddress,
                "AlianaMinting: too much mining at the same time"
            );
        }
        (, , , , uint256 _amount) = aliana.getAliana(_tokenId);
        require(_amount > 0, "AlianaMinting: gene _amount must > 0");

        updateBlockReward();
        uint256 takePending;
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(accGFTPerShare).div(1e12).sub(
                user.rewardDebt
            );
            if (pending > 0) {
                safeGFTTransfer(_from, pending);
            }
            takePending = pending;
        }

        aliana.transferFrom(address(_from), address(this), _tokenId);
        // SWC-104-Unchecked Call Return Value: L254
        insert(user.amountToken, _tokenId, _amount);
        user.balance = user.balance.add(1);

        user.amount = user.amount.add(_amount);
        labor = labor.add(_amount);

        user.rewardDebt = user.amount.mul(accGFTPerShare).div(1e12);
        emit Deposit(_from, _tokenId, _amount, takePending);
    }

    // Deposit LP tokens to Mine for GFT allocation.
    function deposit(uint256 _tokenId) public whenNotPaused {
        _depositFrom(msg.sender, _tokenId);
    }

    // Deposit LP tokens to Mine for GFT allocation.
    function deposits(uint256[] memory _tokenIds) public whenNotPaused {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            deposit(_tokenIds[i]);
        }
    }

    // Withdraw LP tokens from Mine.
    function withdrawPending() public {
        UserInfo storage user = userInfo[msg.sender];
        updateBlockReward();
        uint256 pending = user.amount.mul(accGFTPerShare).div(1e12).sub(
            user.rewardDebt
        );
        if (pending > 0) {
            safeGFTTransfer(msg.sender, pending);
        }
        user.rewardDebt = user.amount.mul(accGFTPerShare).div(1e12);
        emit WithdrawPending(msg.sender, pending);
    }

    // Withdraw LP tokens from Mine.
    function withdraw(uint256 _tokenId) public {
        return _withdrawFrom(msg.sender, _tokenId);
    }

    function _withdrawFrom(address _from, uint256 _tokenId) internal {
        UserInfo storage user = userInfo[_from];
        uint256 _amount = user.amountToken.data[_tokenId].value;

        require(_amount > 0, "AlianaMinting: withdraw: not good 1");
        require(user.amount >= _amount, "AlianaMinting: withdraw: not good 2");

        updateBlockReward();
        uint256 pending = user.amount.mul(accGFTPerShare).div(1e12).sub(
            user.rewardDebt
        );
        if (pending > 0) {
            safeGFTTransfer(_from, pending);
        }

        require(
            remove(user.amountToken, _tokenId),
            "AlianaMinting: withdraw: not good, remove from amountToken"
        );
        user.balance = user.balance.sub(1);
        user.amount = user.amount.sub(_amount);
        aliana.safeTransferFrom(address(this), address(_from), _tokenId, "");

        user.rewardDebt = user.amount.mul(accGFTPerShare).div(1e12);
        labor = labor.sub(_amount);
        emit Withdraw(_from, _tokenId, _amount, pending);
    }

    // Withdraw LP tokens from Mine.
    function withdraws(uint256[] memory _tokenIds) public {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            withdraw(_tokenIds[i]);
        }
    }

    // Withdraw LP tokens from Mine.
    function withdrawsByCEO(address _from, uint256[] memory _tokenIds)
        public
        onlyCEO
    {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _withdrawFrom(_from, _tokenIds[i]);
        }
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw() public {
        _emergencyWithdrawFrom(msg.sender);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdrawByCEO(address _from) public onlyCEO {
        _emergencyWithdrawFrom(_from);
    }

    function _emergencyWithdrawFrom(address _from) internal {
        UserInfo storage user = userInfo[_from];
        uint256 amount = user.amount;

        for (
            uint256 i = iterate_start(user.amountToken);
            iterate_valid(user.amountToken, i);
            i = iterate_next(user.amountToken, i)
        ) {
            uint256 key = 0;
            uint256 value = 0;
            (key, value) = iterate_get(user.amountToken, i);
            aliana.safeTransferFrom(address(this), address(_from), key, "");
        }

        user.amount = 0;
        user.rewardDebt = 0;
        delete user.amountToken;
        user.balance = 0;
        labor = labor.sub(amount);
        emit EmergencyWithdraw(_from, amount);
    }

    // Safe GFT transfer function, just in case if rounding error causes pool to not have enough GFTs.
    function safeGFTTransfer(address _to, uint256 _amount) internal {
        uint256 gaeBalance = gftToken.balanceOf(address(this));
        require(gaeBalance >= _amount, "AlianaMinting: insufficient balance");
        rewardToDistribute = rewardToDistribute.sub(_amount);
        require(
            gftToken.transfer(_to, _amount),
            "AlianaMinting: failed to transfer gae token"
        );
    }

    function depositedTokens(address _owner)
        public
        view
        returns (uint256[] memory ownerTokens)
    {
        require(_owner != address(0), "AlianaMinting: zero address");

        UserInfo storage user = userInfo[_owner];
        uint256[] memory result = new uint256[](user.balance);
        uint256 resultIndex = 0;
        for (
            uint256 i = iterate_start(user.amountToken);
            iterate_valid(user.amountToken, i);
            i = iterate_next(user.amountToken, i)
        ) {
            uint256 key = 0;
            uint256 value = 0;
            (key, value) = iterate_get(user.amountToken, i);
            result[resultIndex] = key;
            resultIndex++;
        }
        return result;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function depositedBalanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "AlianaMinting: zero address");
        UserInfo storage user = userInfo[_owner];
        return user.balance;
    }

    function receiveApproval(
        address _sender,
        uint256 _value,
        address _tokenContract,
        bytes memory _extraData
    ) public {
        require(_value >= 0, "AlianaMinting: approval negative");
        uint256 action;
        assembly {
            action := mload(add(_extraData, 0x20))
        }
        require(action == 1, "AlianaMinting: unknow action");
        if (action == 1) {
            // deposit
            require(
                _tokenContract == address(aliana),
                "AlianaMinting: approval and want mint use aliana, but used token isn't Aliana"
            );
            uint256 tokenId;
            assembly {
                tokenId := mload(add(_extraData, 0x40))
            }
            _depositFrom(_sender, tokenId);
        }
    }
}
