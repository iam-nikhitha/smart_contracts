// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserContract {
    struct User {
        address walletAddress;
        string email;
        bool isRegistered;
        string verificationCode;  // New field for verification code
    }

    mapping(address => User) public users;
    event UserRegistered(address indexed user, string email, string verificationCode);

    // Register user with email but mark them as not verified until the code is confirmed
    function registerUser(string memory email) public {
        require(!users[msg.sender].isRegistered, "User already registered");
        
        // Generate a mock verification code (e.g., "1234")
        string memory code = "1234";  // In a real scenario, this would be generated dynamically
        
        // Store the user with the generated verification code but set isRegistered to false
        users[msg.sender] = User({
            walletAddress: msg.sender,
            email: email,
            isRegistered: false,  // User is not fully registered until verified
            verificationCode: code
        });

        emit UserRegistered(msg.sender, email, code);
    }

    // Simulate sending a verification code to the user (this function would send the code in a real system)
    function sendVerificationCode() public view returns (string memory) {
        require(bytes(users[msg.sender].email).length > 0, "User is not registered");
        return users[msg.sender].verificationCode;  // In practice, you'd send this to the user's email
    }

    // Verify the user by matching the entered code with the stored code
    function verifyUser(string memory code) public {
        require(bytes(users[msg.sender].verificationCode).length > 0, "User is not registered");
        require(!users[msg.sender].isRegistered, "User is already verified");
        
        // Check if the entered code matches the stored verification code
        require(keccak256(abi.encodePacked(users[msg.sender].verificationCode)) == keccak256(abi.encodePacked(code)), "Invalid verification code");

        // Mark the user as verified
        users[msg.sender].isRegistered = true;
    }

    // Check if a user is registered (and verified)
    function isUserRegistered(address userAddress) public view returns (bool) {
        return users[userAddress].isRegistered;
    }
}

