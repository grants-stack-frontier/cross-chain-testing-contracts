// // SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { MockAllo } from "../src/MockAllo.sol";
import { CrossChainDonationAdapter } from "../src/CrossChainDonationAdapter.sol";

import { BaseScript } from "./Base.s.sol";

error UnsupportedChainId();

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    address public connextCore;

    function run() public broadcast returns (MockAllo allo, CrossChainDonationAdapter adapter) {
        if (block.chainid != 10 && block.chainid != 137 && block.chainid != 42_161 && block.chainid != 250) revert UnsupportedChainId();

        if (block.chainid == 10) connextCore = 0x8f7492DE823025b4CfaAB1D34c58963F2af5DEDA;
        if (block.chainid == 137) connextCore = 0x11984dc4465481512eb5b777E44061C158CF2259;
        if (block.chainid == 42_161) connextCore = 0xEE9deC2712cCE65174B561151701Bf54b99C24C8;
        

        allo = new MockAllo();
        adapter = new CrossChainDonationAdapter(connextCore, address(allo));
    }
}
