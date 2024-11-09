// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract DisputeResolution {
    enum ResolutionStatus { Pending, Resolved, Rejected }

    struct Dispute {
        uint id;
        uint transactionId;
        address complainant;
        string details;
        ResolutionStatus status;
    }

    mapping(uint => Dispute) public disputes;
    uint public disputeCount;

    event DisputeFiled(uint id, uint transactionId, address complainant, string details);
    event DisputeResolved(uint id);
    event DisputeRejected(uint id);

    function fileDispute(uint _transactionId, string memory _details) public {
        disputeCount++;
        disputes[disputeCount] = Dispute(disputeCount, _transactionId, msg.sender, _details, ResolutionStatus.Pending);
        emit DisputeFiled(disputeCount, _transactionId, msg.sender, _details);
    }

    function resolveDispute(uint _id) public {
        Dispute storage dispute = disputes[_id];
        require(dispute.status == ResolutionStatus.Pending, "Dispute already resolved or rejected");
        dispute.status = ResolutionStatus.Resolved;
        emit DisputeResolved(_id);
    }

    function rejectDispute(uint _id) public {
        Dispute storage dispute = disputes[_id];
        require(dispute.status == ResolutionStatus.Pending, "Dispute already resolved or rejected");
        dispute.status = ResolutionStatus.Rejected;
        emit DisputeRejected(_id);
    }
}
