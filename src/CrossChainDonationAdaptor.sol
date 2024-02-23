// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {ForwarderXReceiver} from "connext-integration/contracts/destination/xreceivers/ForwarderXReceiver.sol";
import {IAllo} from "./interfaces/IAllo.sol";
contract CrossChainDonationAdaptor is ForwarderXReceiver {
    address public alloV2;
    constructor(address _connext, address _allo) ForwarderXReceiver(_connext) {
        alloV2 = _allo;
    }
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

        (bytes memory _alloData, uint256 _poolId) =
         abi.decode(_forwardCallData, (bytes, uint256));
        
        IAllo(alloV2).allocate(_poolId, _alloData);

        return true;
    }

}
