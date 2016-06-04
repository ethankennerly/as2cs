package monster
{
    import com.finegamedesign.utils.DataUtil;

    public class Controller
    {
        public var /*<delegate>*/ ChildKeyChangeDelegate:*, _key:String, _change:String;

        public static function listenToChildren(view:*, childNames:Array, methodName:String, owner:*):void
        {
            for (var c:int = 0; c < DataUtil.Length(childNames); c++) 
            {
                var name:String = childNames[c];
                var child:* = view[name];
                View.listenToOverAndDown(child, methodName, owner);
            }
        }

        public static function isObject(value:*):Boolean
        {
            return "object" === typeof(value);
        }

        /**
         * @param   changes     What is different as nested hashes.
         */
        public static function visit(parent:*, changes:Object, boundFunction:/*<ChildKeyChangeDelegate>*/Function):void
        {
            for (var key:String in changes)
            {
                var change:* = changes[key];
                var child:* = parent[key];
                child = boundFunction(child, key, change);
                if (isObject(change))
                {
                    visit(child, change, boundFunction);
                }
                else
                {
                    if ("x" === key)
                    {
                        View.setPositionX(parent, change);
                    }
                    else if ("y" === key)
                    {
                        View.setPositionY(parent, change);
                    }
                    else if ("visible" === key)
                    {
                        View.setVisible(parent, change);
                    }
                }
            }
        }
    }
}
