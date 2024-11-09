// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract PropertyListing {
    struct Property {
        uint id;
        string name;
        string location;
        uint price;
        address owner;
        bool forSale;
    }

    mapping(uint => Property) public properties;
    uint public propertyCount;

    event PropertyListed(uint id, string name, string location, uint price, address owner);
    event PropertyUpdated(uint id, string name, string location, uint price);
    event PropertyRemoved(uint id);

    function listProperty(string memory _name, string memory _location, uint _price) public {
        propertyCount++;
        properties[propertyCount] = Property(propertyCount, _name, _location, _price, msg.sender, true);
        emit PropertyListed(propertyCount, _name, _location, _price, msg.sender);
    }

    function updateProperty(uint _id, string memory _name, string memory _location, uint _price) public {
        Property storage property = properties[_id];
        require(property.owner == msg.sender, "Only owner can update the property");
        property.name = _name;
        property.location = _location;
        property.price = _price;
        emit PropertyUpdated(_id, _name, _location, _price);
    }

    function removeProperty(uint _id) public {
        Property storage property = properties[_id];
        require(property.owner == msg.sender, "Only owner can remove the property");
        delete properties[_id];
        emit PropertyRemoved(_id);
    }
}
