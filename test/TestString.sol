import "truffle/Assert.sol";
import "../contracts/Strings.sol";

contract TestString {
    using Strings for *;

    function testJoin(){
        string memory delim = ".";
        string[] memory parts = new string[](3);
        parts[0] = "abc";
        parts[1] = "def";
        parts[2] = "xyz";
        Assert.equal("abc.def.xyz", delim.join(parts), "Should equal");
    }

    function testCompare(){
        string memory self = "abc";
        string memory other = "cdef";
        // abc < cdef
        Assert.equal(-1, self.compare(other), "Should not equal");
    }

    function testCompare1(){
        string memory self = "abcd";
        string memory other1 = "ab";
        // len(abcd) - len(ab)
        Assert.equal(2, self.compare(other1), "Should not equal");
    }
}
