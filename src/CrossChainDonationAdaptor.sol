// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {SwapForwarderXReceiver} from "connext-integration/contracts/destination/xreceivers/Swap/SwapForwarderXReceiver.sol";
import {IStrategy} from "./interfaces/IStrategy.sol";
contract CrossChainDonationAdaptor is SwapForwarderXReceiver {
    constructor(address _connext) SwapForwarderXReceiver(_connext) {}

    function _forwardFunctionCall(
        bytes memory _preparedData,
        bytes32, /*_transferId*/
        uint256, /*_amount*/
        address /*_asset*/
    )
        internal
        override
        returns (bool)
    {
        (bytes memory _forwardCallData, uint256 _amountOut, address _alloStrategy) =
            abi.decode(_preparedData, (bytes, uint256, address));
        (bytes memory _data, address _sender) = abi.decode(_forwardCallData, (bytes, address));
        
        IStrategy(_alloStrategy).allocate(_data, _sender);
        return true;
    }

}
