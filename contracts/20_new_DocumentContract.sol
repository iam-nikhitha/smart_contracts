// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentContract {
    struct Document {
        uint documentId;
        string documentHash;
        bool isVerified;
    }

    mapping(uint => Document) private documents;

    event DocumentUploaded(uint documentId, string documentHash);
    event DocumentVerified(uint documentId);

    function uploadDocument(uint documentId, string memory documentHash) public {
        require(documents[documentId].documentId == 0, "Document already exists");
        documents[documentId] = Document(documentId, documentHash, false);
        emit DocumentUploaded(documentId, documentHash);
    }

    function verifyDocument(uint documentId) public {
        require(documents[documentId].documentId != 0, "Document does not exist");
        documents[documentId].isVerified = true;
        emit DocumentVerified(documentId);
    }

    function getDocument(uint documentId) public view returns (string memory, bool) {
        Document memory document = documents[documentId];
        return (document.documentHash, document.isVerified);
    }
}
