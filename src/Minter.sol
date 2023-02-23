// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import { ERC721A } from "ERC721A/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Minter is ERC721A, Ownable {
    //Imports for Strings.sol and SafeMath.sol
    using Strings for uint256;
    using SafeMath for uint256;

    //Setting the total supply and max mint per transaction
    uint256 public constant max_supply = 10000;
    uint256 public constant max_per_mint = 10;

    //Setting price of ERC721 token 
    uint256 public price = 0 ether;
    bool public revealed = false;
    bool public sale_started = false;
    string  public tokenURIBase;
    string  public URIExtension;

    constructor(
        string memory baseURI,
        string memory Extension
    ) ERC721A("NFT_Mint", "MINT") {
       tokenURIBase = baseURI;
       URIExtension = Extension;
    }

    function togglePublicSaleStarted() external onlyOwner {
        sale_started = !sale_started;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        tokenURIBase = _newBaseURI;
    }

    function reveal() external onlyOwner {
        revealed = !revealed;
    }

    function _baseURI() internal view override returns (string memory) {
        return tokenURIBase;
    }

    function tokenURI(uint _tokenId) public view virtual override returns (string memory){
    require(
      _exists(_tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    return string(abi.encodePacked(tokenURIBase, _tokenId.toString(), URIExtension));
    }

    function mint(uint256 amount) external payable {
        require(price * amount == msg.value, "Insufficient ETH for transaction");
        require(sale_started, "Public sale has not active");
        require(amount <= max_per_mint, "Amount exceeds limit");
        require(totalSupply() + amount <= max_supply, "Out of tokens");
        require(amount > 0, "At least one token has to be minted");


        _safeMint(_msgSender(), amount);
    }


    function ownerMint(address to, uint256 tokens) external onlyOwner {
        require(totalSupply() + tokens <= max_supply, "DASK: Minting would exceed max supply");
        require(tokens > 0, "DASK: Must mint at least one token");

        _safeMint(to, tokens);
    }

      function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _widthdraw(address _address, uint256 _amount) public onlyOwner {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Failed attempt to withdraw funds");
    }

}