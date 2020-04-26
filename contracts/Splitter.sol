pragma solidity 0.5.0;

import "./Stoppable.sol";
import "./SafeMath.sol";

contract Splitter is Stoppable {

    using SafeMath for uint;

    mapping (address => uint) public balances;
    uint constant ONEWEI = 1;

    event LogSplitFunds(address sender, uint amount_to_split, address to_address1, address to_address2);
    event LogWithdrawFunds(address sender, uint amount_to_withdraw);

    function splitFunds(address toAddress1, address toAddress2) public payable ifRunning returns(bool success) {
        require(msg.value > 0, 'failed to get funds from sender');
        balances[toAddress1] = balances[toAddress1].add(msg.value / 2);
        balances[toAddress2] = balances[toAddress2].add(msg.value / 2);
        if (msg.value % 2 == 1){
            balances[msg.sender] = balances[msg.sender].add(ONEWEI);
        }
        emit LogSplitFunds(msg.sender, msg.value, toAddress1, toAddress2);
        return true;
    }

    function withdrawFunds(uint amount_to_withdraw) public ifRunning returns (bool success){
       balances[msg.sender] = balances[msg.sender].sub(amount_to_withdraw);
       msg.sender.transfer(amount_to_withdraw);
       emit LogWithdrawFunds(msg.sender, amount_to_withdraw);
       return true;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
