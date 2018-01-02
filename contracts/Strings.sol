pragma solidity 0.4.18;

library Strings {

    struct slice {
        uint _ptr; // pointer to the begining of the string
        uint _len; // length of the string
    }


    function toSlice(string _self) internal pure returns(slice) {
        uint ptr;
        assembly {
            ptr := add(_self, 0x20)
        }
        return slice(ptr, bytes(_self).length);
    }

    function memcopy(uint _dest, uint _src, uint _len) internal pure {
        // copy word-length chunk by chunk
        for(; _len >= 32; _len -= 32){
            assembly { 
                mstore(_dest, mload(_src))
            }
            _dest += 32;
            _src += 32;
        }

        // copy the remaining bytes
        uint mask = 2 ** ((32 - _len) * 8) - 1;
        assembly {
            let source := and(mload(_src), not(mask)) // collect bits at source
            let dest := and(mload(_dest), mask) //mask out unwated bits at dest
            mstore(_dest, or(source, dest))
        }
    }

    /*
    *@dev Joins an array of strings, using `self` as delimiter, returning a newly allocated string
    *
    */
    function join(string _delim, string[] _parts) internal pure returns(string){
        if (_parts.length == 0)
            return "";
       
        // convert to slices
        // calculate len
        slice memory _delimS = toSlice(_delim);
        
        uint len; // length of new string

        slice[] memory _partsS = new slice[](_parts.length);
        for(uint i=0; i < _parts.length; i++){
            _partsS[i] = toSlice(_parts[i]);
            if (i == 0)
                len += _partsS[i]._len;
            else
                len += _delimS._len + _partsS[i]._len;
        }

        string memory ret = new string(len);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        // copy
        for (i=0; i < _parts.length; i++){
            // copy part
            memcopy(retptr, _partsS[i]._ptr, _partsS[i]._len);

            // update ptr
            retptr += _partsS[i]._len;

            // copy delimiter
            if (i < _parts.length - 1){
                memcopy(retptr, _delimS._ptr, _delimS._len);
                retptr += _delimS._len;
            }
        }
        return ret;
    }

    /*
    * compare `_other` with `_self` 
    * result ret = ( _self - _other )
    * ret > 0, _self comes lexicographically after _other
    */
    function compare(string _self, string _other) internal pure returns(int){
        slice memory s1 = toSlice(_self);
        slice memory s2 = toSlice(_other);

        uint shortest = s1._len;
        if ( shortest > s2._len )
            shortest = s2._len;

        uint ptr1 = s1._ptr;
        uint ptr2 = s2._ptr;
        
        for (uint idx =0; idx < shortest; idx +=32){
            uint v1;
            uint v2;


            assembly {
                v1 := mload(ptr1)
                v2 := mload(ptr2)
            }

            // compare
            if ( v1 != v2 ){
                // if idx > short, this returns a number < 2**256
                // if idx < short, this returns a number > 2**256, mask contains only bit 1
                uint mask = ~((2**(8*(32+(shortest-idx)))) - 1);
                var d1 = v1 & mask;
                var d2 = v2 & mask;
                // using comparision to avoid bit overflown
                if (d1 != d2){
                    if (d1 > d2)
                        return 1;
                    else
                        return -1;
                }
            }

            ptr1 += 32;
            ptr2 += 32;
        }
        return int(s1._len) - int(s2._len);
    }

    /*
    * return length in runes of the slice. Meaning, take into account UTF-8 encoding
    */
    function len(string _self) internal returns(int l){
        slice memory s = toSlice(_self);
        uint ptr = s._ptr - 31; // to collect only the first byte when using mload
        uint end = ptr + s._len;

        for(l=0; ptr < end; l++){
            uint8 v;
            assembly{
                v := and(mload(ptr), 0xFF)
            }
            if ( v < 0x80 ){
                ptr += 1;
            } else if (v < 0xE0){
                ptr += 2;
            } else if (v < 0xF0){
                ptr += 3;
            } else if (v < 0xF8){
                ptr += 4;
            } else if (v < 0xFC){
                ptr += 5;
            } else{
                ptr += 6;
            }
        }
    }
}
