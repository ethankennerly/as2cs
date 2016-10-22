package com.finegamedesign.as2js
{
    import asunit.framework.TestCase;

    /**
     * @author Ethan Kennerly
     */
    public class TestTdd extends TestCase
    {
        public function testOneEqualsTwo():void
        {
            var one:int = 1;
            assertEquals(1, one);
            assertEquals(2, one);
        }
    }
}
