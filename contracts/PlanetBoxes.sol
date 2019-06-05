pragma solidity ^0.5.0;

import "./TradeableERC721Token.sol";
import "./Galaxia.sol";
import "./Discovery.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title CreatureLootBox
 *
 * CreatureLootBox - a tradeable loot box of Creatures.
 */
contract PlanetBoxes is TradeableERC721Token {
    uint256 NUM_PLANETS_PER_BOX = 3;
    uint256 OPTION_ID = 0;
    address discoveryAddress;

    constructor(address _proxyRegistryAddress, address _discoveryAddress) TradeableERC721Token("CreatureLootBox", "LOOTBOX", _proxyRegistryAddress) public {
        discoveryAddress = _discoveryAddress;
    }

    function unpack(uint256 _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender);

        // // Insert custom logic for configuring the item here.
        // for (uint256 i = 0; i < NUM_PLANETS_PER_BOX; i++) {
        //     // Mint the ERC721 item(s).
        //     Discovery discovery = Discovery(discoveryAddress);
        //     discovery.mint(OPTION_ID, msg.sender);
        // }

        // Burn the presale item.
        _burn(msg.sender, _tokenId);
    }

    function baseTokenURI() public pure returns (string memory) {
        return "https://ipfs.io/";
    }

    function itemsPerLootbox() public view returns (uint256) {
        return NUM_PLANETS_PER_BOX;
    }
}