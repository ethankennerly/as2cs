package com.finegamedesign.powerplant
{
    import asunit.framework.TestCase;
    import com.finegamedesign.utils.DataUtil;

    /**
     * @author Ethan Kennerly
     */
    public class TestRule extends TestCase
    {
        public function testPlayCard():void
        {
            var rule:Rule = new Rule();
            rule.contract = 12;
            rule.theirHand = DataUtil.ToList(1, 3, 4, 5);
            rule.playCard(false, 4, 0);
            assertEquals(4, Calculate.power(rule.theirField));
            rule.yourHand = DataUtil.ToList(1, 3, 4, 5);
            rule.playCard(true, 3, 0);
            assertEquals(3, Calculate.power(rule.yourField));
        }

        public function testEqualsContract():void
        {
            var rule:Rule = new Rule();
            rule.contract = 12;
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            assertEquals(true, rule.equalsContract(false));
            assertEquals(false, rule.equalsContract(true));
            rule.contract = 26;
            rule.yourField = DataUtil.ToList(DataUtil.ToList(2), DataUtil.ToList(4, 3, 2));
            assertEquals(true, rule.equalsContract(true));
            assertEquals(false, rule.equalsContract(false));
        }

        public function testTallestStack():void
        {
            var rule:Rule = new Rule();
            assertEquals(0, rule.tallestStack());
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            assertEquals(2, rule.tallestStack());
            rule.yourField = DataUtil.ToList(DataUtil.ToList(1, 1, 1, 1));
            assertEquals(4, rule.tallestStack());
        }

        public function testScore():void
        {
            var rule:Rule = new Rule();
            rule.contract = 12;
            assertEquals(false, rule.score());
            rule.theirField = DataUtil.ToList(DataUtil.ToList(4, 3));
            assertEquals(0, rule.theirScore);
            assertEquals(0, rule.yourScore);
            assertEquals(true, rule.score());
            assertEquals(2, rule.theirScore);
            assertEquals(0, rule.yourScore);
            rule.yourField = DataUtil.ToList(DataUtil.ToList(1, 1, 1, 1));
            assertEquals(true, rule.score());
            assertEquals(6, rule.theirScore);
            assertEquals(0, rule.yourScore);
        }
    }
}
