using System.Collections;
using System.Collections.Generic;

using com.finegamedesign.utils/*<DataUtil>*/;
namespace monster
{
    public class Pool
    {
        public int index;
        private ArrayList pool = new ArrayList(){
        }
        ;
        private int max;
        public delegate dynamic FactoryDelegate1(dynamic factoryArgument);
        
        public static Dictionary<string, dynamic> construct(/*<Function>*/FactoryDelegate1 factory, Dictionary<string, dynamic> classNameCounts)
        {
            Dictionary<string, dynamic> pools = new Dictionary<string, dynamic>(){
            }
            ;
            foreach(KeyValuePair<string, dynamic> _entry in classNameCounts){
                string className = _entry.Key;
                int count = classNameCounts[className];
                Pool pool = new Pool(count, factory, className);
                pools[className] = pool;}
            return pools;
        }
        
        public Pool(int count, /*<Function>*/FactoryDelegate1 factory, dynamic factoryArgument=null)
        {
            max = count;
            for (int i = 0; i < max; i++)
            {
                dynamic instance;
                if (!object.ReferenceEquals(null, factoryArgument))
                {
                    instance = factory(factoryArgument);
                }
                else
                {
                    instance = factory();
                }
                pool.Add(instance);
            }
            index = 0;
        }
        
        public dynamic next()
        {
            dynamic item = pool[index];
            index++;
            if (DataUtil.Length(pool) <= index)
            {
                index = 0;
            }
            return item;
        }
    }
}