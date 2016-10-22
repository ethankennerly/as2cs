using NUnit.Framework;
namespace /*<com>*/Finegamedesign.As2js
{[TestFixture] public class TestTdd
    {
        [Test] public void OneEqualsTwo()
        {
            int one = 1;
            Assert.AreEqual(1, one);
            Assert.AreEqual(2, one);
        }
    }
}