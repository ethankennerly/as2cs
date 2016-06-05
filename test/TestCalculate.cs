using NUnit.Framework;
namespace com.finegamedesign.powerplant
{
    [TestFixture] public class TestCalculate
    {
        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        public void testPower()
        {
            Assert.AreEqual(0, Calculate.power(new ArrayList(){
            }
            ));
            Assert.AreEqual(0, Calculate.power(new ArrayList(){
                new ArrayList(){
                }
            }
            ));
            Assert.AreEqual(0, Calculate.power(new ArrayList(){
                new ArrayList(){
                    3, 0}
            }
            ));
            Assert.AreEqual(6, Calculate.power(new ArrayList(){
                new ArrayList(){
                    6}
            }
            ));
            Assert.AreEqual(12, Calculate.power(new ArrayList(){
                new ArrayList(){
                    4, 3}
            }
            ));
            Assert.AreEqual(24, Calculate.power(new ArrayList(){
                new ArrayList(){
                    6, 4}
            }
            ));
            Assert.AreEqual(42, Calculate.power(new ArrayList(){
                new ArrayList(){
                    7, 6}
            }
            ));
            Assert.AreEqual(22, Calculate.power(new ArrayList(){
                new ArrayList(){
                    2}
                , new ArrayList(){
                    5, 1, 4}
            }
            ));
        }
        
        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        public void testDescribe()
        {
            Assert.AreEqual("", Calculate.describe(new ArrayList(){
            }
            ));
            Assert.AreEqual("", Calculate.describe(new ArrayList(){
                new ArrayList(){
                }
            }
            ));
            Assert.AreEqual("", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    6}
            }
            ));
            Assert.AreEqual("4 x 3 = 12", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    4, 3}
            }
            ));
            Assert.AreEqual("6 x 4 = 24", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    6, 4}
            }
            ));
            Assert.AreEqual("7 x 6 = 42", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    7, 6}
            }
            ));
            Assert.AreEqual("3 x 0 = 0", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    3, 0}
            }
            ));
            Assert.AreEqual("2 + (5 x 1 x 4) = 22", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    2}
                , new ArrayList(){
                    5, 1, 4}
            }
            ));
            Assert.AreEqual("3 x 0 = 0", Calculate.describe(new ArrayList(){
                new ArrayList(){
                    3, 0}
                , new ArrayList(){
                }
            }
            ));
        }
        
        /**
         * Match one stack.  Nearest to contract on one stack.  Exceed one stack.  No hand.
         * No stack.  Nearest to contract on second stack.
         */
        public void testSelectValueAndStack()
        {
            Assert.AreEqual(null, Calculate.select_value_and_stack(new ArrayList(){
            }
            , new ArrayList(){
            }
            , 25));
            Assert.AreEqual(null, Calculate.select_value_and_stack(new ArrayList(){
            }
            , new ArrayList(){
                new ArrayList(){
                }
                , new ArrayList(){
                }
            }
            , 25));
            Assert.AreEqual(null, Calculate.select_value_and_stack(new ArrayList(){
            }
            , new ArrayList(){
                new ArrayList(){
                    6}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                7, 1}
            , Calculate.select_value_and_stack(new ArrayList(){
                7}
            , new ArrayList(){
                new ArrayList(){
                    6}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                3, 0}
            , Calculate.select_value_and_stack(new ArrayList(){
                2, 5, 3}
            , new ArrayList(){
                new ArrayList(){
                    4}
            }
            , 12));
            assertEqualsArrays(new ArrayList(){
                4, 0}
            , Calculate.select_value_and_stack(new ArrayList(){
                2, 5, 4, 7}
            , new ArrayList(){
                new ArrayList(){
                    6}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                7, 0}
            , Calculate.select_value_and_stack(new ArrayList(){
                4, 5, 5, 7}
            , new ArrayList(){
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                4, 1}
            , Calculate.select_value_and_stack(new ArrayList(){
                4, 5, 5, 7}
            , new ArrayList(){
                new ArrayList(){
                    2}
                , new ArrayList(){
                    5, 1}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                4, 2}
            , Calculate.select_value_and_stack(new ArrayList(){
                4, 5, 5, 7}
            , new ArrayList(){
                new ArrayList(){
                    2}
                , new ArrayList(){
                }
                , new ArrayList(){
                    5, 1}
            }
            , 25));
            // Start new stack
            assertEqualsArrays(new ArrayList(){
                2, 0}
            , Calculate.select_value_and_stack(new ArrayList(){
                2, 4, 5, 8}
            , new ArrayList(){
                new ArrayList(){
                    9}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                8, 1}
            , Calculate.select_value_and_stack(new ArrayList(){
                4, 5, 8}
            , new ArrayList(){
                new ArrayList(){
                    9}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                5, 1}
            , Calculate.select_value_and_stack(new ArrayList(){
                4, 5, 8}
            , new ArrayList(){
                new ArrayList(){
                    9}
            }
            , 15));
        }
        
        /**
         * Examples where power would be under contract to play a card.
         */
        public void testStacksUnderContract()
        {
            assertEqualsArrays(new ArrayList(){
                false}
            , Calculate.stacksUnderContract(9, new ArrayList(){
            }
            , 2));
            assertEqualsArrays(new ArrayList(){
                true}
            , Calculate.stacksUnderContract(1, new ArrayList(){
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                true, true}
            , Calculate.stacksUnderContract(3, new ArrayList(){
                new ArrayList(){
                    4}
            }
            , 12));
            assertEqualsArrays(new ArrayList(){
                true, true}
            , Calculate.stacksUnderContract(2, new ArrayList(){
                new ArrayList(){
                    6}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                false, true}
            , Calculate.stacksUnderContract(7, new ArrayList(){
                new ArrayList(){
                    6}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                true, false, true}
            , Calculate.stacksUnderContract(6, new ArrayList(){
                new ArrayList(){
                    2}
                , new ArrayList(){
                    5, 1}
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                false}
            , Calculate.stacksUnderContract(9, new ArrayList(){
                new ArrayList(){
                }
            }
            , 2));
            assertEqualsArrays(new ArrayList(){
                true}
            , Calculate.stacksUnderContract(1, new ArrayList(){
                new ArrayList(){
                }
            }
            , 25));
            assertEqualsArrays(new ArrayList(){
                true, true}
            , Calculate.stacksUnderContract(3, new ArrayList(){
                new ArrayList(){
                    4}
                , new ArrayList(){
                }
            }
            , 12));
        }
    }
}