pragma solidity 0.5.0;

contract Splitter {

    mapping (address => uint) public balances;
    bool public isRunning = true;
    uint constant ONEWEI = 1;

    event LogSplitFunds(address sender, uint amount_to_split, address to_address1, address to_address2);
    event LogWithdrawFunds(address sender, uint amount_to_withdraw);
    event LogStopped(address sender);
    event LogResumed(address sender);

    modifier ifRunning {
        require(isRunning);
        _;
    }

    modifier ifStopped {
        require(!isRunning);
        _;
    }

    function splitFunds(address toAddress1, address toAddress2) public payable ifRunning returns(bool success) {
        require(msg.value > 0, 'failed to get funds from sender');
        require(balances[toAddress1] + (msg.value / 2) >= balances[toAddress1], 'Overflow: balances[toAddress1]');
        require(balances[toAddress2] + (msg.value / 2) >= balances[toAddress2], 'Overflow: balances[toAddress2]');
        emit LogSplitFunds(msg.sender, msg.value, toAddress1, toAddress2);
        balances[toAddress1] += msg.value / 2;
        balances[toAddress2] += msg.value / 2;
        if (msg.value % 2 == 1){
            balances[msg.sender] += ONEWEI;
        }
        return true;
    }

    function withdrawFunds(uint amount_to_withdraw) public ifRunning returns (bool success){
       require(balances[msg.sender] >= amount_to_withdraw);
       emit LogWithdrawFunds(msg.sender, amount_to_withdraw);
       balances[msg.sender] -= amount_to_withdraw;
       msg.sender.transfer(amount_to_withdraw);
       return true;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function stop() public ifRunning returns(bool success){
        isRunning = false;
        emit LogStopped(msg.sender);
        return true;
    }

    function resume() public ifStopped returns(bool success){
        isRunning = true;
        emit LogResumed(msg.sender);
        return true;
    }
}
