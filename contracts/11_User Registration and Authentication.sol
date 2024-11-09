// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistration {
    enum Role { Buyer, Seller, Agent, Lawyer }
    
    struct User {
        string name;
        address userAddress;
        Role role;
        bool registered;
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed userAddress, string name, Role role);

    function registerUser(string memory _name, Role _role) public {
        require(!users[msg.sender].registered, "User already registered");
        users[msg.sender] = User(_name, msg.sender, _role, true);
        emit UserRegistered(msg.sender, _name, _role);
    }
}
