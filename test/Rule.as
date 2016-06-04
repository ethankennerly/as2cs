package com.finegamedesign.powerplant 
{
    /**
     * Model of rules to play Power Plant without their appearance.
     * @author Ethan Kennerly
     */
    public class Rule
    {
        public var deck:Array;
        public var contract:int;
        /**
         * These could be refactored to class per player.
         */
        public var yourHand:Array;
        public var theirHand:Array;
        public var yourField:Array;
        public var theirField:Array;
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
                deck = [1, 3, 
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
                        1, 1];
            }
            else if (deck.length <= 0) {
                deck = shuffle(generateDeck());
            }
            yourHand = new Array();
            theirHand = new Array();
            yourField = new Array();
            theirField = new Array();
            yourScore = 0;
            theirScore = 0;
        }
        
        /* Deal one card to your hand. */
        public function deal(hand:Array):int
        {
            var dealt:int = this.deck.shift();
            hand.push(dealt);
            return dealt;
        }

        public static function generateDeck():Array
        {
            var cards:Array = [];
            var counts:Array = [ 0,  8,  8, 16, 12, 
                                20,  8, 12,  8,  8];
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
        public static function shuffle(cards:Array):Array
        {
            for (var i:int = cards.length - 1; 1 <= i; i--) {
                var other:int = Math.random() * (i + 1);
                var temp:int = cards[i];
                cards[i] = cards[other];
                cards[other] = temp;
            }
            return cards;
        }

        /* At least one frame beforehand, Contract must exist.  
         * Move card from deck to contract.  
         * DOES NOT yet check if deck has one or fewer cards.  */
        public function revealContract():Array 
        {
            var tensValue:int = this.deck.shift();
            var onesValue:int = this.deck.shift();
            contract = 10 * tensValue + onesValue;
            return [tensValue, onesValue];
        }

        /* We keep our hand and score.  We discard the rest. 
         * Discard stacks and city contract.  */
        public function clear():void
        {
            this.contract = 0;
            this.yourField = [];
            this.theirField = [];
        }

        public function discard(hand:Array, value:int):void
        {
            hand.splice(hand.indexOf(value), 1);
        }

        public function playCard(you:Boolean, value:int, stackIndex:int):void
        {
            var field:Array = you ? yourField : theirField;
            var hand:Array = you ? yourHand : theirHand;
            discard(hand, value);
            if (field.length <= stackIndex) {
                field.push([]);
            }
            field[stackIndex].push(value);
        }

        public function equalsContract(you:Boolean):Boolean
        {
            var field:Array = you ? yourField : theirField;
            return contract == Calculate.power(field);
        }

        public function tallestStackInField(field:Array):int
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
