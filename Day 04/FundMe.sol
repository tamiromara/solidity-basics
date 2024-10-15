// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    /*
     * payable modifier tells solidity that our function is expecting to receive eth.
     * 
     * Global variables: predefined variables that holds information about the current
     * state of the ethereum blockchain and execution context of the smart contract.
     *
     * msg: global variable that carries information about a contract function call.
     * msg.value: value is an attribute of msg. It shows the amount of Eth sent to a contract in wei.
     * 1 ETH = 1000000000000000000 wei = 1 * 10 ** 18
     *
     * fun() uses require() to validate the condition before executing the rest of fun().
     * If condition isn't met, the function throws an exception and reverts the transaction.
     */
    function fund() public payable {
        require(msg.value > 1e18, "Not Enough ETH!");
    }
}