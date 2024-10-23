// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    // attaching all the functions in PriceConverter library to any uint256's
    using PriceConverter for uint256;
    
    
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
     *  Note: getConversionRate() definition takes in a uint256 parameter. Here its not being explicity passed. 
     *  Instead: the uint256 value of msg.value will be passed as a first argument into getConversionRate().
     */
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    
    function withdraw() public {
        
        // resetting the mapping:
        for(uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }

        // Resetting the Array:
        funders = new address[](0);

        // Withdrawing Funds:
        // 3 different ways to do it:

        // Method one: transfer
        // In Solidity, in order to send native blockchain tokens,
        // We can only use paybale address type not address type. Thus the type casting
        // transfer: automatically reverts if the tx fails 
        // payable(msg.sender).transfer(address(this).balance);
        
        // Method two: send
        // send: does not automatically revert if the tx fails
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed!");

        /* 
        * Method three: call
        * lower level command
        * Can be used to call any function in Ethereum without even having ABI
        * We will use this method going forward
        * 
        *
        *
        *
        */
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }
}