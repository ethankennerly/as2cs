using System.Collections;
using System.Collections.Generic;

using com.finegamedesign.utils/*<DataUtil>*/;
namespace monster
{
    public class Controller
    {
        public delegate var ChildKeyChangeDelegate(string _key, string _change);
        
        public static void listenToChildren(/*<var>*/object view, ArrayList childNames, string methodName, /*<var>*/object owner)
        {
            for (int c = 0; c < DataUtil.Length(childNames); c++)
            {
                string name = childNames[c];
                var child = view[name];
                View.listenToOverAndDown(child, methodName, owner);
            }
        }
        
        public static bool isObject(/*<var>*/object value)
        {
            return !(value is int || value is string || value is float || value is bool);
        }
        
        /**
         * @param   changes     What is different as nested hashes.
         */
        public static void visit(/*<var>*/object parent, Dictionary<string, dynamic> changes, /*<Function>*/ChildKeyChangeDelegate boundFunction)
        {
            foreach(KeyValuePair<string, dynamic> _entry in changes){
                string key = _entry.Key;
                var change = changes[key];
                var child = parent[key];
                child = boundFunction(child, key, change);
                if (isObject(change))
                {
                    visit(child, change, boundFunction);
                }
                else
                {
                    if (object.ReferenceEquals("x", key))
                    {
                        View.setPositionX(parent, change);
                    }
                    else if (object.ReferenceEquals("y", key))
                    {
                        View.setPositionY(parent, change);
                    }
                    else if (object.ReferenceEquals("visible", key))
                    {
                        View.setVisible(parent, change);
                    }
                }
            }
        }
    }
}