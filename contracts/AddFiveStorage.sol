// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/* 
 *  In order for a contract to be able to inherent something form another 
 *  contract, we need the following:
 *  1. import the smart contract
 *  2. inherent the imported contract functionalities using "is"
 */
import {SimpleStorage} from "./SimpleStorage.sol";

/* 
 *  To override a function, two things need to be in place:
 *  1. in the Parent contract: the function in questions must include "virtual" specifier.
 *  2. in the Child contract: the implementation must include "override" specifier.
 */
contract AddFiveStorage is SimpleStorage {
    function store(uint256 _newNumber) public override  {
        myFavoriteNumber = _newNumber + 5;
    }    
}