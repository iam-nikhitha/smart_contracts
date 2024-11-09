// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionContract {
    // Transaction statuses
    enum Status { Created, InEscrow, ConditionVerified, Completed, Dispute, Resolved }
    Status public status;

    address payable public buyer;
    address payable public seller;
    address public arbitrator;
    uint public value;        // Total amount of Ether for the transaction
    uint public escrowFee;    // Escrow fee in Ether
    uint public propertyId;
    bool public documentsVerified;
    bool public fundsInEscrow;

    mapping(uint256 => bool) public disputes;

    // Events
    event TransactionInitiated(uint256 propertyId, address buyer, address seller, uint256 amount, uint256 escrowFee);
    event EscrowDeposit(uint256 propertyId, uint256 amount);
    event DocumentsVerified(uint256 propertyId);
    event FundsReleased(uint256 propertyId, address to);
    event TransactionCompleted(uint256 propertyId);
    event DisputeRaised(uint256 propertyId, address by);
    event DisputeResolved(uint256 propertyId, string decision);

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this function.");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this function.");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only arbitrator can resolve disputes");
        _;
    }

    modifier inStatus(Status _status) {
        require(status == _status, "Invalid transaction status.");
        _;
    }

    // Constructor with arbitrator address
    constructor(address _arbitrator) {
        arbitrator = _arbitrator;
    }

    // Initiate the transaction with value as the transaction amount and escrow fee (using msg.value for ether)
    function initiateTransaction(uint _propertyId, address payable _seller, uint _escrowFee) public payable {
        require(msg.value > _escrowFee, "Transaction value must be greater than the escrow fee");  // Ensure escrow fee is covered
        
        buyer = payable(msg.sender);
        seller = _seller;
        propertyId = _propertyId;
        escrowFee = _escrowFee;
        value = msg.value - _escrowFee;  // Deduct escrow fee from the sent value
        status = Status.Created;

        emit TransactionInitiated(propertyId, buyer, seller, value, escrowFee);
    }

    // Deposit funds into escrow
    function depositToEscrow() external payable onlyBuyer inStatus(Status.Created) {
        require(msg.value == value, "Incorrect deposit amount");

        fundsInEscrow = true;
        status = Status.InEscrow;

        emit EscrowDeposit(propertyId, msg.value);
    }

    // Verify documents
    function verifyDocuments() external onlySeller inStatus(Status.InEscrow) {
        documentsVerified = true;
        status = Status.ConditionVerified;

        emit DocumentsVerified(propertyId);
    }

    // Release funds to the seller after document verification
    function releaseFunds() external onlyBuyer inStatus(Status.ConditionVerified) {
        require(fundsInEscrow, "Funds are not in escrow");
        require(documentsVerified, "Documents must be verified");

        status = Status.Completed;
        fundsInEscrow = false;

        (bool success, ) = seller.call{value: value}("");
        require(success, "Transfer to seller failed");

        // Return the escrow fee to the buyer
        (success, ) = buyer.call{value: escrowFee}("");
        require(success, "Escrow fee refund failed");

        emit FundsReleased(propertyId, seller);
        emit TransactionCompleted(propertyId);
    }

    // Raise a dispute
    function raiseDispute() external inStatus(Status.ConditionVerified) {
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can raise a dispute");

        status = Status.Dispute;
        disputes[propertyId] = true;

        emit DisputeRaised(propertyId, msg.sender);
    }

    // Arbitrator resolves the dispute
    function resolveDispute(string memory decision) external onlyArbitrator inStatus(Status.Dispute) {
        status = Status.Resolved;
        disputes[propertyId] = false;

        emit DisputeResolved(propertyId, decision);
    }

    // Abort transaction
    function abortTransaction() public onlyBuyer inStatus(Status.Created) {
        buyer.transfer(address(this).balance);
        status = Status.Completed;  // Transaction is marked as completed after aborting
    }

    // Get transaction details
    function getTransactionDetails() external view returns (
        address, address, uint, uint, uint, Status, bool, bool
    ) {
        return (
            buyer,
            seller,
            propertyId,
            value,
            escrowFee,
            status,
            fundsInEscrow,
            documentsVerified
        );
    }
}
