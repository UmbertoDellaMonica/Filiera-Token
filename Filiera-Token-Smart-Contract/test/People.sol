// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

contract Project{
    struct Person {
        address addr;
        uint funds;
    }

    Person[] people;

    function addPerson(address addr, uint funds) public {
        Person memory newPerson = Person(addr, funds);
        people.push(newPerson);
    }


    function getPeople() public view returns (address[] memory , uint[] memory ) {
        address[] memory addrs = new address[](indexes.length);
        uint[]    memory funds = new uint[](indexes.length);

        for (uint i = 0; i < indexes.length; i++) {
            Person storage person = people[indexes[i]];
            addrs[i] = person.addr;
            funds[i] = person.funds;
        }

        return (addrs, funds);
    }
}