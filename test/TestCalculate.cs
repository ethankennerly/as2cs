using System.Collections.Generic;

using NUnit.Framework;
namespace /*<com>*/Finegamedesign.Powerplant
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
            Assert.AreEqual(0, Calculate.Power(stacks));
            stacks.Add(stack);
            Assert.AreEqual(0, Calculate.Power(stacks));
        }
        
        /**
         * No stack.  Empty stack.
         * Stack of 2.  2 stacks.
         */
        [Test] public void Describe()
        {
            List<List<int>> stacks = new List<List<int>>();
            List<int> stack = new List<int>();
            Assert.AreEqual("", Calculate.Describe(stacks));
            stacks.Add(stack);
            Assert.AreEqual("", Calculate.Describe(stacks));
        }
    }
}