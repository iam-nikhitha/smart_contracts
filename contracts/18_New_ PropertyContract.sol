// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyContract {
    struct Property {
        uint propertyId;
        string propertyDetails;
        uint price;
        address owner;
    }

    mapping(uint => Property) private properties;
    uint[] private propertyIds;

    event PropertyListed(uint propertyId, string propertyDetails, uint price, address owner);
    event PropertyUpdated(uint propertyId, string propertyDetails, uint price);
    event PropertyRemoved(uint propertyId);

    function addProperty(uint propertyId, string memory propertyDetails, uint price) public {
        require(properties[propertyId].owner == address(0), "Property already exists");
        properties[propertyId] = Property(propertyId, propertyDetails, price, msg.sender);
        propertyIds.push(propertyId);
        emit PropertyListed(propertyId, propertyDetails, price, msg.sender);
    }

    function updateProperty(uint propertyId, string memory propertyDetails, uint price) public {
        require(properties[propertyId].owner == msg.sender, "Only owner can update the property");
        properties[propertyId].propertyDetails = propertyDetails;
        properties[propertyId].price = price;
        emit PropertyUpdated(propertyId, propertyDetails, price);
    }

    function removeProperty(uint propertyId) public {
        require(properties[propertyId].owner == msg.sender, "Only owner can remove the property");
        delete properties[propertyId];
        emit PropertyRemoved(propertyId);
    }

    function getProperty(uint propertyId) public view returns (string memory, uint) {
        Property memory property = properties[propertyId];
        return (property.propertyDetails, property.price);
    }
}
