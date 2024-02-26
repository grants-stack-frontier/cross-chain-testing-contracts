// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.23;

///@dev this is a stripped down version of IStrategy.sol from allo-v2.
///  rather than import the interface and face compiler errors I copied it over into this file.
interface IAllo {
     
     event VoteReceived(address indexed voter, uint256 indexed poolId, uint256 indexed amount, bytes preparedData);

     function allocate(uint256 _poolId, bytes memory _data) external payable;

}
