// KoansAuctionHouse.sol
// This contract represents the Koans Auction House and includes improvements based on the provided suggestions.

pragma solidity ^0.6.0;

import "./SashoToken.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract KoansAuctionHouse {
    using SafeMath for uint256;

    // Struct to represent an auction.
    struct Auction {
        address payable seller;
        uint256 reservePrice;
        uint256 endTime;
        uint256 highestBid;
        address payable highestBidder;
        bool active;
    }

    // Mapping to store auctions.
    mapping(uint256 => Auction) public auctions;

    // Event to emit when a new auction is created.
    event AuctionCreated(uint256 indexed tokenId, uint256 reservePrice, uint256 endTime);

    // Event to emit when a bid is placed on an auction.
    event BidPlaced(uint256 indexed tokenId, address indexed bidder, uint256 amount);

    // Event to emit when an auction is ended.
    event AuctionEnded(uint256 indexed tokenId, address indexed winner, uint256 amount);

    // Function to create a new auction.
    function createAuction(uint256 tokenId, uint256 reservePrice, uint256 endTime) public {
        require(endTime > now, "KoansAuctionHouse: endTime must be in the future");
        auctions[tokenId] = Auction({
            seller: msg.sender,
            reservePrice: reservePrice,
            endTime: endTime,
            highestBid: 0,
            highestBidder: address(0),
            active: true
        });
        emit AuctionCreated(tokenId, reservePrice, endTime);
    }

    // Function to place a bid on an auction.
    function placeBid(uint256 tokenId) public payable {
        Auction storage auction = auctions[tokenId];
        require(auction.active, "KoansAuctionHouse: auction is not active");
        require(now < auction.endTime, "KoansAuctionHouse: auction has ended");
        require(msg.value >= auction.reservePrice, "KoansAuctionHouse: bid is below reserve price");
        require(msg.value > auction.highestBid, "KoansAuctionHouse: bid is below highest bid");

        if (auction.highestBidder != address(0)) {
            auction.highestBidder.transfer(auction.highestBid);
        }

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;
        emit BidPlaced(tokenId, msg.sender, msg.value);
    }

    // Function to end an auction and transfer the winning bid to the seller.
    function endAuction(uint256 tokenId) public {
        Auction storage auction = auctions[tokenId];
        require(auction.active, "KoansAuctionHouse: auction is not active");
        require(now >= auction.endTime, "KoansAuctionHouse: auction has not ended");

        auction.active = false;
        auction.seller.transfer(auction.highestBid);
        emit AuctionEnded(tokenId, auction.highestBidder, auction.highestBid);
    }
}