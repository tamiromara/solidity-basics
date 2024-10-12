// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/* 
    * should avoid importing like this: import "./SimpleStorage.sol";
    * Only import the contracts you need through named importing:
    * {SimpleStorage, SimpleStorage2, ...}
*/
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    /* 
        * We want to create an Array of the type SimpleStorage that will hold all the 
        * newly populated SimpleStorage contracts.
    */
    SimpleStorage[] public listOfSimpleStorageContracts; 

    // function populates new SimpleStorage contracs and stores them onto the Array
    function createSimpleStorage() public {
        listOfSimpleStorageContracts.push(new SimpleStorage());
    }

    /*
        * To access a contract and modify myFavoriteNumber value in it:
        * First:  access the contract through its location in the Array (index)
        * Second: add the value to modify the variable within the indexed contract
        * sfStore() knows how to do so beucase listOfSimpleStorageContracts comes
        * preloaded with the address of the contract + its ABI (sort of)
    */
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        // // select the desired contract through its index:
        // SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        // // pass the new number as an argument into store() function:
        // mySimpleStorage.store(_newSimpleStorageNumber);

        // The above can be simplified using casting:
        listOfSimpleStorageContracts[_simpleStorageIndex].store(_newSimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        // return mySimpleStorage.retrieve();

        // The above can be simplified using casting:
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }

}