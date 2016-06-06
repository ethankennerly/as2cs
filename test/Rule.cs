using UnityEngine;
using System.Collections.Generic;

using com.finegamedesign.utils/*<DataUtil>*/;
namespace com.finegamedesign.powerplant
{
    /**
     * Model of rules to play Power Plant without their appearance.
     * @author Ethan Kennerly
     */
    public class Rule
    {
        public List<int> deck;
        public int contract;
        /**
         * These could be refactored to class per player.
         */
        public List<int> yourHand;
        public List<int> theirHand;
        public List<List<int>> yourField;
        public List<List<int>> theirField;
        public int yourScore;
        public int theirScore;
        
        public Rule()
        {
            reset();
        }
        
        /**
         * After hand appears.
         * Generate deck with tutorial at first, then full deck.
         */
        public void reset()
        {
            Debug.Log("Rule.reset:  Now your cards will be dealt in the tutorial's starting order.");
            if (null == deck) {
                deck = DataUtil.ToList(1, 3,
                2, 4,
                3, 4,
                4, 1,
                1, 2,
                4, 3,
                9,
                2, 5,
                6, 8,
                4, 3,
                7, 3,
                5, 7,
                5, 3,
                1, 1);
            }
            else if (deck.Count <= 0) {
                deck = shuffle(generateDeck());
            }
            yourHand = new List<int>();
            theirHand = new List<int>();
            yourField = new List<List<int>>();
            theirField = new List<List<int>>();
            yourScore = 0;
            theirScore = 0;
        }
        
        /* Deal one card to your hand. */
        public int deal(List<int> hand)
        {
            int dealt = DataUtil.Shift(this.deck);
            hand.Add(dealt);
            return dealt;
        }
        
        public static List<int> generateDeck()
        {
            List<int> cards = new List<int>();
            List<int> counts = DataUtil.ToList( 0,  8,  8, 16, 12,
            20,  8, 12,  8,  8);
            for (int c = 0; c < counts.Count; c++) {
                for (int count = 0; count < counts[c]; count++)
                {
                    cards.Add(c);
                }
            }
            return cards;
        }
        
        /**
         * @param    cards  In-place.
         */
        public static List<int> shuffle(List<int> cards)
        {
            for (int i = cards.Count - 1; 1 <= i; i--) {
                int other = (int)((Random.value % 1.0f) * (i + 1));
                int temp = cards[i];
                cards[i] = cards[other];
                cards[other] = temp;
            }
            return cards;
        }
        
        /* At least one frame beforehand, Contract must exist.
         * Move card from deck to contract.
         * DOES NOT yet check if deck has one or fewer cards.  */
        public List<int> revealContract()
        {
            int tensValue = DataUtil.Shift(this.deck);
            int onesValue = DataUtil.Shift(this.deck);
            contract = 10 * tensValue + onesValue;
            List<int> contractCards = new List<int>();
            contractCards.Add(tensValue);
            contractCards.Add(onesValue);
            return contractCards;
        }
        
        /* We keep our hand and score.  We discard the rest.
         * Discard stacks and city contract.  */
        public void clear()
        {
            this.contract = 0;
            this.yourField = new List<List<int>>();
            this.theirField = new List<List<int>>();
        }
        
        public void discard(List<int> hand, int value)
        {
            hand.RemoveRange(hand.IndexOf(value), 1);
        }
        
        public void playCard(bool you, int value, int stackIndex)
        {
            List<List<int>> field = you ? yourField : theirField;
            List<int> hand = you ? yourHand : theirHand;
            discard(hand, value);
            if (field.Count <= stackIndex) {
                field.Add(new List<int>());
            }
            field[stackIndex].Add(value);
        }
        
        public bool equalsContract(bool you)
        {
            List<List<int>> field = you ? yourField : theirField;
            return contract == Calculate.power(field);
        }
        
        public int tallestStackInField(List<List<int>> field)
        {
            int max = 0;
            for (int f = 0; f < field.Count; f++) {
                if (max < field[f].Count) {
                    max = field[f].Count;
                }
            }
            return max;
        }
        
        public int tallestStack()
        {
            return Mathf.Max(tallestStackInField(yourField),
            tallestStackInField(theirField));
        }
        
        /**
         * Add to score for anyone by length of anyone's longest stack.
         * @return  If anyone scored.
         */
        public bool score()
        {
            bool scored = false;
            if (equalsContract(true)) {
                yourScore += tallestStack();
                scored = true;
            }
            else if (equalsContract(false)) {
                theirScore += tallestStack();
                scored = true;
            }
            return scored;
        }
    }
}