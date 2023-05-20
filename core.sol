function calculateDelay(address _user, uint256 _amount) internal view returns (uint256) {
    uint256 baseDelay = 2 hours; // default delay
    uint256 trustScore = getUserTrustScore(_user); // get the trust score of the user

    // Decrease delay based on trust score
    uint256 trustScoreDelay = baseDelay * trustScore / 100; 

    // Increase delay based on transaction size (e.g., every 1000 tokens increase delay by 10%)
    uint256 sizeDelay = baseDelay * _amount / 1000 * 10 / 100; 

    return baseDelay - trustScoreDelay + sizeDelay;
}



// transaction details struct
struct Transaction {
    address user;
    uint256 amount;
    uint256 executionTime;
}

// pending transactions mapping
mapping (uint256 => Transaction) public pendingTransactions;

// transaction processing function
function processTransaction(uint256 _transactionId) public {
    require(block.timestamp >= pendingTransactions[_transactionId].executionTime, "Transaction delay period not over");

    // call the function to execute the transaction
    executeTransaction(pendingTransactions[_transactionId].user, pendingTransactions[_transactionId].amount);

    // delete the transaction from the pending list
    delete pendingTransactions[_transactionId];
}

