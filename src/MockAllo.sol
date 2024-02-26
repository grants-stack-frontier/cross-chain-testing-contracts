// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {IAllo} from "./interfaces/IAllo.sol";
contract MockAllo is IAllo {

    constructor() {
    }

    function allocate(uint256 poolId, bytes calldata data)external payable{
        (address voter, uint256 amount, bytes memory preparedData) = abi.decode(data, (address, uint256, bytes));
        emit VoteReceived(voter, poolId, amount, preparedData);

    }

}
