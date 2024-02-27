// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { ForwarderXReceiver } from "connext-integration/contracts/destination/xreceivers/ForwarderXReceiver.sol";
import { IAllo } from "./interfaces/IAllo.sol";

contract CrossChainDonationAdapter is ForwarderXReceiver {
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
        (bytes memory _data,,,) = abi.decode(_preparedData, (bytes, bytes32, uint256, address));

        // the voter could also be moved into the allocateData to stay consistent with the Allo interface
        (bytes memory _allocateData, uint256 _poolId, address _voter) = abi.decode(_data, (bytes, uint256, address));

        IAllo(alloV2).allocate(_poolId, _voter, _allocateData);

        return true;
    }
}
