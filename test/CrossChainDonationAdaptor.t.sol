// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { console2 } from "forge-std/console2.sol";
import { CrossChainDonationAdaptor } from "../src/CrossChainDonationAdaptor.sol";
import { Contract_Addresses } from "./ForkAddresses.sol";
import { IConnext } from "@connext/interfaces/core/IConnext.sol";
import { IAllo } from "../src/interfaces/IAllo.sol";
import { ISignatureTransfer } from "permit2/interfaces/ISignatureTransfer.sol";
import { PermitHash } from "permit2/libraries/PermitHash.sol";
import { MockAllo } from "../src/MockAllo.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract CrossChainDonationAdaptorTest is Test, Contract_Addresses {
    using PermitHash for ISignatureTransfer.PermitTransferFrom;

    bytes32 public constant _TOKEN_PERMISSIONS_TYPEHASH = keccak256("TokenPermissions(address token,uint256 amount)");
    bytes32 public constant _PERMIT_TRANSFER_FROM_TYPEHASH = keccak256(
        "PermitTransferFrom(TokenPermissions permitted,address spender,uint256 nonce,uint256 deadline)TokenPermissions(address token,uint256 amount)"
    );

    // bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH = keccak256(
    //     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    // );

    bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH =
        0x3c1b4b0682de90d9bc6435f35e24487dca850cf87201701cc3d3ebacf9cbd92d;

    CrossChainDonationAdaptor public xChainAdaptor;
    uint256 optimisms;
    uint256 arbitrums;

    uint32 arb_chainId = 42_161;
    uint32 opt_chainId = 10;

    uint256 slippage = 3; // 3 = .3%

    // Users
    address public voter;
    address public recipient;

    uint256 voterKey;
    uint256 recipientKey;

    //Allo Data

    uint256 poolId = 42;
    uint256 donationAmount = 1 ether;

    address mockAllo;

    struct Permit2Data {
        ISignatureTransfer.PermitTransferFrom permit;
        bytes signature;
    }

    event Allocated(address indexed recipientId, uint256 amount, address token, address sender);

    function setUp() public virtual {
        (voter, voterKey) = makeAddrAndKey("voter");
        (recipient, recipientKey) = makeAddrAndKey("recipient");

        console.log("Voter: ", voter);

        mockAllo = address(new MockAllo());
        xChainAdaptor = new CrossChainDonationAdaptor(Connext_Core_OPT, mockAllo);
    }

    function test_receiveVote() external {
        // Encode permit data
        ISignatureTransfer.PermitTransferFrom memory permitData = ISignatureTransfer.PermitTransferFrom(
            ISignatureTransfer.TokenPermissions({ token: address(0), amount: donationAmount }), 0, 0
        );

        console.log("Hashed permit");
        console.logBytes32(permitData.hash());

        // Get permit signature
        bytes memory signature = getPermitTransferSignature(permitData, voterKey, DOMAIN_SEPARATOR_TYPEHASH);

        // Encode allocate data (recipientId, p2data)
        Permit2Data memory p2data = Permit2Data({ permit: permitData, signature: signature });

        bytes memory allocateData = abi.encode(recipient, p2data);

        // Encode data to relay (allocateData, poolId, voter)
        bytes memory _data = abi.encode(allocateData, poolId, voter);

        // encode data with fallback address
        // (address _fallbackAddress, bytes memory _data) = abi.decode(_callData, (address, bytes));
        bytes memory _callData = abi.encode(address(this), _data);

        // call xReceive on xChainAdaptor
        vm.prank(Connext_Core_OPT);

        vm.recordLogs();
        xChainAdaptor.xReceive(0, donationAmount, Allo_Proxy, address(0), opt_chainId, _callData);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[entries.length - 1].topics[0], keccak256("VoteReceived(address,uint256,uint256,bytes)"));
    }

    function getPermitTransferSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        uint256 privateKey,
        bytes32 domainSeparator
    )
        internal
        view
        returns (bytes memory sig)
    {
        bytes32 tokenPermissions = keccak256(abi.encode(_TOKEN_PERMISSIONS_TYPEHASH, permit.permitted));
        bytes32 msgHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                keccak256(
                    abi.encode(
                        _PERMIT_TRANSFER_FROM_TYPEHASH, tokenPermissions, address(this), permit.nonce, permit.deadline
                    )
                )
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, msgHash);
        return bytes.concat(r, s, bytes1(v));
    }
}
