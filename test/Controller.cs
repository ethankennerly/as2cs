using System.Collections;

using com.finegamedesign.utils/*<DataUtil>*/;

public class Controller
{
    public static void listenToChildren(dynamic view, ArrayList childNames, string methodName, dynamic owner)
    {
        for (int c = 0; c < DataUtil.Length(childNames); c++)
        {
            string name = childNames[c];
            dynamic child = view[name];
            View.listenToOverAndDown(child, methodName, owner);
        }
    }
    
    public static bool isObject(dynamic value)
    {
        return object.ReferenceEquals("object", typeof(value));
    }
    
    /**
     * @param   changes     What is different as nested hashes.
     */
    public static void visit(dynamic parent, Dictionary<string, dynamic> changes, Function boundFunction)
    {
        foreach(KeyValuePair<string, dynamic> _entry in changes){
            string key = _entry.Key;
            dynamic change = changes[key];
            dynamic child = parent[key];
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