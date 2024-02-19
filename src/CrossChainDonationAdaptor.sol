// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {ForwarderXReceiver} from "connext-integration/contracts/destination/xreceivers/ForwarderXReceiver.sol";
import {IStrategy} from "./interfaces/IStrategy.sol";
contract CrossChainDonationAdaptor is ForwarderXReceiver {

    constructor(address _connext) ForwarderXReceiver(_connext) {}

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

        (bytes memory _forwardCallData, , , ) =
            abi.decode(_preparedData, (bytes, bytes32, uint256, address));

        (bytes memory _alloData, address _alloStrategy, address _sender) =
         abi.decode(_forwardCallData, (bytes, address, address));
        
        IStrategy(_alloStrategy).allocate(_alloData, _sender);

        return true;
    }

}
