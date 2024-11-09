// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentContract {
    struct Payment {
        uint paymentId;
        address buyer;
        address seller;
        uint amount;
        bool isVerified;
        bool isCompleted;
    }

    mapping(uint => Payment) private payments;

    event PaymentInitiated(uint paymentId, address buyer, address seller, uint amount);
    event PaymentVerified(uint paymentId);
    event PaymentCompleted(uint paymentId);

    function initiatePayment(uint paymentId, address buyer, address seller, uint amount) public {
        require(payments[paymentId].paymentId == 0, "Payment already exists");
        payments[paymentId] = Payment(paymentId, buyer, seller, amount, false, false);
        emit PaymentInitiated(paymentId, buyer, seller, amount);
    }

    function verifyPayment(uint paymentId) public {
        require(payments[paymentId].paymentId != 0, "Payment does not exist");
        payments[paymentId].isVerified = true;
        emit PaymentVerified(paymentId);
    }

    function completePayment(uint paymentId) public {
        require(payments[paymentId].paymentId != 0, "Payment does not exist");
        require(payments[paymentId].isVerified, "Payment not verified");
        payments[paymentId].isCompleted = true;
        emit PaymentCompleted(paymentId);
    }
}
