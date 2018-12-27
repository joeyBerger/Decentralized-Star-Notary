pragma solidity ^0.4.23;

import './ERC721Token.sol';

contract StarNotary is ERC721Token { 

    event LogCoinsSent(uint amount1, uint amount);
    
    struct Star {
        string name;
        string starStory;
        string ra;
        string dec;
        string mag;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;

    mapping(uint256 => uint256) public starsForSale;

    mapping(string => bool) private registeredCoordinates;

    uint256 public totalStarsForSale;

    uint256[] public currentStarsForSale;

    function createStar(string _name, string _starStory, string _ra, string _dec, string _mag, uint256 _tokenId) public { 
        //Star memory newStar = Star(_name);
        Star memory newStar = Star(_name, _starStory, _ra, _dec, _mag);

        bool starDoesNotExist = checkIfStarExists(_ra, _dec, _mag);
        require(starDoesNotExist == false, "Star already exists");       

        registerStarCoordinates(_ra, _dec, _mag);

        tokenIdToStarInfo[_tokenId] = newStar;

        ERC721Token.mint(_tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;

        //added
        currentStarsForSale.push(_tokenId);
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

        //clear record of available stars
        for (uint i = 0; i < currentStarsForSale.length; i++) {
            if (currentStarsForSale[i] == _tokenId) {
                delete currentStarsForSale[i];
                break;
            }
        }      
    }

    function checkIfStarExists(string _ra, string _dec, string _mag) private view returns (bool) {       
        string memory concatenatedString = concatenateStarCoordinates(_ra, _dec, _mag);
        return registeredCoordinates[string(concatenatedString)];
    }

    function registerStarCoordinates(string _ra, string _dec, string _mag) private { 
        string memory concatenatedString = concatenateStarCoordinates(_ra, _dec, _mag);
        registeredCoordinates[string(concatenatedString)] = true;
    }

    function allStarsForSale() public view returns (uint256[]) {
        return currentStarsForSale;
    }

    function testFunc1(uint v) public view returns (string) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }
        string memory str = string(s);
        return str;
    }

    function concatenateStarCoordinates(string _ra, string _dec, string _mag) private view returns (string) {  
        string memory strLength = new string(bytes(_ra).length + bytes(_dec).length + bytes(_mag).length);
        bytes memory returnString = bytes(strLength);
        uint k = 0;
        for (uint i = 0; i < bytes(_ra).length; i++) {returnString[k++] = bytes(_ra)[i];}
        for (i = 0; i < bytes(_dec).length; i++) {returnString[k++] = bytes(_dec)[i];}
        for (i = 0; i < bytes(_mag).length; i++) {returnString[k++] = bytes(_mag)[i];}
        
        return string(returnString);
    }
    
    function tokenIdToStarInfo(uint256 _tokenId) public view returns (string, string, string, string, string) {
        Star memory returnStar = tokenIdToStarInfo[_tokenId];
        //check for star name to see if struct exists
        require(keccak256(bytes(returnStar.name)) != "");        
        return (returnStar.name,returnStar.starStory,returnStar.ra,returnStar.dec,returnStar.mag);
    }
}