// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/vinceNft.sol";
import "../src/Auction.sol";

contract blindAuctionTest is Test {
    blindAuction public auction;
    Vince public vince;


    address Bob = vm.addr(0x1);
    address Alice = vm.addr(0x2);
    address Idogwu = vm.addr(0x3);
    address Faith = vm.addr(0x4);
    address Femi = vm.addr(0x5);
    address Nonso = vm.addr(0x6);

    uint price = 1000;
    function setUp() public {
        vince = new Vince();
        vince.safeMint(Bob, 1);
        auction = new blindAuction();

        vm.startPrank(Bob);



    }

    function teststartAuction( ) external{
        vince.approve(address(auction), 1);
        auction.startAuction(1000, address(vince), 1);





    }


    
    // function startAuctionTest() external {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
