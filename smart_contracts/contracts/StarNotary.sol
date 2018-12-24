pragma solidity ^0.4 .23;

import './ERC721Token.sol';

contract StarNotary is ERC721Token {

    // struct Star { 
    //     string name;
    // }

    // bytes32[] dynamicBoolArray;

    struct Star {
        string name;
        string starStory;
        string ra;
        string dec;
        string mag;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;

    mapping(uint256 => uint256) public starsForSale;

    function createStar(string _name, string _starStory, string _ra, string _dec, string _mag, uint256 _tokenId) public {
        Star memory newStar = Star(_name, _starStory, _ra, _dec, _mag);
        //var starDoesNotAlreadyExist = checkIfStarExists(_tokenId);
        var starDoesNotAlreadyExist = true;
        if (starDoesNotAlreadyExist) {
            tokenIdToStarInfo[_tokenId] = newStar;

            ERC721Token.mint(_tokenId);
        }
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(this.ownerOf(_tokenId) == msg.sender);

        //perhaps make sure price is greater than zero
        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);

        require(msg.value >= starCost);

        clearPreviousStarState(_tokenId);

        transferFromHelper(starOwner, msg.sender, _tokenId);

        if (msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }

        starOwner.transfer(starCost);
    }

    function clearPreviousStarState(uint256 _tokenId) private {
        //clear approvals 
        tokenToApproved[_tokenId] = address(0);

        //clear being on sale 
        starsForSale[_tokenId] = 0;
    }

    // getApproved     in ERC721
 
    // isApprovedForAll   in ERC721

    // ownerOf  in ERC721

    function checkIfStarExists(uint256 _tokenId) private view returns (bool) {

        for (uint i = _tokenId-1; i >= 0; i--) {
            uint matches = 0;
            if (keccak256(tokenIdToStarInfo[i].ra) == keccak256(tokenIdToStarInfo[_tokenId].ra)){matches++;} 
            if (keccak256(tokenIdToStarInfo[i].dec) == keccak256(tokenIdToStarInfo[_tokenId].dec)){matches++;} 
            if (keccak256(tokenIdToStarInfo[i].mag) == keccak256(tokenIdToStarInfo[_tokenId].mag)){matches++;} 
            //if (matches == 3) {return false;}
            require(matches != 3, "The Star Coordinates Provided Already Exist!");
        }
        return true;  //I think this is always going to return true
    }
    

    // function starsForSale() public view returns () {
    //     starsForSale
    // }

    
    function tokenIdToStarInfo(uint256 _tokenId) public view returns (string, string, string, string, string) {
        Star memory returnStar = tokenIdToStarInfo[_tokenId];
        //check for star name to see if struct exists
        require(keccak256(bytes(returnStar.name)) != "");        
        return (returnStar.name,returnStar.starStory,returnStar.ra,returnStar.dec,returnStar.mag);
    }
}