package com.finegamedesign.powerplant 
{
    import com.finegamedesign.utils.DataUtil;

    /**
     * Model of rules to play Power Plant without their appearance.
     * @author Ethan Kennerly
     */
    public class Rule
    {
        public var deck:Vector.<int>;
        public var contract:int;
        /**
         * These could be refactored to class per player.
         */
        public var yourHand:Vector.<int>;
        public var theirHand:Vector.<int>;
        public var yourField:Vector.<Vector.<int>>;
        public var theirField:Vector.<Vector.<int>>;
        public var yourScore:int;
        public var theirScore:int;

        public function Rule()
        {
            reset();
        }

        /**
         * After hand appears. 
         * Generate deck with tutorial at first, then full deck.
         */
        public function reset():void 
        {
            trace("Rule.reset:  Now your cards will be dealt in the tutorial's starting order.");
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
            else if (deck.length <= 0) {
                deck = shuffle(generateDeck());
            }
            yourHand = new Vector.<int>();
            theirHand = new Vector.<int>();
            yourField = new Vector.<Vector.<int>>();
            theirField = new Vector.<Vector.<int>>();
            yourScore = 0;
            theirScore = 0;
        }
        
        /* Deal one card to your hand. */
        public function deal(hand:Vector.<int>):int
        {
            var dealt:int = DataUtil.Shift(this.deck);
            hand.push(dealt);
            return dealt;
        }

        public static function generateDeck():Vector.<int>
        {
            var cards:Vector.<int> = new Vector.<int>();
            var counts:Vector.<int> = DataUtil.ToList( 0,  8,  8, 16, 12, 
                                20,  8, 12,  8,  8);
            for (var c:int = 0; c < counts.length; c++) {
                for (var count:int = 0; count < counts[c]; count++)
                {
                    cards.push(c);
                }
            }
            return cards;
        }

        /**
         * @param    cards  In-place.
         */
        public static function shuffle(cards:Vector.<int>):Vector.<int>
        {
            for (var i:int = cards.length - 1; 1 <= i; i--) {
                var other:int = int(Math.random() * (i + 1));
                var temp:int = cards[i];
                cards[i] = cards[other];
                cards[other] = temp;
            }
            return cards;
        }

        /* At least one frame beforehand, Contract must exist.  
         * Move card from deck to contract.  
         * DOES NOT yet check if deck has one or fewer cards.  */
        public function revealContract():Vector.<int> 
        {
            var tensValue:int = DataUtil.Shift(this.deck);
            var onesValue:int = DataUtil.Shift(this.deck);
            contract = 10 * tensValue + onesValue;
            var contractCards:Vector.<int> = new Vector.<int>();
            contractCards.push(tensValue);
            contractCards.push(onesValue);
            return contractCards;
        }

        /* We keep our hand and score.  We discard the rest. 
         * Discard stacks and city contract.  */
        public function clear():void
        {
            this.contract = 0;
            this.yourField = new Vector.<Vector.<int>>();
            this.theirField = new Vector.<Vector.<int>>();
        }

        public function discard(hand:Vector.<int>, value:int):void
        {
            hand.splice(hand.indexOf(value), 1);
        }

        public function playCard(you:Boolean, value:int, stackIndex:int):void
        {
            var field:Vector.<Vector.<int>> = you ? yourField : theirField;
            var hand:Vector.<int> = you ? yourHand : theirHand;
            discard(hand, value);
            if (field.length <= stackIndex) {
                field.push(new Vector.<int>());
            }
            var stack:Vector.<int> = field[stackIndex];
            stack.push(value);
        }

        public function equalsContract(you:Boolean):Boolean
        {
            var field:Vector.<Vector.<int>> = you ? yourField : theirField;
            return contract == Calculate.power(field);
        }

        public function tallestStackInField(field:Vector.<Vector.<int>>):int
        {
            var max:int = 0;
            for (var f:int = 0; f < field.length; f++) {
                if (max < field[f].length) {
                    max = field[f].length;
                }
            }
            return max;
        }

        public function tallestStack():int
        {
            return Math.max(tallestStackInField(yourField),
                tallestStackInField(theirField));
        }

        /**
         * Add to score for anyone by length of anyone's longest stack.
         * @return  If anyone scored.
         */
        public function score():Boolean
        {
            var scored:Boolean = false;
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
