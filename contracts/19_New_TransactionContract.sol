// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionContract {
    struct Transaction {
        uint transactionId;
        uint propertyId;
        address buyer;
        address seller;
        uint price;
        bool isVerified;
        bool isCompleted;
    }

    mapping(uint => Transaction) private transactions;

    event TransactionInitiated(uint transactionId, uint propertyId, address buyer, address seller, uint price);
    event TransactionVerified(uint transactionId);
    event TransactionCompleted(uint transactionId);

    function initiateTransaction(uint transactionId, uint propertyId, address buyer, address seller, uint price) public {
        require(transactions[transactionId].transactionId == 0, "Transaction already exists");
        transactions[transactionId] = Transaction(transactionId, propertyId, buyer, seller, price, false, false);
        emit TransactionInitiated(transactionId, propertyId, buyer, seller, price);
    }

    function verifyTransaction(uint transactionId) public {
        require(transactions[transactionId].transactionId != 0, "Transaction does not exist");
        transactions[transactionId].isVerified = true;
        emit TransactionVerified(transactionId);
    }

    function completeTransaction(uint transactionId) public {
        require(transactions[transactionId].transactionId != 0, "Transaction does not exist");
        require(transactions[transactionId].isVerified, "Transaction not verified");
        transactions[transactionId].isCompleted = true;
        emit TransactionCompleted(transactionId);
    }
}
