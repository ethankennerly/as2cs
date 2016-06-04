using UnityEngine;
using System.Collections;
namespace com.finegamedesign.powerplant
{
    /**
     * Model of rules to play Power Plant without their appearance.
     * @author Ethan Kennerly
     */
    public class Rule
    {
        public ArrayList deck;
        public int contract;
        /**
         * These could be refactored to class per player.
         */
        public ArrayList yourHand;
        public ArrayList theirHand;
        public ArrayList yourField;
        public ArrayList theirField;
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
                deck = new ArrayList(){
                    1, 3,
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
                    1, 1}
                ;
            }
            else if (deck.Count <= 0) {
                deck = shuffle(generateDeck());
            }
            yourHand = new ArrayList();
            theirHand = new ArrayList();
            yourField = new ArrayList();
            theirField = new ArrayList();
            yourScore = 0;
            theirScore = 0;
        }
        
        /* Deal one card to your hand. */
        public int deal(ArrayList hand)
        {
            int dealt = this.deck.shift();
            hand.Add(dealt);
            return dealt;
        }
        
        public static ArrayList generateDeck()
        {
            ArrayList cards = new ArrayList(){
            }
            ;
            ArrayList counts = new ArrayList(){
                0,  8,  8, 16, 12,
                20,  8, 12,  8,  8}
            ;
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
        public static ArrayList shuffle(ArrayList cards)
        {
            for (int i = cards.Count - 1; 1 <= i; i--) {
                int other = (Random.value % 1.0f) * (i + 1);
                int temp = cards[i];
                cards[i] = cards[other];
                cards[other] = temp;
            }
            return cards;
        }
        
        /* At least one frame beforehand, Contract must exist.
         * Move card from deck to contract.
         * DOES NOT yet check if deck has one or fewer cards.  */
        public ArrayList revealContract()
        {
            int tensValue = this.deck.shift();
            int onesValue = this.deck.shift();
            contract = 10 * tensValue + onesValue;
            return new ArrayList(){
                tensValue, onesValue}
            ;
        }
        
        /* We keep our hand and score.  We discard the rest.
         * Discard stacks and city contract.  */
        public void clear()
        {
            this.contract = 0;
            this.yourField = new ArrayList(){
            }
            ;
            this.theirField = new ArrayList(){
            }
            ;
        }
        
        public void discard(ArrayList hand, int value)
        {
            hand.RemoveRange(hand.IndexOf(value), 1);
        }
        
        public void playCard(bool you, int value, int stackIndex)
        {
            ArrayList field = you ? yourField : theirField;
            ArrayList hand = you ? yourHand : theirHand;
            discard(hand, value);
            if (field.Count <= stackIndex) {
                field.Add(new ArrayList(){
                }
                );
            }
            field[stackIndex].Add(value);
        }
        
        public bool equalsContract(bool you)
        {
            ArrayList field = you ? yourField : theirField;
            return contract == Calculate.power(field);
        }
        
        public int tallestStackInField(ArrayList field)
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