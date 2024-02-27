// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { IAllo } from "./interfaces/IAllo.sol";
import { SignatureVerification } from "permit2/libraries/SignatureVerification.sol";
import { PermitHash } from "permit2/libraries/PermitHash.sol";
import { ISignatureTransfer } from "permit2/interfaces/ISignatureTransfer.sol";
import { SignatureTransfer } from "permit2/SignatureTransfer.sol";

contract MockAllo is IAllo {
    using PermitHash for ISignatureTransfer.PermitTransferFrom;

    SignatureTransfer public signatureTransfer;

    constructor() {
        signatureTransfer = new SignatureTransfer();
    }

    function allocate(uint256 poolId, address voter, bytes memory data) external payable {
        // allocateData parameters:
        // recipientId, (permit2Data, signature)
        // address, (((address, uint256), uint256, uint256), bytes)

        (address recipientId, Permit2Data memory p2Data) = abi.decode(data, (address, Permit2Data));

        uint256 amount = p2Data.permit.permitted.amount;
        address token = p2Data.permit.permitted.token;
        uint256 nonce = p2Data.permit.nonce;
        uint256 deadline = p2Data.permit.deadline;

        //TODO verify signature signer
        // console.log("Verifying signature");
        // this.verify(p2Data.signature, permitData.hash(), voter);

        emit VoteReceived(voter, poolId, amount, data);
    }

    function verify(bytes calldata signature, bytes32 hashedPermit, address signer) external view {
        SignatureVerification.verify(signature, hashedPermit, signer);
    }
}
