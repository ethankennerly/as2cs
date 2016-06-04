package 
{
    public class Pool
    {
        public var index:int;
        private var pool:Array = [];
        private var max:int;

        public static function construct(factory:Function, classNameCounts:Object):Object
        {
            var pools:Object = {};
            for (var className:String in classNameCounts)
            {
                var count:int = classNameCounts[className];
                var pool:Pool = new Pool(count, factory, className);
                pools[className] = pool;
            }
            return pools;
        }

        public function Pool(count:int, factory:Function, factoryArgument:*=null)
        {
            max = count;
            for (var i:int = 0; i < max; i++)
            {
                var instance:*;
                if (null !== factoryArgument)
                {
                    instance = factory(factoryArgument);
                }
                else
                {
                    instance = factory();
                }
                pool.push(instance);
            }
            index = 0;
        }

        public function next():*
        {
            var item:* = pool[index];
            index++;
            if (pool.length <= index)
            {
                index = 0;
            }
            return item;
        }
    }
}
