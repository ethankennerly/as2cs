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
        public static function power(stacks:Array):int
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
        public static function describe(stacks:Array):String
        {
            var description:String = "";
            var termCount:int = 0;
            var products:Array = [];
            var trimmed:Array = clone(stacks);
            removeEmpty(trimmed);
            for (var s:int=0; s < DataUtil.Length(trimmed); s++) {
                var product:String = "";
                termCount += DataUtil.Length(trimmed[s]);
                if (2 <= DataUtil.Length(trimmed) && 2 <= DataUtil.Length(trimmed[s])) {
                    product += "(";
                }
                product += trimmed[s].join(" x ");
                if (2 <= DataUtil.Length(trimmed) && 2 <= DataUtil.Length(trimmed[s])) {
                    product += ")";
                }
                products.push(product);
            }
            if (2 <= termCount) {
                description += products.join(" + ")
                    + " = " + power(trimmed).toString();
            }
            return description;
        }

        private static function removeEmpty(stacks:Array):void
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
        public static function stacksUnderContract(value:int, stacks:Array, contract:int):Array
        {
            var stacksValid:Array = [];
            var hypothetical_stacks:Array = clone(stacks);
            if (DataUtil.Length(hypothetical_stacks) <= 0 || 1 <= DataUtil.Length(
                    hypothetical_stacks[DataUtil.Length(hypothetical_stacks) - 1])) {
                hypothetical_stacks.push([]);
            }
            for (var s:int=0; s < DataUtil.Length(hypothetical_stacks); s++) {
                hypothetical_stacks[s].push(value);
                var hypothetical_power:int = power(hypothetical_stacks);
                stacksValid.push(hypothetical_power <= contract);
                DataUtil.Pop(hypothetical_stacks[s]);
            }
            return stacksValid;
        }

        /**
         * Select a card from hand that plays on a stack to match contract,
         * or most nearly approaches contract without going over.
         * Example @see TestCalculate.as
         */
        public static function select_value_and_stack(hand:Array, stacks:Array, contract:int):Array
        {
            var value_and_stack:Array = [];
            var max:int = 0;
            var hypothetical_stacks:Array = clone(stacks);
            hypothetical_stacks.push([]);
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
 
        public static function clone(stacks:Array):*
        {
            var copy:Array = [];
            for (var s:int = 0; s < DataUtil.Length(stacks); s++) {
                var element:*;
                var stack:* = stacks[s];
                if (stack is Array) {
                    element = clone(stack);    
                }
                else {
                    element = stack;
                }
                copy.push(element);
            }
            return copy;
        }
    }
}
