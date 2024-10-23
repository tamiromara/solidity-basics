// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


// @chainlink/contracts is an NPM package manager 
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    
    uint256 public minimumUsd = 5e18;

    /*
     *  Creates an array to be populated with our funders (addresses)
     *  Create a mapping between address type and uint256
     *  We can name the types for better code readability (funder, amountFunded)
     */
     address[] public funders;
     mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
    
    /*
     *  (1) Ensures that the sender is contributing at least the minimum required amount in USD.
     *  (2) Record the address of the user who's funding the contract.
     *  (3) Update the amount of ETH the sender has contributed to the contract.
     */
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

        
    }
    
    function withdraw() public {}

    /*  
     *  getPrice(): returns the price of ETH in USD, as a uint256
     *  address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     *  ABI: is given to us by the compiler once the interface is imported and the code is complied ?
     *  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
     *  gives us whatever code we have at the address plus all the functions in the aggregatorV3Interface
     *
     *  We're making it a view function since we're not modifying the state and only accessing storage
     */ 
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