pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 {

    struct Star {
        string name;
    }

    string public constant name = "Joey Berger Notarized Star";
    string public constant symbol = "JBNS";

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string _name, uint256 _tokenId) public {
        require(bytes(_name).length > 0);

        Star memory newStar = Star(_name);

        tokenIdToStarInfo[_tokenId] = newStar;

        _mint(msg.sender, _tokenId);
    }

    function lookUptokenIdToStarInfo(uint256 _tokenId) public view returns (string) {
        //make sure star exists
        require(bytes(tokenIdToStarInfo[_tokenId].name).length > 0);
        return tokenIdToStarInfo[_tokenId].name;
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
        starsForSale[_tokenId] = 0;
      }

    function exchangeStars(uint256 _firstUserTokenId, uint256 _secondUserTokenId) public {
        //make sure both stars exist
        require(bytes(tokenIdToStarInfo[_firstUserTokenId].name).length > 0);
        require(bytes(tokenIdToStarInfo[_secondUserTokenId].name).length > 0);
        //make sure token ids are unique
        require(_firstUserTokenId != _secondUserTokenId, "Token Ids are the same");
        //store in memory the first user's star
        Star memory tempStar = tokenIdToStarInfo[_firstUserTokenId];
        tokenIdToStarInfo[_firstUserTokenId] = tokenIdToStarInfo[_secondUserTokenId];
        tokenIdToStarInfo[_secondUserTokenId] = tempStar;
    }

    function transferStar(address _transferAddress, uint256 _tokenId) public {
        //make sure star exists
        require(bytes(tokenIdToStarInfo[_tokenId].name).length > 0);
        //make sure star is not getting transferred to self
        require(_transferAddress != msg.sender);
        //make transfer
        _removeTokenFrom(msg.sender, _tokenId);
        _addTokenTo(_transferAddress, _tokenId);
    }
}
