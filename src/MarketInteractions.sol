// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {IPool} from "@aave/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract MarketInteractions {
    // IMP: JUST for testing not at all for PRODUCTION use
    // note : only used in sepolia eth testnet

    IPool public immutable pool;
    IPoolAddressesProvider public immutable provider;

    constructor(address _provider) {
        provider = IPoolAddressesProvider(_provider);
        pool = IPool(provider.getPool());
    }

    function supplyAsset(address _asset, uint256 _amount) external {
        IERC20(_asset).approve(address(pool), _amount);
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        pool.supply(_asset, _amount, onBehalfOf, referralCode);
    }

    function getAccountData()
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        (totalCollateralBase, totalDebtBase, availableBorrowsBase, currentLiquidationThreshold, ltv, healthFactor) =
            pool.getUserAccountData(address(this));
    }

    function borrowAsset(address _asset, uint256 _amount) external {
        address onBehalfOf = address(this);
        uint16 referralCode = 0;
        uint256 interestRateMode = 2; //variable

        pool.borrow(_asset, _amount, interestRateMode, referralCode, onBehalfOf);
    }

    function repayAsset(address _asset, uint256 _amount) external {
        IERC20(_asset).approve(address(pool), _amount);
        address onBehalfOf = address(this);
        uint256 interestRateMode = 2; //variable

        pool.repay(_asset, _amount, interestRateMode, onBehalfOf);
    }

    function withdrawAsset(address _asset, uint256 _amount) external {
        address to = address(this);
        pool.withdraw(_asset, _amount, to);
    }

    function transferERC20(address _asset, address _to, uint256 _amount) external {
        IERC20(_asset).transfer(_to, _amount);
    }
}
