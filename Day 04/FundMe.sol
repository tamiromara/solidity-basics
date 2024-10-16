// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// AggregatorV3Interface is an interface defined to interact with Chainlink's Price Feed Contracts
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 5;

    // Array for funders
    address[] public funders;

    // The key of type address:     represents the address of the sender
    // The value of type uint256:   represents the amount of ETH the funder contributed 
    // Can also be written linke this: mapping(address => uint256) public addressToAmountFunded;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    /*
     * payable modifier tells solidity that our function is expecting to receive eth.
     *
     * msg: global variable that carries information about a contract function call.
     * msg.value: value is an attribute of msg. It shows the amount of Eth sent to a contract in wei.
     * 1 ETH = 1000000000000000000 wei = 1 * 10 ** 18
     *
     * fund() uses require() to validate the condition before executing the rest of function.
     * If condition isn't met, the function throws an exception and reverts the transaction minus cost incured.
     */
    function fund() public payable {
        require(msg.value >= 1e18, "Not Enough ETH!");
        
        // each time a payment is successfull add the sender detaisl to the Array funders
        funders.push(msg.sender);

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    /* Returns the value of Ethereum in USD as uint256
     * To do so we will creat two functions: getPrice() & getConversionRate()
     */
    function getPrice() public view returns(uint256){

        // Create an instance of AggregatorV3Interface that points to the contract address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        /* Calls the latestRoundData() method on AggregatorV3Interface object, priceFeed.
         * We are only interested in answer (the price of ETH in USD), so we can ignore the rest of the returned values by using commas (,,,)
         * answer is of type int256 and represents the price of 1 ETH in USD. value returned is not normalized to standard decimal places!
         * answer returned usually has 8 decimal places: 200.00000000 - missing other 10 deceimal places from our 1 Eth = 1.000000000000000000
         * Therefore, we multiply answer by 1e10 (10^10) to scale it up and match a uint256 value which is 1e18.
         * Finally, type cast the returned answer into a uint256 type to keep things standardized.
         */
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    // Takes in ethAmount and converts it into USD
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
                
        // get the price of eth n eth:
        // 2000_000000000000000000
        uint256 ethPrice = getPrice();

        // (2000_000000000000000000 * 1_000000000000000000) / 1_000000000000000000
        // $2000_000000000000000000 = 1 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
    
}
