// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {IPool} from "@aave/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {MarketInteractions} from "../src/MarketInteractions.sol";
import {Test, console} from "forge-std/Test.sol";

contract TestMarketInteractions is Test {
    // IMP: JUST for testing not at all for PRODUCTION use
    // note : only used in sepolia eth testnet

    MarketInteractions public marketInteractions;
    address public constant POOL_ADDRESSES_PROVIDER = 0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A;
    address public constant USDC = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;
    address public aUSDC = 0x16dA4541aD1807f4443d92D26044C1147406EB80;
    address public constant USDT = 0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0;
    address public aUSDT = 0xAF0F6e8b0Dc5c913bbF4d14c22B4E78Dd14310B6;

    function setUp() external {
        marketInteractions = new MarketInteractions(POOL_ADDRESSES_PROVIDER);
        deal(USDC, address(marketInteractions), 10 * 1e6, false);
    }

    modifier supply(address _asset, uint256 _amount) {
        console.log("supplying asset");
        marketInteractions.supplyAsset(_asset, _amount);
        console.log("supplying asset done");
        _;
    }

    modifier borrow(address _asset, uint256 _amount) {
        console.log("borrowing asset");
        marketInteractions.borrowAsset(_asset, _amount);
        console.log("borrowing asset done");
        _;
    }

    function testSupplyAsset() external {
        console.log("---- testSupplyAsset ----");
        uint256 balanceBefore = IERC20(USDC).balanceOf(address(marketInteractions));
        marketInteractions.supplyAsset(USDC, 1e6);
        uint256 balanceAfter = IERC20(USDC).balanceOf(address(marketInteractions));
        assert(balanceAfter < balanceBefore);
        console.log("balanceBefore", balanceBefore);
        console.log("balanceAfter", balanceAfter);
        (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = marketInteractions.getAccountData();
        console.log("----");
        console.log("totalCollateralBase", totalCollateralBase);
        console.log("totalDebtBase", totalDebtBase);
        console.log("availableBorrowsBase", availableBorrowsBase);
        console.log("currentLiquidationThreshold", currentLiquidationThreshold);
        console.log("ltv", ltv);
        console.log("healthFactor", healthFactor);
    }

    function testBorrowAsset() external supply(USDC, 5e6) {
        console.log("---- testBorrowAsset ----");
        // console.log("supplying USDC");
        // marketInteractions.supplyAsset(USDC, 5e6);
        console.log("borrowing USDt");
        uint256 balanceBefore = IERC20(USDT).balanceOf(address(marketInteractions));
        marketInteractions.borrowAsset(USDT, 1e6);
        uint256 balanceAfter = IERC20(USDT).balanceOf(address(marketInteractions));
        assert(balanceAfter > balanceBefore);
        console.log("balanceBefore", balanceBefore);
        console.log("balanceAfter", balanceAfter);
        (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = marketInteractions.getAccountData();

        console.log("----");
        console.log("totalCollateralBase", totalCollateralBase);
        console.log("totalDebtBase", totalDebtBase);
        console.log("availableBorrowsBase", availableBorrowsBase);
        console.log("currentLiquidationThreshold", currentLiquidationThreshold);
        console.log("ltv", ltv);
        console.log("healthFactor", healthFactor);
    }

    function testRepayAsset() external supply(USDC, 5e6) borrow(USDT, 1e6) {
        console.log("---- testRepayAsset ----");
        // console.log("supplying USDC");
        // marketInteractions.supplyAsset(USDC, 5e6);
        // console.log("borrowing USDt");
        // marketInteractions.borrowAsset(USDT, 1e6);
        console.log("repaying USDt");
        uint256 balanceBefore = IERC20(USDT).balanceOf(address(marketInteractions));
        marketInteractions.repayAsset(USDT, 1e6);
        uint256 balanceAfter = IERC20(USDT).balanceOf(address(marketInteractions));
        assert(balanceAfter < balanceBefore);
        console.log("balanceBefore", balanceBefore);
        console.log("balanceAfter", balanceAfter);
        (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = marketInteractions.getAccountData();

        console.log("----");
        console.log("totalCollateralBase", totalCollateralBase);
        console.log("totalDebtBase", totalDebtBase);
        console.log("availableBorrowsBase", availableBorrowsBase);
        console.log("currentLiquidationThreshold", currentLiquidationThreshold);
        console.log("ltv", ltv);
        console.log("healthFactor", healthFactor);
    }

    function testWithdrawAsset() external supply(USDC, 5e6) {
        console.log("---- testWithdrawAsset ----");
        // console.log("supplying USDC");
        // marketInteractions.supplyAsset(USDC, 5e6);
        console.log("withdrawing USDC");
        uint256 balanceBefore = IERC20(USDC).balanceOf(address(marketInteractions));
        marketInteractions.withdrawAsset(USDC, 1e6);
        uint256 balanceAfter = IERC20(USDC).balanceOf(address(marketInteractions));
        assert(balanceAfter > balanceBefore);
        console.log("balanceBefore", balanceBefore);
        console.log("balanceAfter", balanceAfter);
        (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = marketInteractions.getAccountData();

        console.log("----");
        console.log("totalCollateralBase", totalCollateralBase);
        console.log("totalDebtBase", totalDebtBase);
        console.log("availableBorrowsBase", availableBorrowsBase);
        console.log("currentLiquidationThreshold", currentLiquidationThreshold);
        console.log("ltv", ltv);
        console.log("healthFactor", healthFactor);
    }
}
