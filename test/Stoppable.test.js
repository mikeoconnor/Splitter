const Stoppable = artifacts.require("Stoppable");

contract('Stoppable - owner', (accounts) => {
    it('Owner should be able to set/unset isRunning', async () => {
        const stoppableInstance = await Stoppable.deployed();
        let isRunning = await stoppableInstance.isRunning();
        assert.isTrue(isRunning);
        await stoppableInstance.stop();
        isRunning = await stoppableInstance.isRunning();
        assert.isFalse(isRunning);
        await stoppableInstance.resume();
        isRunning = await stoppableInstance.isRunning();
        assert.isTrue(isRunning);
    });
});

contract('Stoppable - non owner', (accounts) => {
    it('Non owner should be not able to set/unset isRunning', async () => {
        const owner = accounts[0];
        const non_owner = accounts[7];
        const stoppableInstance = await Stoppable.deployed();
        let isRunning = await stoppableInstance.isRunning();
        assert.equal(isRunning, true);
        try{
            await stoppableInstance.stop({from: non_owner});
            throw null;
        }
        catch (error) {
            assert.isNotNull(error, "Expected an error but did not get one");
            assert.include(error.message, "revert");
            assert.include(error.message, "Not owner");
        }
    });
});

contract('Stoppable - new owner', (accounts) => {
    it('New owner should be able to set/unset isRunning', async () => {
        const owner = accounts[0];
        const new_owner = accounts[7];
        const stoppableInstance = await Stoppable.deployed();
        let isRunning = await stoppableInstance.isRunning();
        assert.isTrue(isRunning);
        let current_owner = await stoppableInstance.owner();
        assert.equal(current_owner, owner);
        await stoppableInstance.changeOwner(new_owner, {from: current_owner});
        current_owner = await stoppableInstance.owner();
        assert.equal(current_owner, new_owner);
        await stoppableInstance.stop({from: new_owner});
        isRunning = await stoppableInstance.isRunning();
        assert.isFalse(isRunning);
        await stoppableInstance.resume({from: new_owner});
        isRunning = await stoppableInstance.isRunning();
        assert.isTrue(isRunning);
    });
});
