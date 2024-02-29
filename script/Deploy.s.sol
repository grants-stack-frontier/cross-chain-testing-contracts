// // SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { MockAllo } from "../src/MockAllo.sol";
import { CrossChainDonationAdapter } from "../src/CrossChainDonationAdapter.sol";

import { BaseScript } from "./Base.s.sol";
import "forge-std/console2.sol";

error UnsupportedChainId();

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    address public connextCore;

    function run() public broadcast returns (MockAllo allo, CrossChainDonationAdapter adapter) {
        console2.log(block.chainid);
        if (block.chainid != 10  && block.chainid != 42161) revert UnsupportedChainId();

        if (block.chainid == 10) {
            connextCore = 0x8f7492DE823025b4CfaAB1D34c58963F2af5DEDA;
        } else if (block.chainid == 42161){

            connextCore == 0xEE9deC2712cCE65174B561151701Bf54b99C24C8;
        }

        allo = new MockAllo();
        adapter = new CrossChainDonationAdapter(connextCore, address(allo));
    }
}
