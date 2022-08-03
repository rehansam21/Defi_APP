// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./DToken.sol";
import "./DaiToken.sol";


contract TokenFarm {
    string public name = "D Token Farm";
    address public owner;
    DToken public dToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DToken _dToken, DaiToken _daiToken) public {
        dToken = _dToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // 1. Stake Tokens (Deposit) function 
    function stakeTokens(uint256 _amount) public {
        //require amount greater than 0
        require(_amount > 0, "Amount should be greater than zero");
        //Transfer Mock Dai Token to this contract for staking 
        daiToken.transferFrom(msg.sender, address(this), _amount);
        //update staking balance
        stakingBalance[msg.sender] += _amount;
        
        //Add user to stakers array only if they haven't staked already
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }
        // update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // 2. Issue Tokens if one person deposit one mDai token gets one dToken
    function issueTokens() public {
        require(owner == msg.sender, "Caller is not Owner");
        //Issue tokens to all staker
        for(uint256 i=0;i<stakers.length;i++){
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient];
            if(balance > 0){
                dToken.transfer(recipient, balance);

            }

        }
    }

        // 3. Unstake or Withdraw Token
        function unstakeTokens() public {

            //Fetch staking balance 
            uint256 balance = stakingBalance[msg.sender];

            require(balance > 0, "Balance cannot be Zero");

            // Transfer Mock Dai tokens to this contracts for staking 
            daiToken.transfer(msg.sender,balance);
            
            //Reset staking Balance 
            stakingBalance[msg.sender] = 0;

            //update staking status
            isStaking[msg.sender] = false;


        }

    




   
}