//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

// interface IERC721{
//     function approve(address to, uint256 tokenId) public;
//     function transferFrom(address _from, address _to, uint256 _nftId) external;
//     function _transfer(address from, address to, uint tokenId) external;

// }

contract blindAuction {


    IERC721 public nft;
    uint public nftId;

    address payable public nftOwner;
    address highestbidder;
    uint public startingPrice;
    uint public duration;
    uint highestbid;
    bool public startBid;
    bool public endBid;
    bool refunded;

    mapping(address => uint) bidderAmount;
    mapping(address => bool) public alreadyBid;
    mapping(address => bool) public withdraw;



    function startAuction(uint _startingPrice, address _nft, uint _nftId) external{
        require(startBid == false, "Auction Ongoing");
        nftId = _nftId;
        nft = IERC721(_nft);
        nftOwner = payable(msg.sender);
        startingPrice = _startingPrice;

        //IERC721(_nft).approve(address(this), _nftId);
        IERC721(_nft).transferFrom(nftOwner, address(this), _nftId);
        
        duration = block.timestamp + 3600 ;

        startBid = true;
        

    }


    function bid() external payable {
        require(startBid == true, "Auction ended");
        require(alreadyBid[msg.sender] == false , "Already bid");
        require(msg.value >= startingPrice, "Increase your bid");

        bidderAmount[msg.sender] += msg.value;
        uint newAmount = msg.value;
        if (newAmount > highestbid) {
            highestbid = newAmount;
            highestbidder = msg.sender;
        }
       
       alreadyBid[msg.sender] = true;
        

    }

    function endAuction() external {
        require(block.timestamp >= duration, "Auction still Ongoing");
        endBid = true;
        startBid = false;

        if(highestbidder == address(0)){

            IERC721(nft).transferFrom(address(this), nftOwner, nftId);

        }else {

            IERC721(nft).transferFrom(address(this), highestbidder, nftId);

            nftOwner.transfer(highestbid);  

        }


    }

    function claimRefund(uint _amount) public {
        require(endBid == true, "Auction still Ongoing");
        require(msg.sender != highestbidder,"Ole, you already won the NFT");
        require(withdraw[msg.sender] == false, "Already claimed refund");
        require(bidderAmount[msg.sender] == _amount, "Insufficient refund");

        payable(msg.sender).transfer(_amount);

        withdraw[msg.sender] = true;


    }
 
}