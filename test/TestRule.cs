using NUnit.Framework;
using /*<com>*/Finegamedesign.Utils/*<DataUtil>*/;
namespace /*<com>*/Finegamedesign.Powerplant
{
    [TestFixture] public class TestRule
    {
        [Test] public void PlayCard()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            rule.theirHand = DataUtil.ToList(1, 3, 4, 5);
            rule.PlayCard(false, 4, 0);
            Assert.AreEqual(4, Calculate.Power(rule.theirField));
            rule.yourHand = DataUtil.ToList(1, 3, 4, 5);
            rule.PlayCard(true, 3, 0);
            Assert.AreEqual(3, Calculate.Power(rule.yourField));
        }
        
        [Test] public void EqualsContract()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            Assert.AreEqual(true, rule.EqualsContract(false));
            Assert.AreEqual(false, rule.EqualsContract(true));
            rule.contract = 26;
            rule.yourField = DataUtil.ToList(DataUtil.ToList(2), DataUtil.ToList(4, 3, 2));
            Assert.AreEqual(true, rule.EqualsContract(true));
            Assert.AreEqual(false, rule.EqualsContract(false));
        }
        
        [Test] public void TallestStack()
        {
            Rule rule = new Rule();
            Assert.AreEqual(0, rule.TallestStack());
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            Assert.AreEqual(2, rule.TallestStack());
            rule.yourField = DataUtil.ToList(DataUtil.ToList(1, 1, 1, 1));
            Assert.AreEqual(4, rule.TallestStack());
        }
        
        [Test] public void Score()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            Assert.AreEqual(false, rule.Score());
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            Assert.AreEqual(0, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
            Assert.AreEqual(true, rule.Score());
            Assert.AreEqual(2, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
            rule.yourField = DataUtil.ToList(DataUtil.ToList(1, 1, 1, 1));
            Assert.AreEqual(true, rule.Score());
            Assert.AreEqual(6, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
        }
    }
}