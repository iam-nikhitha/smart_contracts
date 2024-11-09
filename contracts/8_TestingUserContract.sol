// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "contracts/5_UserContract.sol"; // Adjust the path to your UserContract.

contract TestUserContract {
    UserContract userContract;

    function beforeAll() public {
        userContract = new UserContract();
    }

    /// Test if user registration works
    function testUserRegistration() public {
        userContract.registerUser("Alice", "Buyer");
        UserContract.User memory user = userContract.getUser(msg.sender);
        Assert.equal(user.name, "Alice", "User name should be Alice");
        Assert.equal(user.role, "Buyer", "User role should be Buyer");
    }

    /// Test duplicate registration prevention indirectly
    function testFailRegisterSameUser() public {
        userContract.registerUser("Bob", "Seller");
        // Trying to re-register should fail and not change the user count or details
        try userContract.registerUser("Bob", "Agent") {
            // If this code executes, it means the re-registration didn't revert
            Assert.ok(false, "Expected an error but did not get one");
        } catch {
            // Expected result; catch block means the registration failed as expected
            Assert.ok(true, "Correctly failed to register the same user twice");
        }
    }
}
