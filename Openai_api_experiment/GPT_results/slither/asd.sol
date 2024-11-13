// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GuildBank {
    address public owner;

    // 合约构造函数，初始化合约拥有者为部署者
    constructor() {
        owner = msg.sender;
    }

    // 仅允许合约拥有者调用的修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 提现事件
    event Withdrawal(address indexed receiver, address indexed tokenAddress, uint256 amount);

    // 提现函数，根据股份比例分配每种代币的金额
    function withdraw(
        address receiver,
        uint256 shares,
        uint256 totalShares,
        IERC20[] memory approvedTokens
    ) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < approvedTokens.length; i++) {
            uint256 amount = fairShare(approvedTokens[i].balanceOf(address(this)), shares, totalShares);
            emit Withdrawal(receiver, address(approvedTokens[i]), amount);
            require(approvedTokens[i].transfer(receiver, amount), "Transfer failed");
        }
        return true;
    }

    // 提现指定代币函数
    function withdrawToken(
        IERC20 token,
        address receiver,
        uint256 amount
    ) public onlyOwner returns (bool) {
        emit Withdrawal(receiver, address(token), amount);
        return token.transfer(receiver, amount);
    }

    // 计算公平份额的内部函数
    function fairShare(
        uint256 balance,
        uint256 shares,
        uint256 totalShares
    ) internal pure returns (uint256) {
        require(totalShares != 0, "Total shares cannot be zero");

        if (balance == 0) {
            return 0;
        }

        uint256 prod = balance * shares;

        // 检查乘法是否溢出
        if (prod / balance == shares) {
            return prod / totalShares;
        }

        // 如果溢出则使用另一种计算方式
        return (balance / totalShares) * shares;
    }
}

// ERC20接口定义（用于兼容ERC20代币）
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}
