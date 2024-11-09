// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserContract {
    struct User {
        address userAddress;
        string userDetails;
        bool isRegistered;
    }

    mapping(address => User) private users;

    event UserRegistered(address userAddress, string userDetails);

    function registerUser(address userAddress, string memory userDetails) public {
        require(!users[userAddress].isRegistered, "User already registered");
        users[userAddress] = User(userAddress, userDetails, true);
        emit UserRegistered(userAddress, userDetails);
    }

    function authenticateUser(address userAddress) public view returns (bool) {
        return users[userAddress].isRegistered;
    }

    function isUserRegistered(address userAddress) public view returns (bool) {
        return users[userAddress].isRegistered;
    }
}
