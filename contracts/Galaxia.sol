pragma solidity ^0.5.0;

import "./TradeableERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Galaxia
 * Galaxia - a contract for my non-fungible Galaxias.
 */
contract Galaxia is TradeableERC721Token {

  constructor(address _proxyRegistryAddress)
  TradeableERC721Token("Galaxia", "GAX", _proxyRegistryAddress)
  public {

   }

  function baseTokenURI() public pure returns (string memory) {
    return "https://ipfs.io/";
  }
}