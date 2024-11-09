// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract PropertyTransaction {
    enum Status { Pending, Completed, Cancelled }

    struct Transaction {
        uint id;
        uint propertyId;
        address buyer;
        address seller;
        uint amount;
        Status status;
    }

    mapping(uint => Transaction) public transactions;
    uint public transactionCount;

    event TransactionInitiated(uint id, uint propertyId, address buyer, address seller, uint amount);
    event TransactionCompleted(uint id);
    event TransactionCancelled(uint id);

    function initiateTransaction(uint _propertyId, address _seller, uint _amount) public payable {
        require(msg.value == _amount, "Insufficient funds sent");
        transactionCount++;
        transactions[transactionCount] = Transaction(transactionCount, _propertyId, msg.sender, _seller, _amount, Status.Pending);
        emit TransactionInitiated(transactionCount, _propertyId, msg.sender, _seller, _amount);
    }

    function completeTransaction(uint _id) public {
        Transaction storage transaction = transactions[_id];
        require(transaction.status == Status.Pending, "Transaction not pending");
        require(transaction.buyer == msg.sender || transaction.seller == msg.sender, "Only buyer or seller can complete the transaction");
        
        transaction.status = Status.Completed;
        payable(transaction.seller).transfer(transaction.amount);
        emit TransactionCompleted(_id);
    }

    function cancelTransaction(uint _id) public {
        Transaction storage transaction = transactions[_id];
        require(transaction.status == Status.Pending, "Transaction not pending");
        require(transaction.buyer == msg.sender || transaction.seller == msg.sender, "Only buyer or seller can cancel the transaction");
        
        transaction.status = Status.Cancelled;
        payable(transaction.buyer).transfer(transaction.amount);
        emit TransactionCancelled(_id);
    }
}
