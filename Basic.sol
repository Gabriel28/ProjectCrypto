// SPDX-License-Identifier: MIT
// Basic solidity concepts

pragma solidity ^0.8.4;

contract Basic {
    uint256 public number;
    address public userAddress;
    bool public answer;
    /*
        Mapping key => value
    */
    mapping(address => uint) public hasInteracted;
    mapping(address => uint) public balances;
    /*
        On a measuring scale 1 ether is equivalent to 1 quintillion WEIS
        I work with decimals with the smallest scales: EJ 1.5 Ether = 1 quintillion WEIS 
    */
    function setNumber(uint256 myNumber) public payable{
        require(msg.value >= 1 ether, "Inssuficient ETH sent.");

        balances[msg.sender] += msg.value;
        number = myNumber;
        interactedContract();
    }

    function setUserAddress() public {
        userAddress = msg.sender;
        interactedContract();
    }

    function receivedAnswer(bool trueOrFalse) public {
        answer = trueOrFalse;
        interactedContract();
    }

    function interactedContract() private {
        hasInteracted[msg.sender] += 1;
    }

    /*
        Remember to zero the pending refund before. Sending to prevent re-entrancy atks
    */    
    function withdrawETH() public {
        require(balances[msg.sender] > 0);
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    /* 
        When received address as parameter, it must be declared as payable, but the msg.sender also can be used as payable
    */
    function sendEther(address payable targetAddress) public payable {
        targetAddress.transfer(msg.value);
    }

    /**
        Pure don't change or query blockchaing values
        View can query blockchain values, but don't change values.
        Any onther types can consult and change blockchain values.
    */
    function sub(uint256 num1, uint256 num2) public pure returns (uint256) {
        return num1 - num2;
    }
}
