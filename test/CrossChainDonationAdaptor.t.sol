// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import { console2 } from "forge-std/console2.sol";
import {CrossChainDonationAdaptor} from "../src/CrossChainDonationAdaptor.sol";
import {Optimism_Addresses} from "./ForkAddresses.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract CrossChainDonationAdaptorTest is Test, Optimism_Addresses {

    CrossChainDonationAdaptor public xChainAdaptor;
    function setUp() public virtual {
        // fork optimism
        string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        vm.createSelectFork({ urlOrAlias: "optimism", blockNumber: 16_428_000 });
        //deploy adaptor        
        xChainAdaptor = new CrossChainDonationAdaptor(Connext_Core);
    }


    function test_receiveVote() external {

    }
}
