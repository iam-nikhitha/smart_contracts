// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyContract {
    struct Property {
        uint id;
        string title;
        string location;
        uint price;
        address owner;
        bool isListed;
    }

    mapping(uint => Property) public properties;
    uint public propertyCount;

    function listProperty(string memory title, string memory location, uint price) public {
        propertyCount++;
        properties[propertyCount] = Property(propertyCount, title, location, price, msg.sender, true);
    }

    function updateProperty(uint propertyId, uint newPrice) public {
        Property storage property = properties[propertyId];
        require(msg.sender == property.owner, "Only property owner can update the listing");
        property.price = newPrice;
    }

    // Getter to retrieve a property by its ID
    function getProperty(uint propertyId) public view returns (Property memory) {
        return properties[propertyId];
    }
}
