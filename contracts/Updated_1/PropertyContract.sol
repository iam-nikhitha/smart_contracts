// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserContract.sol";

contract PropertyContract {
    struct Property {
        uint256 id;
        address owner;
        string description;
        uint256 price;
        bool isListed;
    }

    UserContract public userContract;
    uint256 public propertyCount;
    mapping(uint256 => Property) public properties;
    mapping(address => uint256[]) public ownerProperties;

    event PropertyListed(uint256 propertyId, address indexed owner, string description, uint256 price);
    event PropertyUpdated(uint256 propertyId, string description, uint256 price);
    event PropertyRemoved(uint256 propertyId);

    constructor(address userContractAddress) {
        userContract = UserContract(userContractAddress);
    }

    function listProperty(string memory description, uint256 price) public {
        require(userContract.isUserRegistered(msg.sender), "User must be registered");

        propertyCount++;
        properties[propertyCount] = Property({
            id: propertyCount,
            owner: msg.sender,
            description: description,
            price: price,
            isListed: true
        });

        ownerProperties[msg.sender].push(propertyCount);

        emit PropertyListed(propertyCount, msg.sender, description, price);
    }

    function updateProperty(uint256 propertyId, string memory description, uint256 price) public {
        Property storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can update this property");
        require(property.isListed, "Property is not listed");

        property.description = description;
        property.price = price;

        emit PropertyUpdated(propertyId, description, price);
    }

    function removeProperty(uint256 propertyId) public {
        Property storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can remove this property");
        require(property.isListed, "Property is not listed");

        property.isListed = false;

        emit PropertyRemoved(propertyId);
    }

    function getPropertiesByOwner(address owner) public view returns (uint256[] memory) {
        return ownerProperties[owner];
    }

    // Getter function to retrieve property details by ID
    function getProperty(uint256 propertyId) public view returns (uint256, address, string memory, uint256, bool) {
        Property memory property = properties[propertyId];
        return (
            property.id,
            property.owner,
            property.description,
            property.price,
            property.isListed
        );
    }
}
