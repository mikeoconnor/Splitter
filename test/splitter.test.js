const Splitter = artifacts.require("Splitter");

contract('Splitter - Initialization', (accounts) => {
    it('Should initialize', async () => {
        const splitterInstance = await Splitter.deployed();
        const owner = await splitterInstance.owner();
        const alice = await splitterInstance.alice();
        const bob = await splitterInstance.bob();
        const carol = await splitterInstance.carol();
        const ZeroAddress = '0x0000000000000000000000000000000000000000';
        assert.equal(owner, accounts[0], 'initial owner is incorrect');
        assert.equal(alice, ZeroAddress, 'initial alice is incorrect');
        assert.equal(bob, ZeroAddress, 'initial bob is incorrect');
        assert.equal(carol, ZeroAddress, 'initial carol is incorrect');
        
    });
    it('Should correctly register alice', async () => {
        const ZeroAddress = '0x0000000000000000000000000000000000000000';
        const splitterInstance = await Splitter.deployed();
        await splitterInstance.RegisterAlice(accounts[1]);
        const alice = await splitterInstance.alice();
        
        const bob = await splitterInstance.bob();
        const carol = await splitterInstance.carol();
        assert.equal(alice, accounts[1], 'registered alice is incorrect');
        assert.equal(bob, ZeroAddress, 'initial bob is incorrect');
        assert.equal(carol, ZeroAddress, 'initial carol is incorrect');        
    });
    it('Should correctly register alice and bob', async () => {
        const ZeroAddress = '0x0000000000000000000000000000000000000000';
        const splitterInstance = await Splitter.deployed();
        const alice = await splitterInstance.alice();
        await splitterInstance.RegisterBob(accounts[2]);
        const bob = await splitterInstance.bob();
        const carol = await splitterInstance.carol();
        assert.equal(alice, accounts[1], 'registered alice is incorrect');
        assert.equal(bob, accounts[2], 'registered bob is incorrect');
        assert.equal(carol, ZeroAddress, 'initial carol is incorrect');        
    });
    it('Should correctly register alice, bob and carol', async () => {
        const splitterInstance = await Splitter.deployed();
        const alice = await splitterInstance.alice();
        //await splitterInstance.RegisterBob(accounts[2]);
        const bob = await splitterInstance.bob();
        await splitterInstance.RegisterCarol(accounts[3]);
        const carol = await splitterInstance.carol();
        assert.equal(alice, accounts[1], 'registered alice is incorrect');
        assert.equal(bob, accounts[2], 'registered bob is incorrect');
        assert.equal(carol, accounts[3], 'registered carol is incorrect');        
    });
});

