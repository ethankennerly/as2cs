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
            assertEquals(0, Calculate.power([]));
            assertEquals(0, Calculate.power([[]]));
            assertEquals(0, Calculate.power([[3, 0]]));
            assertEquals(6, Calculate.power([[6]]));
            assertEquals(12, Calculate.power([[4, 3]]));
            assertEquals(24, Calculate.power([[6, 4]]));
            assertEquals(42, Calculate.power([[7, 6]]));
            assertEquals(22, Calculate.power([[2], [5, 1, 4]]));
        }

        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        public function testDescribe():void
        {
            assertEquals("", Calculate.describe([]));
            assertEquals("", Calculate.describe([[]]));
            assertEquals("", Calculate.describe([[6]]));
            assertEquals("4 x 3 = 12", Calculate.describe([[4, 3]]));
            assertEquals("6 x 4 = 24", Calculate.describe([[6, 4]]));
            assertEquals("7 x 6 = 42", Calculate.describe([[7, 6]]));
            assertEquals("3 x 0 = 0", Calculate.describe([[3, 0]]));
            assertEquals("2 + (5 x 1 x 4) = 22", Calculate.describe([[2], [5, 1, 4]]));
            assertEquals("3 x 0 = 0", Calculate.describe([[3, 0], []]));
        }

        /**
         * Match one stack.  Nearest to contract on one stack.  Exceed one stack.  No hand.
         * No stack.  Nearest to contract on second stack.
         */
        public function testSelectValueAndStack():void
        {
            assertEquals(null, Calculate.select_value_and_stack([], [], 25));
            assertEquals(null, Calculate.select_value_and_stack([], [[], []], 25));
            assertEquals(null, Calculate.select_value_and_stack([], [[6]], 25));
            assertEqualsArrays([7, 1], Calculate.select_value_and_stack([7], [[6]], 25));
            assertEqualsArrays([3, 0], Calculate.select_value_and_stack([2, 5, 3], [[4]], 12));
            assertEqualsArrays([4, 0], Calculate.select_value_and_stack([2, 5, 4, 7], [[6]], 25));
            assertEqualsArrays([7, 0], Calculate.select_value_and_stack([4, 5, 5, 7], [], 25));
            assertEqualsArrays([4, 1], Calculate.select_value_and_stack([4, 5, 5, 7], [[2], [5, 1]], 25));
            assertEqualsArrays([4, 2], Calculate.select_value_and_stack([4, 5, 5, 7], [[2], [], [5, 1]], 25));
            // Start new stack
            assertEqualsArrays([2, 0], Calculate.select_value_and_stack([2, 4, 5, 8], [[9]], 25));
            assertEqualsArrays([8, 1], Calculate.select_value_and_stack([4, 5, 8], [[9]], 25));
            assertEqualsArrays([5, 1], Calculate.select_value_and_stack([4, 5, 8], [[9]], 15));
        }

        /**
         * Examples where power would be under contract to play a card.
         */
        public function testStacksUnderContract():void
        {
            assertEqualsArrays([false], Calculate.stacksUnderContract(9, [], 2));
            assertEqualsArrays([true], Calculate.stacksUnderContract(1, [], 25));
            assertEqualsArrays([true, true], Calculate.stacksUnderContract(3, [[4]], 12));
            assertEqualsArrays([true, true], Calculate.stacksUnderContract(2, [[6]], 25));
            assertEqualsArrays([false, true], Calculate.stacksUnderContract(7, [[6]], 25));
            assertEqualsArrays([true, false, true], Calculate.stacksUnderContract(6, [[2], [5, 1]], 25));
            assertEqualsArrays([false], Calculate.stacksUnderContract(9, [[]], 2));
            assertEqualsArrays([true], Calculate.stacksUnderContract(1, [[]], 25));
            assertEqualsArrays([true, true], Calculate.stacksUnderContract(3, [[4], []], 12));
        }
    }
}
