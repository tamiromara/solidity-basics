// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// Remember: 
// - libraries can't have any state variables
// - all functions have been marked internal
//
library PriceConverter {

    function getPrice() public view returns(uint256) {
        
        /*  
         *  Create interface object by pointing to the price feed proxy address
         *  as we're only interested in the price value for the return as per documentation
         *  price feed is int256 as some price feeds can be negative
         * 
         *  msg.value (18) has different decimal palces than price (8)
         *  To fix this:
         *      (1) multiply answer by 10: answer * 1e10, which will add the additional 10 decimals
         *      (2) price is an int256 while msg.value uint256, so we can cast the price into uint256
         */
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    /*
     *  getConversionRate() takes in an ETH amount and returns its equivilent in USD:
     *  getPrice() is called and value in USD is assigned to ethPrice. Example: 2000_000000000000000000
     *  ethAmountInUsd stores a normalized USD amount by removing all 18 decimal places
     */
    
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}