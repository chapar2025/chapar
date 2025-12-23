// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasury is Ownable {

    IERC20 public CHPR;

    uint256 public feePercent; // مثال: 0.5٪ = 50 basis points
    address public stakingPool;
    address public devFund;

    constructor(IERC20 _CHPR, address _stakingPool, address _devFund, uint256 _feePercent) {
        CHPR = _CHPR;
        stakingPool = _stakingPool;
        devFund = _devFund;
        feePercent = _feePercent;
    }

    // جمع‌آوری و تقسیم fees
    function collectFee(address from, uint256 amount) external onlyOwner returns(uint256) {
        uint256 fee = amount * feePercent / 10000;
        uint256 remaining = amount - fee;

        // ارسال نصف fee به staking pool و نصف دیگر به dev fund
        uint256 half = fee / 2;
        CHPR.transfer(stakingPool, half);
        CHPR.transfer(devFund, fee - half);

        return remaining; // مقداری که merchant دریافت می‌کند
    }

    // تغییر درصد fee
    function setFeePercent(uint256 newFee) external onlyOwner {
        feePercent = newFee;
    }
}
