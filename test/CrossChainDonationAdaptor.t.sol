// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {CrossChainDonationAdaptor} from "../src/CrossChainDonationAdaptor.sol";
import {Contract_Addresses} from "./ForkAddresses.sol";
import {IConnext} from "@connext/interfaces/core/IConnext.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract CrossChainDonationAdaptorTest is Test, Contract_Addresses {

    CrossChainDonationAdaptor public xChainAdaptor;
    uint256 optimisms;
    uint256 arbitrums;

    uint32 arb_chainId = 42161;
    uint32 opt_chainId = 10;

    uint256 donationAmount = 1 ether;
    uint256 slippage = 3;  // 3 = .3%

    bytes _callData;

    event Allocated(address indexed recipientId, uint256 amount, address token, address sender);
    function setUp() public virtual {
        // create Forks
        string memory alchemyApiKey = vm.envString("API_KEY_ALCHEMY");
        // block # 116393210 is (Feb-22-2024 02:16:21 PM +UTC)
        optimisms = vm.createFork({ urlOrAlias: "optimism", blockNumber: 116_506_302 });
        // arb block # 183361773 is (Feb-22-2024 02:15:02 PM +UTC)
        arbitrums = vm.createFork({ urlOrAlias: "arbitrum", blockNumber: 183_361_773 });
        //deploy adaptor     
        vm.selectFork(optimisms);   
        xChainAdaptor = new CrossChainDonationAdaptor(Connext_Core_OPT, Allo_Proxy);
    }


    function test_receiveVote() external {
    vm.expectEmit();
    emit Allocated(recipientId, amount, token, sender);
    IConnext.xcall(arb_chainId, address(xChainAdaptor), WETH_ARB, address(xChainAdaptor), donationAmount, 3, _callData, 0);
    }
}
