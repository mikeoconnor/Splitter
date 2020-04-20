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
        await splitterInstance.registerAlice(accounts[1]);
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
        await splitterInstance.registerBob(accounts[2]);
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
        await splitterInstance.registerCarol(accounts[3]);
        const carol = await splitterInstance.carol();
        assert.equal(alice, accounts[1], 'registered alice is incorrect');
        assert.equal(bob, accounts[2], 'registered bob is incorrect');
        assert.equal(carol, accounts[3], 'registered carol is incorrect');        
    });
});

contract('Splitter - split even funds', (accounts) => {
    it('Should split funds of 2 wei', async () => {
        const alice = accounts[4];
        const bob = accounts[5];
        const carol = accounts[6];
        const splitterInstance = await Splitter.deployed()
        await splitterInstance.registerAlice(alice);
        await splitterInstance.registerBob(bob);
        await splitterInstance.registerCarol(carol);
        // Split 2 Wei
        await splitterInstance.splitFundFromAlice({from: alice, value: web3.utils.toWei('2', 'wei')});
        const alice_deposit = await splitterInstance.getAliceDeposit();
        const bob_funds = await splitterInstance.getBobFunds();
        const carol_funds = await splitterInstance.getCarolFunds();
        const contract_balance = await splitterInstance.getContractBalance()
        assert.equal(alice_deposit.toString(10), '2');
        assert.equal(bob_funds.toString(10), '1');
        assert.equal(carol_funds.toString(10), '1');
        assert.equal(contract_balance.toString(10), '2');
    });
});

contract('Splitter - split odd funds', (accounts) => {
    it('Should split funds of 1 wei', async () => {
        const alice = accounts[4];
        const bob = accounts[5];
        const carol = accounts[6];
        const splitterInstance = await Splitter.deployed()
        await splitterInstance.registerAlice(alice);
        await splitterInstance.registerBob(bob);
        await splitterInstance.registerCarol(carol);
        // Split 1 Wei
        await splitterInstance.splitFundFromAlice({from: alice, value: web3.utils.toWei('1', 'wei')});
        const alice_deposit = await splitterInstance.getAliceDeposit();
        const bob_funds = await splitterInstance.getBobFunds();
        const carol_funds = await splitterInstance.getCarolFunds();
        const contract_balance = await splitterInstance.getContractBalance()
        assert.equal(alice_deposit.toString(10), '1');
        assert.equal(bob_funds.toString(10), '1');
        assert.equal(carol_funds.toString(10), '0');
        assert.equal(contract_balance.toString(10), '1');
    });
});

