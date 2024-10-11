//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {

    uint256 myFavoriteNumber;

    //Creating Person type
    struct Person {
        string name;
        uint256 favoriteNumber;
    }

    //Create an Array of persons of the type Person
    //This is a dynamic array as the size is not specified
    Person[] public listOfPeople; //[] creates an empty list

    //Create a mapping types
    mapping(string => uint256) public nameToFavoriteNumber;

    
    //Create variable of the type Person
    //It's better to be explicit white passing the arguments to function
    // Person public tamir = Person({favoriteNumber: 23, name: "Tamir"});

    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return myFavoriteNumber;
    }
    
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Person newPerson = Person(_name, _favoriteNumber);
        // listOfPeople.push(newPerson);
        listOfPeople.push(Person(_name, _favoriteNumber));
        // the mapping
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}