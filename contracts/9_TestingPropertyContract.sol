// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // automatically injected by Remix.
import "contracts/6_PropertyContract.sol"; // Adjust the path to your PropertyContract.

contract TestPropertyContract {
    PropertyContract propertyContract;

    function beforeAll() public {
        propertyContract = new PropertyContract();
    }

    /// Test property listing
    function testPropertyListing() public {
        propertyContract.listProperty("Dream Home", "123 Main St", 100000);
        PropertyContract.Property memory property = propertyContract.getProperty(1);

        Assert.equal(property.title, "Dream Home", "Property title should be 'Dream Home'");
        Assert.equal(property.location, "123 Main St", "Property location should be '123 Main St'");
        Assert.equal(property.price, 100000, "Property price should be 100000");
        Assert.equal(property.isListed, true, "Property should be listed");  // Corrected line
    }

    /// Test updating property price
    function testUpdatePropertyPrice() public {
        propertyContract.listProperty("Lake House", "456 Lake Rd", 150000);
        propertyContract.updateProperty(2, 160000); // Assuming 2 is the ID for this new property.
        
        PropertyContract.Property memory updatedProperty = propertyContract.getProperty(2);
        Assert.equal(updatedProperty.price, 160000, "Property price should be updated to 160000");
    }
}
