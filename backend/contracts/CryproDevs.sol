// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable{

    string _baseTokenURI;
    uint256 public _price = 0.01 ether;
    bool public _paused;
    uint public maxTokenIds = 10;
    uint256 public tokenIds;
    IWhitelist whitelist;
    bool public presaleStarted;
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused{
        require(!_paused, "contract currently paused");
        _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs","CD"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }


    function startPresale() public onlyOwner{
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds<maxTokenIds, "Exceeded max crypto devs supply");
        require(msg.value >= _price, "Ether sent are not correct");
        tokenIds +=1;
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not yet ended");
        require(tokenIds< maxTokenIds, "Exceeded max crypto devs supply");
        require(msg.value >= _price, "Enter sent are not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view virtual override returns (string memory){
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner{
        _paused = val;
    }

    function withdraw() public onlyOwner{
        address _owner = owner();
        uint256 amout = address(this).balance;
        (bool sent,) = _owner.call{value:amout}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable{}

    fallback() external payable{}

}