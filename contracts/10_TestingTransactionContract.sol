// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // automatically injected by Remix.
import "contracts/7_TransactionContract.sol"; // Adjust the path to your TransactionContract.

contract TestTransactionContract {
    TransactionContract transactionContract;

    function beforeAll() public {
        transactionContract = new TransactionContract();
    }

    /// Test initiating a transaction
    function testInitiateTransaction() public {
        transactionContract.initiateTransaction{value: 100000}(1, payable(address(0x123)));
        Assert.equal(uint(transactionContract.state()), uint(TransactionContract.State.Created), "State should be 'Created'");
        Assert.equal(transactionContract.value(), 100000, "Transaction value should be 100000");
    }

    /// Test confirming a transaction
    function testConfirmTransaction() public {
        transactionContract.confirmTransaction();
        Assert.equal(uint(transactionContract.state()), uint(TransactionContract.State.Locked), "State should be 'Locked'");
    }

    /// Test completing a transaction
    function testCompleteTransaction() public {
        transactionContract.completeTransaction();
        Assert.equal(uint(transactionContract.state()), uint(TransactionContract.State.Inactive), "State should be 'Inactive'");
    }
}
