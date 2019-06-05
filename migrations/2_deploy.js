const Galaxia = artifacts.require("./Galaxia.sol");
const PlanetDiscovery = artifacts.require("./PlanetDiscovery.sol")
const PlanetBoxes = artifacts.require("./PlanetBoxes.sol");

module.exports = function(deployer, network) {
  // OpenSea proxy registry addresses for rinkeby and mainnet.
  let proxyRegistryAddress = ""
  if (network === 'rinkeby') {
    proxyRegistryAddress = "0xf57b2c51ded3a29e6891aba85459d600256cf317";
  } else {
    proxyRegistryAddress = "0xa5409ec958c83c3f309868babaca7c86dcb077c1";
  }

  deployer.deploy(Galaxia, proxyRegistryAddress, {gas: 5000000});
  
  // Uncomment this if you want initial item sale support.
  // deployer.deploy(Galaxia, proxyRegistryAddress, {gas: 5000000}).then(() => {
  //   return deployer.deploy(PlanetDiscovery, proxyRegistryAddress, Galaxia.address, {gas: 7000000});
  // }).then(async() => {
  //   var Galaxia = await Galaxia.deployed();
  //   return Galaxia.transferOwnership(PlanetDiscovery.address);
  // })
};