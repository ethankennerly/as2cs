using System.Collections;

using com.finegamedesign.utils/*<DataUtil>*/;
namespace com.finegamedesign.powerplant
{
    /**
     * @author Ethan Kennerly
     */
    public class Calculate
    {
        /**
         * Multiply cards in stack.  Add stack products.
         * Example @see TestCalculate.as
         */
        public static int power(ArrayList stacks)
        {
            int power = 0;
            for (int s=0; s < DataUtil.Length(stacks); s++) {
                int product = 0;
                for (int c=0; c < DataUtil.Length(stacks[s]); c++) {
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
        public static string describe(ArrayList stacks)
        {
            string description = "";
            int termCount = 0;
            ArrayList products = new ArrayList(){
            }
            ;
            ArrayList trimmed = clone(stacks);
            removeEmpty(trimmed);
            for (int s=0; s < DataUtil.Length(trimmed); s++) {
                string product = "";
                termCount += DataUtil.Length(trimmed[s]);
                if (2 <= DataUtil.Length(trimmed) && 2 <= DataUtil.Length(trimmed[s])) {
                    product += "(";
                }
                product += trimmed[s].join(" x ");
                if (2 <= DataUtil.Length(trimmed) && 2 <= DataUtil.Length(trimmed[s])) {
                    product += ")";
                }
                products.Add(product);
            }
            if (2 <= termCount) {
                description += products.join(" + ")
                + " = " + power(trimmed).ToString();
            }
            return description;
        }
        
        private static void removeEmpty(ArrayList stacks)
        {
            for (int s = DataUtil.Length(stacks) - 1; 0 <= s; s--) {
                if (DataUtil.Length(stacks[s]) <= 0) {
                    stacks.RemoveRange(s, 1);
                }
            }
        }
        
        /**
         * Select a card from hand that plays on a stack to match contract,
         * or most nearly approaches contract without going over.
         * Example @see TestCalculate.as
         */
        public static ArrayList stacksUnderContract(int value, ArrayList stacks, int contract)
        {
            ArrayList stacksValid = new ArrayList(){
            }
            ;
            ArrayList hypothetical_stacks = clone(stacks);
            if (DataUtil.Length(hypothetical_stacks) <= 0 || 1 <= DataUtil.Length(
            hypothetical_stacks[DataUtil.Length(hypothetical_stacks) - 1])) {
                hypothetical_stacks.Add(new ArrayList(){
                }
                );
            }
            for (int s=0; s < DataUtil.Length(hypothetical_stacks); s++) {
                hypothetical_stacks[s].Add(value);
                int hypothetical_power = power(hypothetical_stacks);
                stacksValid.Add(hypothetical_power <= contract);
                DataUtil.Pop(hypothetical_stacks[s]);
            }
            return stacksValid;
        }
        
        /**
         * Select a card from hand that plays on a stack to match contract,
         * or most nearly approaches contract without going over.
         * Example @see TestCalculate.as
         */
        public static ArrayList select_value_and_stack(ArrayList hand, ArrayList stacks, int contract)
        {
            ArrayList value_and_stack = new ArrayList(){
            }
            ;
            int max = 0;
            ArrayList hypothetical_stacks = clone(stacks);
            hypothetical_stacks.Add(new ArrayList(){
            }
            );
            for (int h=0; h < DataUtil.Length(hand); h++) {
                for (int s=0; s < DataUtil.Length(hypothetical_stacks); s++) {
                    hypothetical_stacks[s].Add(hand[h]);
                    int candidate = power(hypothetical_stacks);
                    if (max < candidate && candidate <= contract) {
                        max = candidate;
                        value_and_stack = new ArrayList(){
                            hand[h], s}
                        ;
                    }
                    DataUtil.Pop(hypothetical_stacks[s]);
                }
            }
            return value_and_stack;
        }
        
        public static dynamic clone(ArrayList stacks)
        {
            ArrayList copy = new ArrayList(){
            }
            ;
            for (int s = 0; s < DataUtil.Length(stacks); s++) {
                dynamic element;
                dynamic stack = stacks[s];
                if (stack is ArrayList) {
                    element = clone(stack);
                }
                else {
                    element = stack;
                }
                copy.Add(element);
            }
            return copy;
        }
    }
}