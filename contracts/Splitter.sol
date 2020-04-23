pragma solidity 0.5.0;

contract Splitter {

    mapping (address => uint) public balances;
    uint constant ONEWEI = 1;

    event LogSplitFunds(address sender, uint amount_to_split, address to_address1, address to_address2);
    event LogWithdrawFunds(address sender, uint amount_to_withdraw);

    function splitFunds(address toAddress1, address toAddress2) public payable returns(bool success) {
        require(msg.value > 0, 'failed to get funds from sender');
        uint amount = msg.value;
        uint splitForAddress1 = amount / 2;
        uint splitForAddress2 = amount / 2;
        if (amount % 2 == 1){
            splitForAddress1 += ONEWEI;
        }

        // Check that funnds have been properly split
        require(amount == splitForAddress1 + splitForAddress2, 'Split funds failed to add up');

        // Note: splitForAddress1 >=1; splitForAddress2 >= 0;
        require(balances[toAddress1] + splitForAddress1 > balances[toAddress1], 'Overflow: balances[toAddress1]');
        require(balances[toAddress2] + splitForAddress2 >= balances[toAddress2], 'Overflow: balances[toAddress2]');
        emit LogSplitFunds(msg.sender, amount, toAddress1, toAddress2);
        balances[toAddress1] += splitForAddress1;
        balances[toAddress2] += splitForAddress2;
        return true;
    }

    function withdrawFunds(uint amount_to_withdraw) public returns (bool success){
       require(balances[msg.sender] >= amount_to_withdraw);
       emit LogWithdrawFunds(msg.sender, amount_to_withdraw);
       balances[msg.sender] -= amount_to_withdraw;
       msg.sender.transfer(amount_to_withdraw);
       return true;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
