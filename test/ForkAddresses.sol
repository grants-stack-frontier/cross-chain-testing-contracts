// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Contract_Addresses {
    //ALLO DEPLOYMENTS (same on all chains);
    address public Allo_Registry = 0x4AAcca72145e1dF2aeC137E1f3C5E3D75DB8b5f3;
    address public Allo_Proxy = 0x1133eA7Af70876e64665ecD07C0A0476d09465a1;
    address public Allo_Implementation = 0xB087535DB0df98fC4327136e897A5985E5Cfbd66;
    address public Allo_DonationVotingMerkleDistributionDirectTransferStrategy =
        0xD13ec67938B5E9Cb05A05D8e160daF02Ed5ea9C9;
    address public Allo_ContractFactory = 0xE195743480D1591B79106FF9B296A0cD38aDa807;

    //CONNEXT DEPLOYMENTS OPTIMISM
    address public Connext_Core_OPT = 0x8f7492DE823025b4CfaAB1D34c58963F2af5DEDA;
    address public USDC_Token_OPT = 0x7F5c764cBc14f9669B88837ca1490cCa17c31607;
    address public WETH_OPT = 0x4200000000000000000000000000000000000006;
    address public WETH_UnwrapperOPT = 0x7Fe09d217d646a6213e51b237670Bc326188cB93;

    //CONNEXT DEPLOYMENTS ARBITRUM
    address public Connext_Core_ARB = 0xEE9deC2712cCE65174B561151701Bf54b99C24C8;
    address public USDC_TOKEN_ARB = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;
    address public WETH_ARB = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public WETH_Unwrapper_ARB = 0x429b9eb01362b2799131EfCC44319689b662999D;


    //addresses for fork tests
    address public USDC_WHALE_OPT = 0xDecC0c09c3B5f6e92EF4184125D5648a66E35298;
}
