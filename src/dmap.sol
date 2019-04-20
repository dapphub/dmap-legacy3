// See dmap.evm
// This solidity is not intended to work!

pragma solidity ^0.5.6;

// Solidity functionally equivalent quasicode
contract DMap {
    // This owner is IN CODE and does not take up a storage slot! 
    address owner;
    // Uses storage directly, e.g. `_storage[0]` is actually slot 0.
    mapping(bytes32=>bytes32) _storage;

    // This constructor does NOT run.
    // The owner is copied into the code in the factory contract.
    constructor(address owner_) {
        owner = owner_;
    }
   
    // Owner sets, non-owners get.
    // Owner must exercise extreme caution and never try to read
    // from the owner address. 
    // TODO We could return error codes.
    function() external {
        if (msg.sender == owner) {
        //    _storage[word0] = word1;
        } else {
        //    return _storage[word0];
        }
    }
}

contract DMaps {
    event note( address indexed from
              , address indexed owner
              , address indexed dmap )
        anonymous; // <--


    // These should also be shipped as mixin utils
    function check(address dmap) public returns (address) { // isDMap
        assembly {
        }
    }
    function owner(address dmap) public returns (address) {
        assembly {
        }
    }
    // Copy owner into code in assembly
    function build(address owner) public returns (address) {
        assembly {
            return new DMap(owner)
        }
    }
}
