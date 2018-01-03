import "truffle/Assert.sol";
import "../contracts/Strings.sol";

contract TestString {
    using Strings for *;

    function testJoin() public {
        string memory delim = ".";
        string[] memory parts = new string[](3);
        parts[0] = "abc";
        parts[1] = "def";
        parts[2] = "xyz";
        Assert.equal("abc.def.xyz", delim.join(parts), "Should equal");
    }

    function testCompare() public {
        string memory self = "abc";
        string memory other = "cdef";
        // abc < cdef
        Assert.equal(-1, self.compare(other), "abc < cdef");
    }

    function testCompare1() public {
        string memory self = "abcd";
        string memory other1 = "ab";
        // len(abcd) - len(ab)
        Assert.equal(2, self.compare(other1), "abcd > ab");
    }

    function testCompare2() public {
        string memory self = "abcd";
        string memory other = "abcd";
        Assert.equal(0, self.compare(other), "abcd = abcd");
    }

    function testLen() public {
        string memory self = "trần";
        Assert.equal(4, self.len(), "Incorrect string length");
    }

    function testStartsWith() public {
        string memory self = "abcdef";
        string memory prefix = "abc";
        Assert.equal(true, self.startsWith(prefix), "Incorrect startsWith");
    }

    function testStartsWith1() public {
        string memory self = "abcdef";
        string memory prefix = "cde";
        Assert.equal(false, self.startsWith(prefix), "Incorrect startsWith");
    }

    function testEndsWith() public {
        string memory self = "abcdef";
        string memory suffix = "def";
        Assert.equal(true, self.endsWith(suffix), "abcdef endsWith def");
    }

    function testEndWith1() public {
        string memory self = "abcdef";
        string memory suffix = "abc";
        Assert.equal(false, self.endsWith(suffix), "abcdef NOT endsWith abc");
    }


    function testSubString() public {
        string memory self = "trầndef";
        string memory sub = "def";
        Assert.equal(4, self.subString(sub), "def is substring of trầndef at 4");

    }

    function testSubString1() public {
        string memory self = "abcdef";
        string memory sub = "gh";
        Assert.equal(-1, self.subString(sub), "gh is not in abcdef");
    }

    function testSubString2() public {
        string memory self = "abcdef";
        string memory sub = "ef";
        Assert.equal(4, self.subString(sub), "ef is  in abcdef at 4");
    }

    function testSubString3() public {
        string memory self = "09876543211234567890123456789012345678901234567890"; // 50 chars
        string memory sub = "12345678901234567890123456789012345"; // 35 chars
        Assert.equal(10, self.subString(sub), "Should contain");
    }

    function testSubString4() public { 
        string memory self = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz";
        string memory sub = "12345678901234567890123456789012345"; // 35 chars
        Assert.equal(-1, self.subString(sub), "Should not contain");
    }
    
}
