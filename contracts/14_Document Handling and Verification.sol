// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract DocumentHandling {
    struct Document {
        uint id;
        string documentHash;
        address uploader;
        bool verified;
    }

    mapping(uint => Document) public documents;
    uint public documentCount;

    event DocumentUploaded(uint id, string documentHash, address uploader);
    event DocumentVerified(uint id);

    function uploadDocument(string memory _documentHash) public {
        documentCount++;
        documents[documentCount] = Document(documentCount, _documentHash, msg.sender, false);
        emit DocumentUploaded(documentCount, _documentHash, msg.sender);
    }

    function verifyDocument(uint _id) public {
        Document storage document = documents[_id];
        require(!document.verified, "Document already verified");
        document.verified = true;
        emit DocumentVerified(_id);
    }
}
