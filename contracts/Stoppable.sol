pragma solidity 0.5.0;

contract Stoppable {
    bool public isRunning = true;

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

