// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CHPRToken is ERC20, Ownable {

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18;

    constructor(address treasury) ERC20("Chapar", "CHPR") {
        _mint(treasury, MAX_SUPPLY);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
