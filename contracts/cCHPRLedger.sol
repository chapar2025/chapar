// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract cCHPRLedger {

    mapping(address => uint256) public balances;
    address public controller;

    modifier onlyController() {
        require(msg.sender == controller, "Not authorized");
        _;
    }

    constructor(address _controller) {
        controller = _controller;
    }

    // اعتبار دادن به کاربر (مثلاً بعد از تبدیل CHPR به cCHPR)
    function credit(address user, uint256 amount) external onlyController {
        balances[user] += amount;
    }

    // برداشت از موجودی کاربر
    function debit(address user, uint256 amount) external onlyController {
        require(balances[user] >= amount, "Insufficient cCHPR");
        balances[user] -= amount;
    }

    // مشاهده موجودی
    function balanceOf(address user) external view returns(uint256) {
        return balances[user];
    }
}
