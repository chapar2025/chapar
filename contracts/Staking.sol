// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {

    IERC20 public CHPR;
    uint256 public rewardRate; // درصد سالانه پاداش

    struct StakeInfo {
        uint256 amount;
        uint256 since;
    }

    mapping(address => StakeInfo) public stakes;

    constructor(IERC20 _CHPR, uint256 _rewardRate) {
        CHPR = _CHPR;
        rewardRate = _rewardRate;
    }

    // استیک کردن توکن
    function stake(uint256 amount) external {
        require(amount > 0, "Amount > 0 required");
        CHPR.transferFrom(msg.sender, address(this), amount);

        StakeInfo storage info = stakes[msg.sender];

        // جمع کردن پاداش قبلی قبل از افزایش مقدار
        if(info.amount > 0) {
            uint256 reward = calculateReward(msg.sender);
            info.amount += reward;
        }

        info.amount += amount;
        info.since = block.timestamp;
    }

    // برداشت توکن به همراه پاداش
    function withdraw(uint256 amount) external {
        StakeInfo storage info = stakes[msg.sender];
        require(info.amount >= amount, "Insufficient staked");

        uint256 reward = calculateReward(msg.sender);
        uint256 total = info.amount + reward;

        require(total >= amount, "Not enough including rewards");

        info.amount = total - amount;
        info.since = block.timestamp;

        CHPR.transfer(msg.sender, amount);
    }

    // محاسبه پاداش
    function calculateReward(address staker) public view returns (uint256) {
        StakeInfo storage info = stakes[staker];
        if(info.amount == 0) return 0;
        uint256 duration = block.timestamp - info.since;
        return info.amount * rewardRate * duration / 365 days / 100;
    }
}
