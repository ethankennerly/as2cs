using asunit.framework/*<TestCase>*/;
namespace com.finegamedesign.powerplant
{
    /**
     * @author Ethan Kennerly
     */
    public class TestRule : TestCase
    {
        public void testPlayCard()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            rule.theirHand = new ArrayList(){
                1, 3, 4, 5}
            ;
            rule.playCard(false, 4, 0);
            Assert.AreEqual(4, Calculate.power(rule.theirField));
            rule.yourHand = new ArrayList(){
                1, 3, 4, 5}
            ;
            rule.playCard(true, 3, 0);
            Assert.AreEqual(3, Calculate.power(rule.yourField));
        }
        
        public void testEqualsContract()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            rule.theirField = new ArrayList(){
                new ArrayList(){
                    4, 3}
            }
            ;
            Assert.AreEqual(true, rule.equalsContract(false));
            Assert.AreEqual(false, rule.equalsContract(true));
            rule.contract = 26;
            rule.yourField = new ArrayList(){
                new ArrayList(){
                    2}
                , new ArrayList(){
                    4, 3, 2}
            }
            ;
            Assert.AreEqual(true, rule.equalsContract(true));
            Assert.AreEqual(false, rule.equalsContract(false));
        }
        
        public void testTallestStack()
        {
            Rule rule = new Rule();
            Assert.AreEqual(0, rule.tallestStack());
            rule.theirField = new ArrayList(){
                new ArrayList(){
                    4, 3}
            }
            ;
            Assert.AreEqual(2, rule.tallestStack());
            rule.yourField = new ArrayList(){
                new ArrayList(){
                    1, 1, 1, 1}
            }
            ;
            Assert.AreEqual(4, rule.tallestStack());
        }
        
        public void testScore()
        {
            Rule rule = new Rule();
            rule.contract = 12;
            Assert.AreEqual(false, rule.score());
            rule.theirField = new ArrayList(){
                new ArrayList(){
                    4, 3}
            }
            ;
            Assert.AreEqual(0, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
            Assert.AreEqual(true, rule.score());
            Assert.AreEqual(2, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
            rule.yourField = new ArrayList(){
                new ArrayList(){
                    1, 1, 1, 1}
            }
            ;
            Assert.AreEqual(true, rule.score());
            Assert.AreEqual(6, rule.theirScore);
            Assert.AreEqual(0, rule.yourScore);
        }
    }
}