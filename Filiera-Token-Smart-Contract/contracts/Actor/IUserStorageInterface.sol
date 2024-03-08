// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUserStorageInterface {

    // Function to Add User to Smart Contract 
    function addUser(string memory fullName, string memory password, string memory email, address walletConsumer) external;
    // Function to Retrieve User from Smart Contract 
    function getUser(address walletUser) external view returns (uint256, string memory, string memory, string memory, uint256);
    // Function to Delete User from Smart Contract 
    function deleteUser(address walletUser) external returns(bool);

}