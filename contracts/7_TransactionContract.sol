// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionContract {
    enum State { Created, Locked, Inactive }
    State public state;

    address payable public buyer;
    address payable public seller;
    uint public value;
    uint public propertyId;

    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }

    function initiateTransaction(uint _propertyId, address payable _seller) public payable {
        buyer = payable(msg.sender);
        seller = _seller;
        propertyId = _propertyId;
        value = msg.value;
        state = State.Created;
    }

    function confirmTransaction() public inState(State.Created) {
        require(msg.sender == buyer, "Only buyer can confirm the transaction.");
        state = State.Locked;
    }

    function completeTransaction() public inState(State.Locked) {
        require(msg.sender == buyer, "Only buyer can complete the transaction.");
        seller.transfer(value);
        state = State.Inactive;
    }

    function abortTransaction() public inState(State.Created) {
        require(msg.sender == buyer, "Only buyer can abort the transaction.");
        buyer.transfer(address(this).balance);
        state = State.Inactive;
    }
}
