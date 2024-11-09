// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract PaymentProcessing {
    struct Payment {
        uint id;
        address from;
        address to;
        uint amount;
        uint timestamp;
    }

    mapping(uint => Payment) public payments;
    uint public paymentCount;

    event PaymentMade(uint id, address from, address to, uint amount, uint timestamp);

    function makePayment(address _to) public payable {
        require(msg.value > 0, "No funds sent");
        paymentCount++;
        payments[paymentCount] = Payment(paymentCount, msg.sender, _to, msg.value, block.timestamp);
        emit PaymentMade(paymentCount, msg.sender, _to, msg.value, block.timestamp);
        payable(_to).transfer(msg.value);
    }
}
