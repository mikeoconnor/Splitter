pragma solidity 0.5.0;

contract Splitter {
    address public alice;
    address public bob;
    address public carol;

    uint public bobFunds;
    uint public carolFunds;

    event LogRegisterAlice(address sender, address alice);
    event LogRegisterBob(address sender, address bob);
    event LogRegisterCarol(address sender, address carol);
    event LogSplitFunds(address sender, uint amount_from_alice, uint amount_to_bob, uint amount_to_carol);

    function registerAlice(address _alice) public returns (bool success){
        require (alice == address(0) && bob == address(0) && carol == address(0), 'failed to register Alice');
        emit LogRegisterAlice(msg.sender, _alice);
        alice = _alice;
        return true;
    }
    
    function registerBob(address _bob) public returns (bool success){
        require (alice != _bob && alice != address(0) && bob == address(0) && carol == address(0), 'failed to register Bob');
        emit LogRegisterBob(msg.sender, _bob);
        bob = _bob;
        return true;
    }
    
    function registerCarol(address _carol) public returns (bool success){
        require (alice != _carol && bob != _carol && alice != address(0) && bob != address(0) && carol == address(0), 'failed to register Carol');
        emit LogRegisterCarol(msg.sender, _carol);
        carol = _carol;
        return true;
    }

    function splitFundFromAlice() public payable returns(uint) {
        require(alice == msg.sender && msg.value > 0, 'failed to get funds from alice');
        uint oneWei = 1;
        uint amount = msg.value;
        uint splitForBob = amount / 2;
        uint splitForCarol = amount / 2;
        if (amount % 2 == 1){
            require(splitForBob + oneWei > splitForBob, 'Overflow: splitForBob');
            splitForBob += oneWei;
        }

        // Check that funnds have been properly split
        require(amount == splitForBob + splitForCarol, 'Split funds failed to add up');

        // Note: splitForBob >=1; splitForCarol >= 0;
        require(bobFunds + splitForBob > bobFunds, 'Overflow: bobFunds');
        require(carolFunds + splitForCarol >= carolFunds, 'Overflow: carolFunds');
        emit LogSplitFunds(msg.sender, amount, splitForBob, splitForCarol);
        bobFunds += splitForBob;
        carolFunds += splitForCarol;
        return amount;
    }

    function withdrawBob(uint amount) public returns (uint remainingBalance){
        require(bob == msg.sender && bobFunds >= amount, 'failed to get request from bob');
        bobFunds -= amount;
        msg.sender.transfer(amount);
        return bobFunds;
    }

    function withdrawCarol(uint amount) public returns(uint remainingBalance){
        require(carol == msg.sender && carolFunds >= amount, 'failed to get request from carol');
        carolFunds -= amount;
        msg.sender.transfer(amount);
        return carolFunds;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
