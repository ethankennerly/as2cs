package com.finegamedesign.powerplant
{
    import com.finegamedesign.utils.DataUtil;
    /**
     * @author Ethan Kennerly
     */
    public class Calculate
    {
        /**
         * Multiply cards in stack.  Add stack products.
         * Example @see TestCalculate.as
         */
        public static function power(stacks:Vector.<Vector.<int>>):int
        {
            var power:int = 0;
            for (var s:int=0; s < DataUtil.Length(stacks); s++) {
                var product:int = 0;
                for (var c:int=0; c < DataUtil.Length(stacks[s]); c++) {
                    if (0 == c) {
                        product = stacks[s][c];
                    }
                    else {
                        product *= stacks[s][c];
                    }
                }
                power += product;
            }
            return power;
        }

        /**
         * Multiply cards in stack.  Add stack products.
         * Example @see TestCalculate.as
         */
        public static function describe(stacks:Vector.<Vector.<int>>):String
        {
            var description:String = "";
            var term_count:int = 0;
            var products:Vector.<int> = new Vector.<int>();
            var trimmed:Vector.<Vector.<int>> = clone(stacks);
            removeEmpty(trimmed);
            for (var s:int=0; s < DataUtil.Length(trimmed); s++) {
                var product:String = "";
                term_count += DataUtil.Length(trimmed[s]);
                if (2 <= DataUtil.Length(trimmed) && 2 <= DataUtil.Length(trimmed[s])) {
                    product += "(";
                }
                product += trimmed[s].join(" x ");
                if (2 <= DataUtil.Length(trimmed) && 2 <= DataUtil.Length(trimmed[s])) {
                    product += ")";
                }
                products.push(product);
            }
            if (2 <= term_count) {
                description += products.join(" + ")
                    + " = " + power(trimmed).toString();
            }
            return description;
        }

        private static function removeEmpty(stacks:Vector.<Vector.<int>>):void
        {
            for (var s:int = DataUtil.Length(stacks) - 1; 0 <= s; s--) {
                if (DataUtil.Length(stacks[s]) <= 0) {
                    stacks.splice(s, 1);
                }
            }
        }

        /**
         * Select a card from hand that plays on a stack to match contract,
         * or most nearly approaches contract without going over.
         * Example @see TestCalculate.as
         */
        public static function stacksUnderContract(value:int, stacks:Vector.<Vector.<int>>, contract:int):Vector.<Boolean>
        {
            var stacks_valid:Vector.<Boolean> = new Vector.<Boolean>();
            var hypothetical_stacks:Vector.<Vector.<int>> = clone(stacks);
            if (DataUtil.Length(hypothetical_stacks) <= 0 || 1 <= DataUtil.Length(
                    hypothetical_stacks[DataUtil.Length(hypothetical_stacks) - 1])) {
                hypothetical_stacks.push(new Vector.<int>());
            }
            for (var s:int=0; s < DataUtil.Length(hypothetical_stacks); s++) {
                hypothetical_stacks[s].push(value);
                var hypothetical_power:int = power(hypothetical_stacks);
                stacks_valid.push(hypothetical_power <= contract);
                DataUtil.Pop(hypothetical_stacks[s]);
            }
            return stacks_valid;
        }

        /**
         * Select a card from hand that plays on a stack to match contract,
         * or most nearly approaches contract without going over.
         * Example @see TestCalculate.as
         */
        public static function select_value_and_stack(hand:Vector.<int>, stacks:Vector.<Vector.<int>>, contract:int):Vector.<int>
        {
            var value_and_stack:Vector.<int> = new Vector.<int>();
            var max:int = 0;
            var hypothetical_stacks:Vector.<Vector.<int>> = clone(stacks);
            hypothetical_stacks.push(new Vector.<int>());
            for (var h:int=0; h < DataUtil.Length(hand); h++) {
                for (var s:int=0; s < DataUtil.Length(hypothetical_stacks); s++) {
                    hypothetical_stacks[s].push(hand[h]);
                    var candidate:int = power(hypothetical_stacks);
                    if (max < candidate && candidate <= contract) {
                        max = candidate;
                        value_and_stack = [hand[h], s];
                    }
                    DataUtil.Pop(hypothetical_stacks[s]);
                }
            }
            return value_and_stack;
        }
 
        public static function clone(stacks:Vector.<Vector.<int>>):*
        {
            var copy:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
            for (var s:int = 0; s < DataUtil.Length(stacks); s++) {
                var stack:Vector.<int> = stacks[s];
                var copyStack:Vector.<int> = new Vector.<int>();
                for (var i:int = 0; i < DataUtil.Length(stack); i++) {
                    copyStack.push(stack[i]);
                }
                copy.push(copyStack);
            }
            return copy;
        }
    }
}
