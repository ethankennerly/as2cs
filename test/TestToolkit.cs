/**
 * This script must be in an Editor folder.
 * Test case:  2014-01 JimboFBX expects "using NUnit.Framework;"
 * Got "The type or namespace 'NUnit' could not be found."
 * http://answers.unity3d.com/questions/610988/unit-testing-unity-test-tools-v10-namespace-nunit.html
 */
using NUnit.Framework;
[TestFixture]
internal class TestToolkit
{
    [Test]
    public void ParseIndex()
    {
        Assert.AreEqual(-1, Toolkit.ParseIndex(""));
        Assert.AreEqual(-1, Toolkit.ParseIndex("a"));
        Assert.AreEqual(-1, Toolkit.ParseIndex("b_"));
        Assert.AreEqual(2, Toolkit.ParseIndex("c_2"));
        Assert.AreEqual(3, Toolkit.ParseIndex("d_3_0"));
        Assert.AreEqual(-1, Toolkit.ParseIndex("_e_3_1"));
        Assert.AreEqual(4, Toolkit.ParseIndex("_4_2"));
    }
}