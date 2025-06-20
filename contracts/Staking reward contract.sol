// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingReward {
    address public owner;
    uint256 public rewardRate = 100; // Tokens rewarded per staked ether
    mapping(address => uint256) public balances;
    mapping(address => uint256) public stakingTime;

    constructor() {
        owner = msg.sender;
    }

    // Stake Ether to earn rewards
    function stake() external payable {
        require(msg.value > 0, "Cannot stake 0 Ether");
        balances[msg.sender] += msg.value;
        stakingTime[msg.sender] = block.timestamp;
    }

    // Calculate and return rewards
    function calculateReward(address staker) public view returns (uint256) {
        uint256 stakedTime = block.timestamp - stakingTime[staker];
        return (balances[staker] * rewardRate * stakedTime) / (365 days * 1 ether);
    }

    // Withdraw stake and rewards
    function withdraw() external {
        uint256 stakedAmount = balances[msg.sender];
        require(stakedAmount > 0, "No funds staked");

        uint256 reward = calculateReward(msg.sender);
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(stakedAmount);

        // Reward payout logic (mocked as Ether for simplicity)
        payable(msg.sender).transfer(reward);
    }

    // Fallback to receive Ether
    receive() external payable {}
}
