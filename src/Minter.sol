// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Ownable } from "@openzeppelin/access/Ownable.sol";
import { Strings } from "@openzeppelin/utils/Strings.sol";
import { ReentrancyGuard } from "@openzeppelin/security/ReentrancyGuard.sol";

contract Minter is ERC721A, Ownable, ReentrancyGuard {
    /*//////////////////////////////////////////////////////////////
                                 Errors
    //////////////////////////////////////////////////////////////*/

    error InvalidQuantity();

    error ExceededMaxSupply();

    error InsufficientETH();

    error LimitPerAddressReached();

    error CallerIsNotEOA();

    error NonExistentToken();

    /*//////////////////////////////////////////////////////////////
                                Library imports
    //////////////////////////////////////////////////////////////*/

    using Strings for uint256;

    /*//////////////////////////////////////////////////////////////
                                 State vars
    //////////////////////////////////////////////////////////////*/

    uint256 internal maxSupply = 10_000;

    uint256 internal tokenPrice = 0 ether;

    bool public mintStarted = false;

    bool public isRevealed = false;

    string internal tokenURIBase = "";

    string internal preRevealURI = "";

    string internal URIExtension = "";

    mapping(address => uint256) public mintedPerAddress;

    /*//////////////////////////////////////////////////////////////
                                 Modifiers
    //////////////////////////////////////////////////////////////*/

    modifier onlyEOA() {
        if (tx.origin != msg.sender) revert CallerIsNotEOA();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                 Constructor
    //////////////////////////////////////////////////////////////*/

    constructor(string memory baseURI, string memory _extension) ERC721A("Minter", "Minter") {
        tokenURIBase = baseURI;
        URIExtension = _extension;
    }

    // MANAGEMENT FUNCTIONS

    function toggleMint() external onlyOwner {
        mintStarted = !mintStarted;
    }

    function toggleReveal() external onlyOwner {
        isRevealed = !isRevealed;
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    // BASEURI FUNCTIONS

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        tokenURIBase = _newBaseURI;
    }

    function setURIExtenstion(string memory _newURIExtension) external onlyOwner {
        URIExtension = _newURIExtension;
    }

    function _baseURI() internal view override returns (string memory) {
        return tokenURIBase;
    }

    function setPreRevealURI(string memory _newURIPreReveal) external onlyOwner {
        preRevealURI = _newURIPreReveal;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        if (!_exists(_tokenId)) revert NonExistentToken();
        if (isRevealed == true) {
            return string(abi.encodePacked(tokenURIBase, _tokenId.toString(), URIExtension));
        } else {
            return string(abi.encodePacked(preRevealURI, _tokenId.toString(), URIExtension));
        }
    }

    // MINTING FUNCTIONS

    function mint(uint256 quantity) external payable {
        if (quantity == 0 && quantity <= 10) revert InvalidQuantity();
        if (quantity + totalSupply() > maxSupply) revert ExceededMaxSupply();
        if (mintedPerAddress[msg.sender] > 10) revert LimitPerAddressReached();
        if (msg.value < tokenPrice * quantity) revert InsufficientETH();

        mintedPerAddress[msg.sender] += quantity;

        _safeMint(msg.sender, quantity);
    }

    function ownerMint(address to, uint256 quantity) external onlyOwner {
        if (quantity == 0) revert InvalidQuantity();
        if (quantity + totalSupply() > maxSupply) revert ExceededMaxSupply();

        _safeMint(to, quantity);
    }

    // WITHDRAW FUNCTION

    function widthdrawFunds(address _address, uint256 _amount) public onlyOwner nonReentrant {
        (bool success,) = _address.call{ value: _amount }("");
        require(success, "Failed attempt to withdraw funds");
    }
}
