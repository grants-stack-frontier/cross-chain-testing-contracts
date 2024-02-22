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
        // block # 116393210 is (Feb-22-2024 02:16:21 PM +UTC)
        uint256 optimisms = vm.createSelectFork({ urlOrAlias: "optimism", blockNumber: 116_506_302 });
        // arb block # 183361773 is (Feb-22-2024 02:15:02 PM +UTC)
        uint256 arbitrums = vm.createFork({ urlOrAlias: "arbitrum", blockNumber: 183_361_773 });
        //deploy adaptor        
        xChainAdaptor = new CrossChainDonationAdaptor(Connext_Core);
    }


    function test_receiveVote() external {

    }
}
