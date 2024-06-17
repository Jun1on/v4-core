// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Hooks} from "../libraries/Hooks.sol";
import {IHooks} from "../interfaces/IHooks.sol";
import {IPoolManager} from "../interfaces/IPoolManager.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {BalanceDeltas, BalanceDeltasLibrary} from "../types/BalanceDeltas.sol";
import {PoolId, PoolIdLibrary} from "../types/PoolId.sol";
import {BeforeSwapDeltas, BeforeSwapDeltasLibrary} from "../types/BeforeSwapDeltas.sol";

contract MockHooks is IHooks {
    using PoolIdLibrary for PoolKey;
    using Hooks for IHooks;

    bytes public beforeInitializeData;
    bytes public afterInitializeData;
    bytes public beforeAddLiquidityData;
    bytes public afterAddLiquidityData;
    bytes public beforeRemoveLiquidityData;
    bytes public afterRemoveLiquidityData;
    bytes public beforeSwapData;
    bytes public afterSwapData;
    bytes public beforeDonateData;
    bytes public afterDonateData;

    mapping(bytes4 => bytes4) public returnValues;

    mapping(PoolId => uint16) public lpFees;

    function beforeInitialize(address, PoolKey calldata, uint160, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        beforeInitializeData = hookData;
        bytes4 selector = MockHooks.beforeInitialize.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterInitialize(address, PoolKey calldata, uint160, int24, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        afterInitializeData = hookData;
        bytes4 selector = MockHooks.afterInitialize.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function beforeAddLiquidity(
        address,
        PoolKey calldata,
        IPoolManager.ModifyLiquidityParams calldata,
        bytes calldata hookData
    ) external override returns (bytes4) {
        beforeAddLiquidityData = hookData;
        bytes4 selector = MockHooks.beforeAddLiquidity.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterAddLiquidity(
        address,
        PoolKey calldata,
        IPoolManager.ModifyLiquidityParams calldata,
        BalanceDeltas,
        bytes calldata hookData
    ) external override returns (bytes4, BalanceDeltas) {
        afterAddLiquidityData = hookData;
        bytes4 selector = MockHooks.afterAddLiquidity.selector;
        return
            (returnValues[selector] == bytes4(0) ? selector : returnValues[selector], BalanceDeltasLibrary.ZERO_DELTAS);
    }

    function beforeRemoveLiquidity(
        address,
        PoolKey calldata,
        IPoolManager.ModifyLiquidityParams calldata,
        bytes calldata hookData
    ) external override returns (bytes4) {
        beforeRemoveLiquidityData = hookData;
        bytes4 selector = MockHooks.beforeRemoveLiquidity.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterRemoveLiquidity(
        address,
        PoolKey calldata,
        IPoolManager.ModifyLiquidityParams calldata,
        BalanceDeltas,
        bytes calldata hookData
    ) external override returns (bytes4, BalanceDeltas) {
        afterRemoveLiquidityData = hookData;
        bytes4 selector = MockHooks.afterRemoveLiquidity.selector;
        return
            (returnValues[selector] == bytes4(0) ? selector : returnValues[selector], BalanceDeltasLibrary.ZERO_DELTAS);
    }

    function beforeSwap(address, PoolKey calldata, IPoolManager.SwapParams calldata, bytes calldata hookData)
        external
        override
        returns (bytes4, BeforeSwapDeltas, uint24)
    {
        beforeSwapData = hookData;
        bytes4 selector = MockHooks.beforeSwap.selector;
        return (
            returnValues[selector] == bytes4(0) ? selector : returnValues[selector],
            BeforeSwapDeltasLibrary.ZERO_DELTAS,
            0
        );
    }

    function afterSwap(
        address,
        PoolKey calldata,
        IPoolManager.SwapParams calldata,
        BalanceDeltas,
        bytes calldata hookData
    ) external override returns (bytes4, int128) {
        afterSwapData = hookData;
        bytes4 selector = MockHooks.afterSwap.selector;
        return (returnValues[selector] == bytes4(0) ? selector : returnValues[selector], 0);
    }

    function beforeDonate(address, PoolKey calldata, uint256, uint256, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        beforeDonateData = hookData;
        bytes4 selector = MockHooks.beforeDonate.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterDonate(address, PoolKey calldata, uint256, uint256, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        afterDonateData = hookData;
        bytes4 selector = MockHooks.afterDonate.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function setReturnValue(bytes4 key, bytes4 value) external {
        returnValues[key] = value;
    }

    function setlpFee(PoolKey calldata key, uint16 value) external {
        lpFees[key.toId()] = value;
    }
}
