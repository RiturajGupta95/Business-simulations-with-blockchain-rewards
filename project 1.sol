// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC20 interface (standard token on Ethereum)
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BusinessSimulation {
    // Declare the reward token (ERC20 token)
    IERC20 public rewardToken;

    // Declare the contract owner (admin)
    address public owner;

    // Mapping to track users' scores and rewards earned
    mapping(address => uint256) public userScores;
    mapping(address => uint256) public userRewards;

    // Event declarations to log actions
    event ScoreUpdated(address indexed user, uint256 newScore);
    event RewardDistributed(address indexed user, uint256 rewardAmount);

    // Constructor to initialize the contract with the reward token
    constructor(address _rewardToken) {
        rewardToken = IERC20(_rewardToken);
        owner = msg.sender;
    }

    // Modifier to ensure only the owner (admin) can update scores
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can update scores");
        _;
    }

    // Function to update the user's score in the simulation
    function updateScore(address user, uint256 score) external onlyOwner {
        userScores[user] = score;
        emit ScoreUpdated(user, score);

        // Calculate rewards based on the score
        uint256 rewardAmount = calculateRewards(score);

        // Update user's rewards
        userRewards[user] = rewardAmount;

        // Transfer the rewards to the user
        rewardToken.transfer(user, rewardAmount);

        emit RewardDistributed(user, rewardAmount);
    }

    // Function to calculate rewards based on the score (1 token per 100 score points)
    function calculateRewards(uint256 score) public pure returns (uint256) {
        return score / 100;
    }

    // Function to get the reward balance of a specific user
    function getUserRewards(address user) external view returns (uint256) {
        return userRewards[user];
    }

    // Function to withdraw the contract balance (only by the owner)
    function withdrawTokens(uint256 amount) external onlyOwner {
        rewardToken.transfer(owner, amount);
    }
}
