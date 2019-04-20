A `DMap` is a contract whose storage is used directly as a mapping.

To control write access, `DMaps` keep a reference to their owner *in code*. This means the owner does not take up a storage slot and cannot be modified.

`DMap`s are simple to statically analyze; `isDMap` and `getOwner` utility functions are implemented with `GETCODE` and some mask/compares.


#### Semantics

```
ERR_BAD_ETHER    = 0x1;
ERR_BAD_DATA     = 0x2;
ERR_BAD_CALLER   = 0x4; // 2^3, not 3
```

* If a DMap is called with nonzero `msg.value`, the call will revert with error `ERR_BAD_ETHER`.
* If a DMap is called with a calldata of length 32 (one word), the return data will be the 32 bytes (one word) in the storage slot whose key is the argument.
* If a DMap is called with a calldata of length 64 (two words), and the caller is the hard-coded owner, the storage at the location of the first word (word 0, calldata[0:31]) will be set to the second word (word 1, calldata[32:63]), ie `storage[arg0] = arg1`. The return data will be empty.
* If a DMap is called with a calldata of length 64 (two words), and the caller is NOT the hard-coded owner, the call will revert with error code `ERR_BAD_CALLER`.
* If a DMap is called with calldata of length other than 32 or 64, the call will revert with error `ERR_BAD_DATA`.



// THIS IS NOT THE SOURCE CODE FOR DMAP
// THIS IS PSEUDOCODE
// See `dmap.evm` for source.
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
  
    // To `get`, send 1 word: `key`. Response is 1 word: `value`.
    // To `set`, send 3 words: `key,val,nonzero`. Response is empty.
    function() external {
        if( msg.data[3] == 0 ){
            return storage[0];
        } else {
            storoage[word0] = word1;
        }
        if (msg.sender == owner) {
            _storage[word0] = bytes32(msg.data[0]); // PSUEDOCODE - write whole word
        } else {
            return bytes32(_storage[word0]);        // PSEUDOCODE - read whole word
        }
    }
}
```
