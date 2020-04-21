pragma solidity 0.5.0;

contract Splitter {

    mapping (address => uint) public balances;

    event LogSplitFunds(address sender, address to_address1, address to_address2, uint amount_to_split);
    event LogWithdrawFunds(address sender, uint amount_to_withdraw);

    function splitFunds(address toAddress1, address toAddress2) public payable returns(uint) {
        require(msg.value > 0, 'failed to get funds from sender');
        uint oneWei = 1;
        uint amount = msg.value;
        uint splitForAddress1 = amount / 2;
        uint splitForAddress2 = amount / 2;
        if (amount % 2 == 1){
            splitForAddress1 += oneWei;
        }

        // Check that funnds have been properly split
        require(amount == splitForAddress1 + splitForAddress2, 'Split funds failed to add up');

        // Note: splitForAddress1 >=1; splitForAddress2 >= 0;
        require(balances[toAddress1] + splitForAddress1 > balances[toAddress1], 'Overflow: balances[toAddress1]');
        require(balances[toAddress2] + splitForAddress2 >= balances[toAddress2], 'Overflow: balances[toAddress2]');
        emit LogSplitFunds(msg.sender, toAddress1, toAddress2, amount);
        balances[toAddress1] += splitForAddress1;
        balances[toAddress2] += splitForAddress2;
        return amount;
    }

    function withdrawFunds(uint amount_to_withdraw) public returns (uint){
       require(balances[msg.sender] >= amount_to_withdraw);
       emit LogWithdrawFunds(msg.sender, amount_to_withdraw);
       balances[msg.sender] -= amount_to_withdraw;
       msg.sender.transfer(amount_to_withdraw);
       return balances[msg.sender];
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
