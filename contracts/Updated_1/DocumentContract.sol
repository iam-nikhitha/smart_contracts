// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentContract {
    struct Document {
        uint256 id;
        address uploader;
        string hash;
        bool isVerified;
    }

    uint256 public documentCount;
    mapping(uint256 => Document) public documents;

    event DocumentUploaded(uint256 documentId, address indexed uploader, string hash);
    event DocumentVerified(uint256 documentId);

    function uploadDocument(string memory hash) public {
        documentCount++;
        documents[documentCount] = Document({
            id: documentCount,
            uploader: msg.sender,
            hash: hash,
            isVerified: false
        });

        emit DocumentUploaded(documentCount, msg.sender, hash);
    }

    function verifyDocument(uint256 documentId) public {
        Document storage document = documents[documentId];
        require(!document.isVerified, "Document is already verified");

        document.isVerified = true;

        emit DocumentVerified(documentId);
    }

    function isDocumentVerified(uint256 documentId) public view returns (bool) {
        return documents[documentId].isVerified;
    }
}
