using com.finegamedesign.anagram.Model;
/*import com.finegamedesign.anagram.Controller;*/
using com.finegamedesign.anagram.View;
/**
 * This file demos every feature supported by as2cs.
 * The C# version is auto-generated from the ActionScript.
 */
namespace com.finegamedesign.anagram
{
    // This class has all supported features.
    public sealed class AllInOne : EmptyClass, IModel, IController
    {
        private static string _cache = "";
        
        /**
         * Set cache.
         */
        internal static void function setTest()
        {
            // Comment is not converted.
            // trace("setTest: " + _cache);
            string test = "test";
            _cache = test;
            
        }
        
        public int index;
        public float x;
        public float y;
        
        public void function AllInOne(float x=.0f, float y=0.0f, int index=-1)  // return type required.
        {
            this.x = x;
            this.y = y;
            this.index = index;
            setTest();
        }
    }
}