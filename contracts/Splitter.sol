pragma solidity 0.5.0;

contract Splitter {
    address public owner;
    address public alice;
    address public bob;
    address public carol;

    uint private aliceDeposite;
    uint private bobFunds;
    uint private carolFunds;

    event LogRegisterAlice(address alice);
    event LogRegisterBob(address bob);
    event LogRegisterCarol(address carol);
    event LogSplitFunds(address sender, uint amount_from_alice, uint amount_to_bob, uint amount_to_carol);

    constructor () public {
        owner = msg.sender;
    }

    function registerAlice(address _alice) public returns (bool success){
        require (alice == address(0) && bob == address(0) && carol == address(0), 'failed to register Alice');
        emit LogRegisterAlice(_alice);
        alice = _alice;
        return true;
    }
    
    function registerBob(address _bob) public returns (bool success){
        require (owner != _bob && alice != _bob && alice != address(0) && bob == address(0) && carol == address(0), 'failed to register Bob');
        emit LogRegisterBob(_bob);
        bob = _bob;
        return true;
    }
    
    function registerCarol(address _carol) public returns (bool success){
        require (owner != _carol && alice != _carol && bob != _carol && alice != address(0) && bob != address(0) && carol == address(0), 'failed to register Carol');
        emit LogRegisterCarol(_carol);
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
        require(aliceDeposite + amount > aliceDeposite, 'Overflow: aliceDeposite');
        require(bobFunds + splitForBob > bobFunds, 'Overflow: bobFunds');
        require(carolFunds + splitForCarol >= carolFunds, 'Overflow: carolFunds');
        emit LogSplitFunds(msg.sender, amount, splitForBob, splitForCarol);
        aliceDeposite += amount;
        bobFunds += splitForBob;
        carolFunds += splitForCarol;
        return amount;
    }

    function getAliceDeposit() public view returns (uint){
        return aliceDeposite;
    }

    function getBobFunds() public view returns (uint){
        return bobFunds;
    }

    function getCarolFunds() public view returns (uint){
        return carolFunds;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
