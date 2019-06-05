pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Galaxia.sol";
import "./PlanetBoxes.sol";
import "./Strings.sol";

contract PlanetDiscovery is Ownable {
  using Strings for string;

  address public proxyRegistryAddress;
  address public nftAddress;
  address public lootBoxNftAddress;
  string public baseURI = "https://opensea-creatures-api.herokuapp.com/api/factory/";

  /**
   * Enforce the existence of only 100 OpenSea creatures.
   */
  uint256 PLANET_SUPPLY = 10;

  /**
   * Three different options for minting Creatures (basic, premium, and gold).
   */
  // uint256 NUM_OPTIONS = 3;

  constructor(address _proxyRegistryAddress, address _nftAddress) public {
    proxyRegistryAddress = _proxyRegistryAddress;
    nftAddress = _nftAddress;
    lootBoxNftAddress = address(new PlanetBoxes(_proxyRegistryAddress, address(this)));
  }

  // function numOptions() public view returns (uint256) {
  //   return NUM_OPTIONS;
  // }

  // @dev user can pay tokens to attempt to discover an already minted planet
  function discoverPlanet()
  public {
    bytes32 blockHash = blockhash(block.number);
    uint256 number = uint256(blockHash);
    // TODO: CHARGE MOON TOKENS
    Galaxia galaxiaPlanet = Galaxia(nftAddress);
    uint256 numberOfPlanets = planetsToBeDiscovered();
    if (number % 3 == 0 && numberOfPlanets > 0){
      uint256 discoveredPlanetID = number % numberOfPlanets;
      galaxiaPlanet.approve(msg.sender, discoveredPlanetID);
    }
  }


  function mint(string memory ipfsURI, address _toAddress)
  public
  onlyOwner {
    // Must be sent from the owner proxy or owner.
    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    assert(address(proxyRegistry.proxies(owner())) == msg.sender || owner() == msg.sender || msg.sender == lootBoxNftAddress);

    Galaxia galaxiaPlanet = Galaxia(nftAddress);
    galaxiaPlanet.mintTo(ipfsURI, _toAddress);
  }



  /**
   * Hack to get things to work automatically on OpenSea.
   * Use transferFrom so the frontend doesn't have to worry about different method names.
   */
  function transferFrom(address _from, address _to, uint256 _tokenId) 
  public {
    // TODO: Why does open sea need this? 
    // mint(_tokenId, _to);
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
   */
  function isApprovedForAll(address _owner, address _operator)
  public
  view
  returns (bool) {
    if (owner() == _owner && _owner == _operator) {
      return true;
    }

    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    if (owner() == _owner && address(proxyRegistry.proxies(_owner)) == _operator) {
      return true;
    }

    return false;
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
   */
  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return owner();
  }

  function name() external pure returns (string memory) {
    return "Galaxia Planet Discovery";
  }

  function symbol() external pure returns (string memory) {
    return "GPS";
  }

  function supportsFactoryInterface() public pure returns (bool) {
    return false;
  }

  // @notice returns the number of planets available to be discovered
  function planetsToBeDiscovered() public view returns (uint256) {
    return Galaxia(nftAddress).balanceOf(address(this));
  }
}