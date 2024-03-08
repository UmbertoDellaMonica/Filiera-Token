
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


contract UserService {


    struct ListUser{
      User[] users;
    }

    
    struct User {
      address addr;
      string name;
      uint age;
    }


  ListUser private  listUser;


    function getMyStructs() public view returns (ListUser memory) {
      return listUser;
    }

    function addUserStruct(address addr,string memory  name,uint256 age) public {
        User memory new_user = User(addr,name,age);
        listUser.users.push(new_user);
    }



}