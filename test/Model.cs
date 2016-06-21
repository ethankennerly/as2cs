using System.Collections;
using System.Collections.Generic;
namespace Monster
{
    /**
     * Portable.  Independent of platform.
     */
    public class Model
    {
        /**
         * @param   represents  Nested hash of descendents.
         * @param   prefix      Filtered to this prefix.
         * @return  Array of child names that start with prefix, and have suffix "_0", where 0 may be any digits.
         *          Sorted from back to front.
         */
        public static ArrayList Keys(Dictionary<string, dynamic> represents, string prefix="")
        {
            ArrayList childNames = new ArrayList(){
            }
            ;
            if (null != represents)
            {
                foreach(KeyValuePair<string, dynamic> _entry in represents){
                    string name = _entry.Key;
                    if (object.ReferenceEquals(0, name.IndexOf(prefix)))
                    {
                        childNames.Add(name);
                    }
                }
            }
            return childNames;
        }
    }
}