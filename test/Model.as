package 
{
    /**
     * Portable.  Independent of Flash.
     */
    public class Model
    {
        /**
         * @param   represents  Nested hash of descendents.
         * @param   prefix      Filtered to this prefix.
         * @return  Array of child names that start with prefix, and have suffix "_0", where 0 may be any digits.  
         *          Sorted from back to front.
         */
        public static function keys(represents:Object, prefix:String=""):Array
        {
            var childNames:Array = [];
            if (represents)
            {
                for (var name:String in represents)
                {
                    if (0 === name.indexOf(prefix)) 
                    {
                        childNames.push(name);
                    }
                }
            }
            return childNames;
        }
    }
}
