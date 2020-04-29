const Ownable = artifacts.require("Ownable");

contract('Ownable - owner', (accounts) => {
    it('Should have default owner', async () => {
        const default_owner = accounts[0];
        const ownableInstance = await Ownable.deployed();
        const owner = await ownableInstance.owner();
        assert.equal(owner, default_owner);
    });

    it('Should be able to change owner', async () => {
        const default_owner = accounts[0];
        const new_owner = accounts[7];
        const ownableInstance = await Ownable.deployed();
        let owner = await ownableInstance.owner();
        assert.equal(owner, default_owner);
        await ownableInstance.changeOwner(accounts[7]);
        owner = await ownableInstance.owner();
        assert.equal(owner, new_owner);
    });
});

contract('Ownable - non owner', (accounts) => {
    it('Should have non owner not able to change owner', async () => {
        const default_owner = accounts[0];
        const non_owner = accounts[3];
        const ownableInstance = await Ownable.deployed();
        const owner = await ownableInstance.owner();
        assert.equal(owner, default_owner);

        try{
            await ownableInstance.changeOwner(accounts[4], {from: non_owner});
            throw null;
        } catch(error) {
            assert.isNotNull(error, "Expected an error but did not get one");
            assert.include(error.message, "revert");
            assert.include(error.message, "Not owner");
        }
    });
});
