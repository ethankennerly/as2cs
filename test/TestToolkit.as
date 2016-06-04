package testSyntax{
    /**
     * This script must be in an Editor folder.
     * Test case:  2014-01 JimboFBX expects "using NUnit.Framework;"
     * Got "The type or namespace 'NUnit' could not be found."
     * http://answers.unity3d.com/questions/610988/unit-testing-unity-test-tools-v10-namespace-nunit.html
     */
    import asunit.framework.TestCase;
    internal
    class TestToolkit extends TestCase
    {
        public
        function testParseIndex():void
        {
            assertEquals(-1, Toolkit.ParseIndex(""));
            assertEquals(-1, Toolkit.ParseIndex("a"));
            assertEquals(-1, Toolkit.ParseIndex("b_"));
            assertEquals(2, Toolkit.ParseIndex("c_2"));
            assertEquals(3, Toolkit.ParseIndex("d_3_0"));
            assertEquals(-1, Toolkit.ParseIndex("_e_3_1"));
            assertEquals(4, Toolkit.ParseIndex("_4_2"));
        }
    }
}