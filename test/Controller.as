package monster
{
    import flash.display.DisplayObjectContainer;
    import com.finegamedesign.utils.DataUtil;

    public class Controller
    {
        public var /*<delegate>*/ ChildKeyChangeDelegate:/*<void>*/*, _key:String, _change:String;

        public static function listenToChildren(view:Object, childNames:Array, methodName:String, owner:/*<object>*/*):void
        {
            for (var c:int = 0; c < DataUtil.Length(childNames); c++) 
            {
                var name:String = String(childNames[c]);
                var child:* = view[name];
                // View.listenToOverAndDown(child, methodName, owner);
            }
        }

        public static function isObject(value:/*<object>*/*):Boolean
        {
            return !(value is int || value is String || value is Number || value is Boolean);
        }

        /**
         * @param   changes     What is different as nested hashes.
         */
        public static function visit(parent:Object, changes:Object):void
        {
            for (var key:String in changes)
            {
                var change:* = changes[key];
                var child:* = parent[key];
                if (isObject(change))
                {
                    visit(Object(child), Object(change));
                }
                else
                {
                    if ("x" === key)
                    {
                        //+ ViewUtil.setPositionX(parent, change);
                    }
                    else if ("y" === key)
                    {
                        //+ ViewUtil.setPositionY(parent, change);
                    }
                    else if ("visible" === key)
                    {
                        ViewUtil.setVisible(DisplayObjectContainer(parent["view"]), Boolean(change));
                    }
                }
            }
        }
    }
}
