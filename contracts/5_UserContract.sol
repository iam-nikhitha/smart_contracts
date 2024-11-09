// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserContract {
    struct User {
        uint id;
        string name;
        string role; // Buyer, Seller, Agent
    }
    mapping(address => User) public users;
    uint public userCount;

    function registerUser(string memory name, string memory role) public {
        require(bytes(users[msg.sender].name).length == 0, "User already registered");
        userCount++;
        users[msg.sender] = User(userCount, name, role);
    }

    function getUser(address userAddress) public view returns (User memory) {
        return users[userAddress];
    }

}
