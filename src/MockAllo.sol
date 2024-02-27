// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { IAllo } from "./interfaces/IAllo.sol";


contract MockAllo is IAllo {
    // solhint-disable-next-line no-empty-blocks
    constructor() { }

    function allocate(uint256 poolId, address allocator, bytes calldata data) external payable {
        // allocateData parameters:
        // address, (((address, uint256), uint256, uint256), bytes)
        // recipientId, (((token, amount), nonce, deadline), signature)

        (
            address recipientId,
            (((address token, uint256 amount), uint256 nonce, uint256 deadline), bytes memory signature)
        ) = abi.decode(data, (address, (((address, uint256), uint256, uint256), bytes)));


        
        emit VoteReceived(voter, poolId, amount, preparedData);
    }
}
