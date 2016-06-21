using /*<com>*/Finegamedesign.Anagram/*<Model>*/;
/*import com.finegamedesign.anagram.Controller;*/
using /*<com>*/Finegamedesign.Anagram/*<View>*/;
/**
 * This file demos every feature supported by as2cs.
 * The C# version is auto-generated from the ActionScript.
 */
namespace /*<com>*/Finegamedesign.Anagram
{
    // This class has all supported features.
    public sealed class AllInOne : EmptyClass // implements IModel, IController
    {
        private static string _cache = "";
        
        /**
         * Set cache.
         */
        internal static void SetTest()
        {
            // Comment is not converted.
            // trace("setTest: " + _cache);
            string test = "test";
            _cache = test;
            
        }
        
        public int index;
        public float x;
        public float y;
        
        public AllInOne(float x=.0f, float y=0.0f, int index=-1)
        {
            this.x = x;
            this.y = y;
            this.index = index;
            SetTest();
        }
    }
}