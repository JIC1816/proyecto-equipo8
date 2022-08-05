// SPDX-License-Identifier: MIT

//             _               _               ______            _                ___
//            | |             (_)             |  ____|          (_)              / _ \
//    ___ ___ | | ___  ___ ___ _  ___  _ __   | |__   __ _ _   _ _ _ __   ___   | (_) |
//   / __/ _ \| |/ _ \/ __/ __| |/ _ \| '_ \  |  __| / _` | | | | | '_ \ / _ \   > _ <
//  | (_| (_) | |  __/ (_| (__| | (_) | | | | | |___| (_| | |_| | | |_) | (_) | | (_) |
//   \___\___/|_|\___|\___\___|_|\___/|_| |_| |______\__, |\__,_|_| .__/ \___/   \___/
//                                                      | |       | |
//                                                      |_|       |_|

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract equipoOcho_Collection is ERC721, Pausable, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    uint256 public maxTokenIds = 7;
    event Mint(uint256 tokenId);

    constructor() ERC721("EquipoOcho", "EQ8") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to) public onlyRole(MINTER_ROLE) {
        require(
            _tokenIdCounter.current() + 1 < maxTokenIds,
            "Exceed maximum supply."
        );
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        emit Mint(_tokenIdCounter.current());
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
