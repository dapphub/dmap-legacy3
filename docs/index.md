A `DMap` is a contract whose storage is used directly as a mapping.

To control write access, a `DMap` keep a reference to its owner *in code*. This means the owner does not take up a storage slot and cannot be modified.

![A picture of a DMap](https://dapphub.github.io/dmap/dmap.png)



### Semantics

#### `DMap`
```
ERR_BAD_ETHER    = 0x1;
ERR_BAD_DATA     = 0x2;
ERR_BAD_CALLER   = 0x4; // not 3

emit( bytes32 indexed key
    , bytes32 indexed value
    ) anonymous;
```

* If a DMap is called with nonzero `msg.value`, the call will revert with error `ERR_BAD_ETHER`.
* If a DMap is called with calldata of length not equal to 32 or 64, the call will revert with error `ERR_BAD_DATA`.
* If a DMap is called with calldata of length 32 (one word), the return data will be the 32 bytes (one word) in the storage slot whose key is the argument, ie `return storage[arg0]`.
* If a DMap is called with calldata of length 64 (two words), and the caller is NOT the hard-coded owner, the call will revert with error code `ERR_BAD_CALLER`.
* If a DMap is called with calldata of length 64 (two words), and the caller is the hard-coded owner, the storage at the location of the first word (word 0, calldata[0:31]) will be set to the second word (word 1, calldata[32:63]), ie `storage[arg0] = arg1`. The return data will be empty (length 0). The contract will emit one event with 2 indexed words, the key and value.

#### `DMapFactory`
```
ERR_BAD_ETHER    = 0x1;
ERR_BAD_DATA     = 0x2;
```

* If a DMapFactory is called with nonzero `msg.value`, the call will revert with error `ERR_BAD_ETHER`.
* If a DMapFactory is called with calldata of length not equal to 0 or 32, the call will revert with error `ERR_BAD_DATA`.
* If a DMapFactory is called with calldata of length 0, the return value will be the address of a new `DMap` whose **owner is the caller**.
* If a DMapFactory is called with calldata of length 32, the return value will be the address ofa new `DMap` whose **owner is bytes 12-32 of the calldata** (ie, the argument is "masked" when extracted from calldata and injected into new contract code). *Note that the argument is NOT masked when it is used as an indexed topic in the `log`, which means the caller can use these 12 bytes as extra log data.*
* 

### Pseudocode

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
    // To `set`, send 2 words: `key,val`. Response is empty.
    function() external {
        if( msg.data.length == 32 ){
            return storage[calldata[0:31]];
        } else if (msg.data.length == 64) {
            assert(msg.sender == owner);
            storage[calldata[0:31]] = calldata[32:63];
        } else {
            throw;
        }
    }
}

contract DMapFactory {
    function() {
        if( msg.data.length == 0 ) {
            return new DMap(msg.sender);
        } else if (msg.data.length == 32) {
            return new DMap(calldata[12:32]);
        }
    }
}
```
