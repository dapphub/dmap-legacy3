pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "./Dmap.sol";

contract DmapTest is DSTest {
    Dmap dmap;

    function setUp() public {
        dmap = new Dmap();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
