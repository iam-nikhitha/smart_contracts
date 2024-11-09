// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateTransaction {

    // Roles
    enum Role { Buyer, Seller, Agent, Arbitrator }

    // Transaction statuses
    enum Status { Initiated, InEscrow, ConditionVerified, Completed, Dispute, Resolved }

    // Structure for a property transaction
    struct Transaction {
        address buyer;
        address seller;
        uint256 propertyId;
        uint256 amount;
        uint256 escrowFee;
        Status status;
        bool fundsInEscrow;
        bool documentsVerified;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => bool) public disputes;

    uint256 public transactionCount;
    address public arbitrator;

    event TransactionInitiated(uint256 transactionId, address buyer, address seller, uint256 propertyId, uint256 amount, uint256 escrowFee);
    event EscrowDeposit(uint256 transactionId, uint256 amount);
    event DocumentsVerified(uint256 transactionId);
    event FundsReleased(uint256 transactionId, address to);
    event TransactionCompleted(uint256 transactionId);
    event DisputeRaised(uint256 transactionId, address by);
    event DisputeResolved(uint256 transactionId, string decision);

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only arbitrator can resolve disputes");
        _;
    }

    constructor(address _arbitrator) {
        arbitrator = _arbitrator;
    }

    // Initiate a new transaction
    function initiateTransaction(address _seller, uint256 _propertyId, uint256 _amount, uint256 _escrowFee) external payable {
        require(msg.value == _escrowFee, "Escrow fee must be paid to initiate transaction");
        
        transactionCount++;
        transactions[transactionCount] = Transaction({
            buyer: msg.sender,
            seller: _seller,
            propertyId: _propertyId,
            amount: _amount,
            escrowFee: _escrowFee,
            status: Status.Initiated,
            fundsInEscrow: false,
            documentsVerified: false
        });

        emit TransactionInitiated(transactionCount, msg.sender, _seller, _propertyId, _amount, _escrowFee);
    }

    // Buyer deposits funds into escrow
    function depositToEscrow(uint256 _transactionId) external payable {
        Transaction storage txDetails = transactions[_transactionId];
        require(msg.sender == txDetails.buyer, "Only buyer can deposit to escrow");
        require(msg.value == txDetails.amount, "Incorrect deposit amount");
        require(txDetails.status == Status.Initiated, "Transaction not in initiated state");

        txDetails.fundsInEscrow = true;
        txDetails.status = Status.InEscrow;

        emit EscrowDeposit(_transactionId, msg.value);
    }

    // Seller verifies documents
    function verifyDocuments(uint256 _transactionId) external {
        Transaction storage txDetails = transactions[_transactionId];
        require(msg.sender == txDetails.seller, "Only seller can verify documents");
        require(txDetails.status == Status.InEscrow, "Transaction not in escrow");

        txDetails.documentsVerified = true;
        txDetails.status = Status.ConditionVerified;

        emit DocumentsVerified(_transactionId);
    }

    // Release funds to the seller once all conditions are met
    function releaseFunds(uint256 _transactionId) external {
        Transaction storage txDetails = transactions[_transactionId];
        require(txDetails.documentsVerified, "Documents must be verified before releasing funds");
        require(txDetails.fundsInEscrow, "Funds must be in escrow");

        txDetails.status = Status.Completed;

        (bool success, ) = txDetails.seller.call{value: txDetails.amount}("");
        require(success, "Fund transfer failed");

        // Return escrow fee to the buyer
        (success, ) = txDetails.buyer.call{value: txDetails.escrowFee}("");
        require(success, "Escrow fee return failed");

        emit FundsReleased(_transactionId, txDetails.seller);
        emit TransactionCompleted(_transactionId);
    }

    // Raise a dispute during the transaction process
    function raiseDispute(uint256 _transactionId) external {
        Transaction storage txDetails = transactions[_transactionId];
        require(msg.sender == txDetails.buyer || msg.sender == txDetails.seller, "Only buyer or seller can raise a dispute");
        require(txDetails.status == Status.InEscrow || txDetails.status == Status.ConditionVerified, "Cannot raise dispute at this stage");

        txDetails.status = Status.Dispute;
        disputes[_transactionId] = true;

        emit DisputeRaised(_transactionId, msg.sender);
    }

    // Arbitrator resolves the dispute
    function resolveDispute(uint256 _transactionId, string memory _decision) external onlyArbitrator {
        Transaction storage txDetails = transactions[_transactionId];
        require(txDetails.status == Status.Dispute, "No dispute to resolve");

        txDetails.status = Status.Resolved;
        disputes[_transactionId] = false;

        emit DisputeResolved(_transactionId, _decision);
    }

    // Function to get transaction details
    function getTransaction(uint256 _transactionId) external view returns (
        address buyer,
        address seller,
        uint256 propertyId,
        uint256 amount,
        uint256 escrowFee,
        Status status,
        bool fundsInEscrow,
        bool documentsVerified
    ) {
        Transaction storage txDetails = transactions[_transactionId];
        return (
            txDetails.buyer,
            txDetails.seller,
            txDetails.propertyId,
            txDetails.amount,
            txDetails.escrowFee,
            txDetails.status,
            txDetails.fundsInEscrow,
            txDetails.documentsVerified
        );
    }
}
