pragma solidity ^0.5.0;

contract Splitter {
    address public owner;
    address public alice;
    address public bob;
    address public carol;

    uint private aliceDeposite;
    uint private bobFunds;
    uint private carolFunds;

    constructor () public {
        owner = msg.sender;
    }
    
    function RegisterAlice(address _alice) public returns (bool success){
        require (alice == address(0) && bob == address(0) && carol == address(0), 'failed to register Alice');
        
        alice = _alice;
        return true;
    }
    
    function RegisterBob(address _bob) public returns (bool success){
        require (owner != _bob && alice != _bob && alice != address(0) && bob == address(0) && carol == address(0), 'failed to register Bob');
        
        bob = _bob;
        return true;
    }
    
    function RegisterCarol(address _carol) public returns (bool success){
        require (owner != _carol && alice != _carol && bob != _carol && alice != address(0) && bob != address(0) && carol == address(0), 'failed to register Carol');
        
        carol = _carol;
        return true;
    }

    function SplitFundFromAlice() public payable returns(uint) {
        require(alice == msg.sender && msg.value > 0);
        uint oneWei = 1;
        uint amount = msg.value;
        uint splitForBob = amount / 2;
        uint splitForCarol = amount / 2;
        if (amount % 2 == 1){
            splitForBob += oneWei;
        }

        require(amount == splitForBob + splitForCarol);

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
