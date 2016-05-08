/**
 * This file demos every feature supported by as2cs.
 * The C# version is auto-generated from the ActionScript.
 */
package com.finegamedesign.anagram
{
    import com.finegamedesign.anagram.Model;
    /*import com.finegamedesign.anagram.Controller;*/
    import com.finegamedesign.anagram.View;

    // This class has all supported features.
    public final class AllInOne extends EmptyClass implements IModel, IController
    {
        private static var _cache:String = "";

        /**
         * Set cache.
         */
        internal static function setTest():void
        {
            // Comment is not converted.
            // trace("setTest: " + _cache);
            var test:String = "test";
            _cache = test;

        }

        public var index:int;
        public var x:Number;
        public var y:Number;

        public function AllInOne(x:Number=.0, y:Number=0.0, index:int=-1)
        {
            this.x = x;
            this.y = y;
            this.index = index;
            setTest();
        }
    }
}
