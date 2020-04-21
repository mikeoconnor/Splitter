const Splitter = artifacts.require("Splitter");

contract('Splitter - split even funds', (accounts) => {
    it('Should split funds of 2 wei', async () => {
        const alice = accounts[4];
        const bob = accounts[5];
        const carol = accounts[6];
        const splitterInstance = await Splitter.deployed()
        // Split 2 Wei
        await splitterInstance.splitFunds(bob, carol, {from: alice, value: web3.utils.toWei('2', 'wei')});
        const bob_funds = await splitterInstance.balances(bob);
        const carol_funds = await splitterInstance.balances(carol);
        const contract_balance = await splitterInstance.getContractBalance();
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
        const splitterInstance = await Splitter.deployed();
        // Split 1 Wei
        await splitterInstance.splitFunds(bob, carol, {from: alice, value: web3.utils.toWei('1', 'wei')});
        const bob_funds = await splitterInstance.balances(bob);
        const carol_funds = await splitterInstance.balances(carol);
        const contract_balance = await splitterInstance.getContractBalance();
        //assert.equal(alice_deposit.toString(10), '1');
        assert.equal(bob_funds.toString(10), '1');
        assert.equal(carol_funds.toString(10), '0');
        assert.equal(contract_balance.toString(10), '1');
    });
});

contract('Splitter - withdraw funds', (accounts) => {
    it('Should be able to withdraw funds', async () => {
        const alice = accounts[4];
        const bob = accounts[5];
        const carol = accounts[6];
        const splitterInstance = await Splitter.deployed();
        // Split 1000 Wei
        await splitterInstance.splitFunds(bob, carol, {from: alice, value: web3.utils.toWei('1000', 'wei')});
        await splitterInstance.withdrawFunds('500', {from: bob});
        const bob_funds = await splitterInstance.balances(bob);
        assert.equal(bob_funds.toString(10), '0');
        await splitterInstance.withdrawFunds('400', {from: carol});
        carol_funds = await splitterInstance.balances(carol);
        assert.equal(carol_funds.toString(10), '100');
        const contract_balance = await splitterInstance.getContractBalance();
        assert.equal(contract_balance.toString(10), '100');
    });
});

