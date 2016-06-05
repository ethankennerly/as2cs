package com.finegamedesign.powerplant
{
    import asunit.framework.TestCase;

    /**
     * @author Ethan Kennerly
     */
    public class TestCalculate extends TestCase
    {
        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        public function testPower():void
        {
            var stacks:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
            var stack:Vector.<int> = new Vector.<int>();
            assertEquals(0, Calculate.power(stacks));
            stacks.push(stack);
            assertEquals(0, Calculate.power(stacks));
        }

        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        public function testDescribe():void
        {
            var stacks:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
            var stack:Vector.<int> = new Vector.<int>();
            assertEquals("", Calculate.describe(stacks));
            stacks.push(stack);
            assertEquals("", Calculate.describe(stacks));
        }
    }
}
