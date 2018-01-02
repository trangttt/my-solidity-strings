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
        Assert.equal(-1, self.compare(other), "abc < cdef");
    }

    function testCompare1(){
        string memory self = "abcd";
        string memory other1 = "ab";
        // len(abcd) - len(ab)
        Assert.equal(2, self.compare(other1), "abcd > ab");
    }

    function testLen(){
        string memory self = "trần";
        Assert.equal(4, self.len(), "Incorrect string length");
    }

    function testStartsWith(){
        string memory self = "abcdef";
        string memory prefix = "abc";
        Assert.equal(true, self.startsWith(prefix), "Incorrect startsWith");
    }

    function testStartsWith1(){
        string memory self = "abcdef";
        string memory prefix = "cde";
        Assert.equal(false, self.startsWith(prefix), "Incorrect startsWith");
    }

    function testEndsWith(){
        string memory self = "abcdef";
        string memory suffix = "def";
        Assert.equal(true, self.endsWith(suffix), "abcdef endsWith def");
    }

    function testEndWith1(){
        string memory self = "abcdef";
        string memory suffix = "abc";
        Assert.equal(false, self.endsWith(suffix), "abcdef NOT endsWith abc");
    }


    function testSubString(){
        string memory self = "trầndef";
        string memory sub = "def";
        Assert.equal(4, self.subString(sub), "def is substring of trầndef at 4");

    }

    function testSubString1(){
        string memory self = "abcdef";
        string memory sub = "gh";
        Assert.equal(-1, self.subString(sub), "gh is not in abcdef");
    }

    function testSubString2(){
        string memory self = "abcdef";
        string memory sub = "ef";
        Assert.equal(4, self.subString(sub), "gh is not in abcdef");
    }
    
}
