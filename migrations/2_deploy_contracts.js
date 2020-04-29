const Splitter = artifacts.require("Splitter");
const Ownable = artifacts.require("Ownable");
const Stoppable = artifacts.require("Stoppable");

module.exports = function(deployer) {
    deployer.deploy(Ownable);
    deployer.deploy(Stoppable);
    deployer.deploy(Splitter);
};
