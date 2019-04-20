A `DMap` is a contract whose storage is used directly as a mapping.

To control write access, `DMaps` keep a reference to their owner *in code*. This means the owner does not take up a storage slot and cannot be modified.

`DMap`s are simple to statically analyze; `isDMap` and `getOwner` utility functions are implemented with `GETCODE` and some mask/compares.



```
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
