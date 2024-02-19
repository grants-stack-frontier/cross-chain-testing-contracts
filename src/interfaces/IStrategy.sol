// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.20;

///@dev this is a stripped down version of IStrategy.sol from allo-v2.
///  rather than import the interface and face compiler errors I copied it over into this file.
interface IStrategy {
 
    function allocate(bytes memory _data, address _sender) external payable;

    function distribute(address[] memory _recipientIds, bytes memory _data, address _sender) external;
}
