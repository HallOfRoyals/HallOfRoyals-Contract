const HallOfRoyalsToken = artifacts.require('HallOfRoyals');

module.exports = function(deployer){
  deployer.deploy(HallOfRoyalsToken);
}