// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HallOfRoyals is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    uint256 private _airdropEth = 18721227621483000;
    Counters.Counter private _tokenIdCounter;
    bool public paused = false;
    bool public revealed = false;
    uint256 public maxMintAmount = 2;
    string public notRevealedUri;
    string private _currentBaseURI;

    constructor() ERC721("Hall Of Royals", "HOR") {
        setNotRevealedURI(
            "ipfs://QmNXSQPSXkKcyfz1Hv5UfXdnEce8HbPmvRxX9QiKNgaigF/hidden.json"
        );
        setBaseURI("ipfs://QmfQYSR4gTxx7K4ctnfqEXDr3Hkbpd3btqkYrya5APWTvB/");
    }

    receive() external payable {}

    function setBaseURI(string memory baseURI) public onlyOwner {
        _currentBaseURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _currentBaseURI;
    }

    function mint(uint256 _mintAmount) public payable {
        require(!paused, "minting is currently paused.");
        require(_mintAmount > 0, "Enter the number of token to mint.");
        require(
            _mintAmount <= maxMintAmount,
            "You cannot mint upto that amount of token at once."
        );

        if (msg.sender != owner()) {
            require(
                msg.value >= _airdropEth * _mintAmount,
                "Insuffient minting fee"
            );
        }

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _tokenIdCounter.increment();
            _safeMint(msg.sender, _tokenIdCounter.current());
        }
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        ".json"
                    )
                )
                : "";
    }

    function reveal() public onlyOwner {
        revealed = true;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function clearETH() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
