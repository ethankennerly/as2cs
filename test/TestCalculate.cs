using System.Collections.Generic;

using NUnit.Framework;
namespace com.finegamedesign.powerplant
{
    [TestFixture] public class TestCalculate
    {
        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        [Test] public void Power()
        {
            List<List<int>> stacks = new List<List<int>>();
            List<int> stack = new List<int>();
            Assert.AreEqual(0, Calculate.power(stacks));
            stacks.Add(stack);
            Assert.AreEqual(0, Calculate.power(stacks));
        }
        
        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        [Test] public void Describe()
        {
            List<List<int>> stacks = new List<List<int>>();
            List<int> stack = new List<int>();
            Assert.AreEqual("", Calculate.describe(stacks));
            stacks.Add(stack);
            Assert.AreEqual("", Calculate.describe(stacks));
        }
    }
}