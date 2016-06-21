using UnityEngine;
using System.Collections;
using System.Collections.Generic;
// using flash.display.DisplayObjectContainer;
using /*<com>*/Finegamedesign.Utils/*<DataUtil>*/;
namespace Monster
{
    public class Controller
    {
        public delegate /*<var>*/void ChildKeyChangeDelegate(string _key, string _change);
        
        public static void ListenToChildren(Dictionary<string, dynamic> view, ArrayList childNames, string methodName, /*<var>*/object owner)
        {
            for (int c = 0; c < DataUtil.Length(childNames); c++)
            {
                string name = (string)(childNames[c]);
                var child = view[name];
                // View.listenToOverAndDown(child, methodName, owner);
            }
        }
        
        public static bool IsObject(/*<var>*/object value)
        {
            return !(value is int || value is string || value is float || value is bool);
        }
        
        /**
         * @param   changes     What is different as nested hashes.
         */
        public static void Visit(Dictionary<string, dynamic> parent, Dictionary<string, dynamic> changes)
        {
            foreach(KeyValuePair<string, dynamic> _entry in changes){
                string key = _entry.Key;
                var change = changes[key];
                var child = parent[key];
                if (IsObject(change))
                {
                    Visit((Dictionary<string, dynamic>)(child), (Dictionary<string, dynamic>)(change));
                }
                else
                {
                    if (object.ReferenceEquals("x", key))
                    {
                        //+ ViewUtil.setPositionX(parent, change);
                    }
                    else if (object.ReferenceEquals("y", key))
                    {
                        //+ ViewUtil.setPositionY(parent, change);
                    }
                    else if (object.ReferenceEquals("visible", key))
                    {
                        ViewUtil.SetVisible((GameObject)(parent["view"]), (bool)(change));
                    }
                }
            }
        }
    }
}