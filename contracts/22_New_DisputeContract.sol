// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DisputeContract {
    struct Dispute {
        uint disputeId;
        uint transactionId;
        address buyer;
        address seller;
        string reason;
        bool isResolved;
        string resolution;
    }

    mapping(uint => Dispute) private disputes;

    event DisputeRaised(uint disputeId, uint transactionId, address buyer, address seller, string reason);
    event DisputeResolved(uint disputeId, string resolution);

    function raiseDispute(uint disputeId, uint transactionId, address buyer, address seller, string memory reason) public {
        require(disputes[disputeId].disputeId == 0, "Dispute already exists");
        disputes[disputeId] = Dispute(disputeId, transactionId, buyer, seller, reason, false, "");
        emit DisputeRaised(disputeId, transactionId, buyer, seller, reason);
    }

    function resolveDispute(uint disputeId, string memory resolution) public {
        require(disputes[disputeId].disputeId != 0, "Dispute does not exist");
        disputes[disputeId].isResolved = true;
        disputes[disputeId].resolution = resolution;
        emit DisputeResolved(disputeId, resolution);
    }
}
