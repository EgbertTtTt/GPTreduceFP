pragma solidity ^0.6.0;


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

//"SPDX-License-Identifier: UNLICENSED"
contract LeadStake is Ownable {
    
    //initializing safe computations
    using SafeMath for uint;

    //LEAD contract address
    address public lead;
    //total amount of staked lead
    uint public totalStaked;
    //tax rate for staking in percentage
    uint public stakingTaxRate;                     //10 = 1%
    //tax amount for registration
    uint public registrationTax;
    //daily return of investment in percentage
    uint8 public dailyROI;                         //100 = 1%
    //tax rate for unstaking in percentage 
    uint public unstakingTaxRate;                   //10 = 1%
    //minimum stakeable LEAD 
    uint public minimumStakeValue;
    //referral allocation from the registration tax
    uint public referralTaxAllocation;
    //stakeholders' indexes
    uint index;
    //pause mechanism
    bool active = true;
    //mapping of stakeholders' indexes to addresses
    mapping(uint => address) public userIndex;
    //mapping of stakeholders' address to number of stakes
    mapping(address => uint) public stakes;
    //mapping of stakeholders' address to stake rewards
    mapping(address => uint) public stakeRewards;
    //mapping of stakeholders' address to number of referrals 
    mapping(address => uint) public referralCount;
    //mapping of stakeholders' address to referral rewards earned 
    mapping(address => uint) public referralRewards;
    //mapping of stakeholder's address to last transaction time for reward calculation
    mapping(address => uint) public lastClock;
    //mapping of addresses to verify registered stakers
    mapping(address => bool) public registered;
    
    //Events
    event OnWithdrawal(address sender, uint amount);
    event OnStake(address sender, uint amount, uint tax);
    event OnUnstake(address sender, uint amount, uint tax);
    event OnDeposit(address sender, uint amount, uint time);
    event OnRegisterAndStake(address stakeholder, uint amount, uint totalTax , address _referrer);
    
    /**
     * @dev Sets the initial values
     */
    constructor(
        address _token,
        uint8 _stakingTaxRate, 
        uint8 _unstakingTaxRate,
        uint8 _dailyROI,
        uint _registrationTax,
        uint _referralTaxAllocation,
        uint _minimumStakeValue) public {
            
        //set initial state variables
        lead = _token;
        stakingTaxRate = _stakingTaxRate;
        unstakingTaxRate = _unstakingTaxRate;
        dailyROI = _dailyROI;
        registrationTax = _registrationTax;
        referralTaxAllocation = _referralTaxAllocation;
        minimumStakeValue = _minimumStakeValue;
    }
    
    //exclusive access for registered address
    modifier onlyRegistered() {
        require(registered[msg.sender] == true, "Staker must be registered");
        _;
    }
    
    //exclusive access for unregistered address
    modifier onlyUnregistered() {
        require(registered[msg.sender] == false, "Staker is already registered");
        _;
    }
        
    //make sure contract is active
    modifier whenActive() {
        require(active == true, "Smart contract is curently inactive");
        _;
    }
    
    /**
     * registers and creates stakes for new stakeholders
     * deducts the registration tax and staking tax
     * calculates refferal bonus from the registration tax and sends it to the _referrer if there is one
     * transfers LEAD from sender's address into the smart contract
     * Emits an {OnRegisterAndStake} event..
     */
    function registerAndStake(uint _amount, address _referrer) external onlyUnregistered() whenActive() {
        //makes sure user is not the referrer
        require(msg.sender != _referrer, "Cannot refer self");
        //makes sure referrer is registered already
        require(registered[_referrer] || address(0x0) == _referrer, "Referrer must be registered");
        //makes sure user has enough amount
        require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");
        //makes sure smart contract transfers LEAD from user
        require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");
        //makes sure amount is more than the registration fee and the minimum deposit
        require(_amount >= registrationTax.add(minimumStakeValue), "Must send at least enough LEAD to pay registration fee.");
        //calculates referral bonus
        uint referralBonus = (registrationTax.mul(referralTaxAllocation)).div(100);
        //calculates final amount after deducting registration tax
        uint finalAmount = _amount.sub(registrationTax);
        //calculates staking tax on final calculated amount
        uint stakingTax = (stakingTaxRate.mul(finalAmount)).div(1000);
        //conditional statement if user registers with referrer 
        if(_referrer != address(0x0)) {
            //increase referral count of referrer
            referralCount[_referrer]++;
            //add referral bonus to referrer
            referralRewards[_referrer] = referralRewards[_referrer].add(referralBonus);
        } 
        //update the user's stakes deducting the staking tax
        stakes[msg.sender] = stakes[msg.sender].add(finalAmount).sub(stakingTax);
        //update the total staked LEAD amount in the pool
        totalStaked = totalStaked.add(finalAmount).sub(stakingTax);
        //register user and add to stakeholders list
        registered[msg.sender] = true;
        userIndex[index] = msg.sender;
        index++;
        //mark the transaction date
        lastClock[msg.sender] = now;
        //emit event
        emit OnRegisterAndStake(msg.sender, _amount, registrationTax.add(stakingTax), _referrer);
    }
    
    //calculates stakeholders latest unclaimed earnings 
    function calculateEarnings(address _stakeholder) public view returns(uint) {
        //records the number of days between the last payout time and now
        uint activeDays = (now.sub(lastClock[_stakeholder])).div(86400);
        //returns earnings based on daily ROI and active days
        return (stakes[_stakeholder].mul(dailyROI).mul(activeDays)).div(10000);
    }
    
    /**
     * creates stakes for already registered stakeholders
     * deducts the staking tax from _amount inputted
     * registers the remainder in the stakes of the sender
     * records the previous earnings before updated stakes 
     * Emits an {OnStake} event
     */
    function stake(uint _amount) external onlyRegistered() whenActive() {
        //makes sure stakeholder does not stake below the minimum
        require(_amount >= minimumStakeValue, "Amount is below minimum stake value.");
        //makes sure stakeholder has enough balance
        require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");
        //makes sure smart contract transfers LEAD from user
        require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");
        //calculates staking tax on amount
        uint stakingTax = (stakingTaxRate.mul(_amount)).div(1000);
        //calculates amount after tax
        uint afterTax = _amount.sub(stakingTax);
        //update the total staked LEAD amount in the pool
        totalStaked = totalStaked.add(afterTax);
        //adds earnings current earnings to stakeRewards
        stakeRewards[msg.sender] = stakeRewards[msg.sender].add(calculateEarnings(msg.sender));
        //calculates unpaid period
        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
        //mark transaction date with remainder
        lastClock[msg.sender] = now.sub(remainder);
        //updates stakeholder's stakes
        stakes[msg.sender] = stakes[msg.sender].add(afterTax);
        //emit event
        emit OnStake(msg.sender, afterTax, stakingTax);
    }
    
    
    /**
     * removes '_amount' stakes for already registered stakeholders
     * deducts the unstaking tax from '_amount'
     * transfers the sum of the remainder, stake rewards, referral rewards, and current eanrings to the sender 
     * deregisters stakeholder if all the stakes are removed
     * Emits an {OnStake} event
     */
    function unstake(uint _amount) external onlyRegistered() {
        //makes sure _amount is not more than stake balance
        require(_amount <= stakes[msg.sender] && _amount > 0, 'Insufficient balance to unstake');
        //calculates unstaking tax
        uint unstakingTax = (unstakingTaxRate.mul(_amount)).div(1000);
        //calculates amount after tax
        uint afterTax = _amount.sub(unstakingTax);
        //sums up stakeholder's total rewards with _amount deducting unstaking tax
        uint unstakePlusAllEarnings = stakeRewards[msg.sender].add(referralRewards[msg.sender]).add(afterTax).add(calculateEarnings(msg.sender));
        //transfers value to stakeholder
        IERC20(lead).transfer(msg.sender, unstakePlusAllEarnings);
        //updates stakes
        stakes[msg.sender] = stakes[msg.sender].sub(_amount);
        //initializes stake rewards
        stakeRewards[msg.sender] = 0;
        //initializes referral rewards
        referralRewards[msg.sender] = 0;
        //initializes referral count
        referralCount[msg.sender] = 0;
        //calculates unpaid period
        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
        //mark transaction date with remainder
        lastClock[msg.sender] = now.sub(remainder);
        //update the total staked LEAD amount in the pool
        totalStaked = totalStaked.sub(_amount);
        //conditional statement if stakeholder has no stake left
        if(stakes[msg.sender] == 0) {
            //deregister stakeholder
            _removeStakeholder(msg.sender);
        }
        //emit event
        emit OnUnstake(msg.sender, _amount, unstakingTax);
    }
    
    /**
     * checks if _address is a registered stakeholder
     * returns 'true' and 'id number' if stakeholder and 'false' and '0'  if not
     */
    function isStakeholder(address _address) public view returns(bool, uint) {
        //loops through the stakeholders list
        for (uint i = 0; i < index; i += 1){
            //conditional statement if address is stakeholder
            if (_address == userIndex[i]) {
                //returns true and list id
                return (true, i);
            }
        }
        //returns false and 0
        return (false, 0);
    }
    
    //deregisters _stakeholder and removes address from stakeholders list
    function _removeStakeholder(address _stakeholder) internal {
        //changes registered staus to false
        registered[msg.sender] = false;
        //identify stakeholder in the stakeholders list
        (bool _isStakeholder, uint i) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            delete userIndex[i];
        }
    }

    //transfers total active earnng to stakeholders wallett
    function withdrawEarnings() external onlyRegistered() whenActive() {
        //calculates the total redeemable rewards
        uint totalReward = referralRewards[msg.sender].add(stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
        //makes sure user has rewards to withdraw before execution
        require(totalReward > 0, 'No reward to withdraw'); 
        //transfers total rewards to stakeholder
        IERC20(lead).transfer(msg.sender, totalReward);
        //initializes stake rewards
        stakeRewards[msg.sender] = 0;
        //initializes referal rewards
        referralRewards[msg.sender] = 0;
        //initializes referral count
        referralCount[msg.sender] = 0;
        //calculates unpaid period
        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
        //mark transaction date with remainder
        lastClock[msg.sender] = now.sub(remainder);
        //emit event
        emit OnWithdrawal(msg.sender, totalReward);
    }

    function changeActiveStatus() external onlyOwner() {
        if(active = true) {
            active == false;
        } else {
            active == true;
        }
    }
    
    //sets the staking rate
    function setStakingTaxRate(uint8 _stakingTaxRate) external onlyOwner() {
        stakingTaxRate = _stakingTaxRate;
    }

    //sets the unstaking rate
    function setUnstakingTaxRate(uint8 _unstakingTaxRate) external onlyOwner() {
        unstakingTaxRate = _unstakingTaxRate;
    }
    
    //sets the daily ROI
    function setDailyROI(uint8 _dailyROI) external onlyOwner() {
        for(uint i = 0; i < index; i++){
            //registers all previous earnings
            stakeRewards[userIndex[i]] = stakeRewards[userIndex[i]].add(calculateEarnings(userIndex[i]));
            //calculates unpaid period
            uint remainder = (now.sub(lastClock[userIndex[i]])).mod(86400);
            //mark transaction date with remainder
            lastClock[userIndex[i]] = now.sub(remainder);
        }
        dailyROI = _dailyROI;
    }
    
    //sets the registration tax
    function setRegistrationTax(uint _registrationTax) external onlyOwner() {
        registrationTax = _registrationTax;
    }
    
    //sets the refferal tax allocation 
    function setReferralTaxAllocation(uint _referralTaxAllocation) external onlyOwner() {
        referralTaxAllocation = _referralTaxAllocation;
    }
    
    //sets the minimum stake value
    function setMinimumStakeValue(uint _minimumStakeValue) external onlyOwner() {
        minimumStakeValue = _minimumStakeValue;
    }
//    SWC-105-Unprotected Ether Withdrawal:L322-329
    //withdraws _amount from the pool to _address
    function adminWithdraw(address _address, uint _amount) external onlyOwner {
        //makes sure _amount is not more than smart contract balance
        require(IERC20(lead).balanceOf(address(this)) >= _amount, 'Insufficient LEAD balance in smart contract');
        //transfers _amount to _address
        IERC20(lead).transfer(_address, _amount);
        //emit event
        emit OnWithdrawal(_address, _amount);
    }

    //supplies LEAD from 'owner' to smart contract if pool balance runs dry
    function supplyPool() external onlyOwner() {
        //total balance that can be claimed in the pool
        uint totalClaimable;
        //loop through stakeholders' list
        for(uint i = 0; i < index; i++){
            //sum up all redeemable LEAD
            totalClaimable = stakeRewards[userIndex[i]].add(referralRewards[userIndex[i]]).add(stakes[userIndex[i]]).add(calculateEarnings(userIndex[i]));
        }
        //makes sure the pool dept is higher than balance
        require(totalClaimable > IERC20(lead).balanceOf(address(this)), 'Still have enough pool reserve');
        //calculate difference
        uint difference = totalClaimable.sub(IERC20(lead).balanceOf(address(this)));
        //makes sure 'owner' has enough balance
        require(IERC20(lead).balanceOf(msg.sender) >= difference, 'Insufficient LEAD balance in owner wallet');
        //transfers LEAD from 'owner' to smart contract to make up for dept
        IERC20(lead).transferFrom(msg.sender, address(this), difference);
        //emits event
        emit OnDeposit(msg.sender, difference, now);
    }
}
