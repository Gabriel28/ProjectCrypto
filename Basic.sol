// SPDX-License-Identifier: MIT
// Basic solidity concepts to create my first cripto ERC-20

pragma solidity ^0.8.4;

library SafeMath {

    function sum(uint a, uint b) internal pure returns(uint) {
        uint c = a + b;
        require (c >= a, "Sum, underflow!");
		return c;
	}

    function sub(uint a, uint b) internal pure returns (uint) {
        require (b <= a, "Sub, underflow");
        uint c = b - a;
        return c;
    }

	function mult(uint a, uint b) internal pure returns(uint) {
		if (a == 0) {
            return 0;
        } 

        uint c = a * b;
        require (c / a == b, "Mult overflow");
        return c;
	}

	function div(uint a, uint b) internal pure returns(uint) {
        uint c = a / b;
        return c;
	}
}

contract Ownable {
    
    address public owner;

    event OwnershipTransfered(address newOwnership);

    constructor() {
        owner = msg.sender;
    }

    // modifer only onwer contract
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!!");
        _;
    }

    //Transfer the onwer contract to other contract
    function transferOwnership(address payable newOwnership) onlyOwner public{
        owner = newOwnership;
        emit OwnershipTransfered(owner);
    }
}

contract Basic is Ownable {
    using SafeMath for uint;
    string public text;
    uint256 public number;
    address public userAddress;
    bool public answer;
    /*
        Mapping key => value
    */
    mapping(address => uint) public hasInteracted;
    mapping(address => uint) public balances;

    function setText(string memory inputTest) onlyOwner public {
        text = inputTest;
        interactedContract();
    }
    
    /*
        On a measuring scale 1 ether is equivalent to 1 quintillion WEIS
        I work with decimals with the smallest scales: EJ 1.5 Ether = 1 quintillion WEIS 
    */
    function setNumber(uint256 myNumber) public payable{
        require(msg.value >= 1 ether, "Inssuficient ETH sent.");

        balances[msg.sender] = balances[msg.sender].sum(msg.value);
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
        hasInteracted[msg.sender] = hasInteracted[msg.sender].sum(1);
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

    function sumStored(uint num1) public view returns(uint) {
		return num1.sum(number);
	}
}
