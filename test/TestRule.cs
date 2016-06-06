using NUnit.Framework;
using com.finegamedesign.utils/*<DataUtil>*/;
namespace com.finegamedesign.powerplant
{
    [TestFixture] public class TestRule
    {
        [Test] public void PlayCard()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            rule.theirHand = DataUtil.ToList(1, 3, 4, 5);
            rule.playCard(false, 4, 0);
            Assert.AreEqual(4, Calculate.power(rule.theirField));
            rule.yourHand = DataUtil.ToList(1, 3, 4, 5);
            rule.playCard(true, 3, 0);
            Assert.AreEqual(3, Calculate.power(rule.yourField));
        }
        
        [Test] public void EqualsContract()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            Assert.AreEqual(true, rule.equalsContract(false));
            Assert.AreEqual(false, rule.equalsContract(true));
            rule.contract = 26;
            rule.yourField = DataUtil.ToList(DataUtil.ToList(2), DataUtil.ToList(4, 3, 2));
            Assert.AreEqual(true, rule.equalsContract(true));
            Assert.AreEqual(false, rule.equalsContract(false));
        }
        
        [Test] public void TallestStack()
        {
            Rule rule = new Rule();
            Assert.AreEqual(0, rule.tallestStack());
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            Assert.AreEqual(2, rule.tallestStack());
            rule.yourField = DataUtil.ToList(DataUtil.ToList(1, 1, 1, 1));
            Assert.AreEqual(4, rule.tallestStack());
        }
        
        [Test] public void Score()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            Assert.AreEqual(false, rule.score());
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            Assert.AreEqual(0, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
            Assert.AreEqual(true, rule.score());
            Assert.AreEqual(2, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
            rule.yourField = DataUtil.ToList(DataUtil.ToList(1, 1, 1, 1));
            Assert.AreEqual(true, rule.score());
            Assert.AreEqual(6, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
        }
    }
}