pragma solidity ^0.5.0;

contract Splitter {
    address public owner;
    address public alice;
    address public bob;
    address public carol;
    
    constructor () public {
        owner = msg.sender;
    }
    
    function RegisterAlice(address _alice) public returns (bool success){
        require (alice == address(0) && bob == address(0) && carol == address(0));
        
        alice = _alice;
        return true;
    }
    
    function RegisterBob(address _bob) public returns (bool success){
        require (owner != _bob && alice != _bob && alice != address(0) && bob == address(0) && carol == address(0));
        
        bob = _bob;
        return true;
    }
    
    function RegisterCarol(address _carol) public returns (bool success){
        require (owner != _carol && alice != _carol && bob != _carol && alice != address(0) && bob != address(0) && carol == address(0));
        
        carol = _carol;
        return true;
    }
}
