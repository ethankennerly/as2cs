package com.finegamedesign.utils
{
    import flash.display.Sprite;
    import flash.geom.Point;

    public final class DataUtil
    {
         public static function CloneList(original:*):*
         {
             return original.concat();
         }

         public static function Length(data:*):int
         {
             if (data.hasOwnProperty("length")) {
                 return data.length;
             }
             else {
                 var count:int = 0;
                 for (var key:String in data) {
                    count++;
                 }
                 return count;
             }
         }

         public static function Clear(data:*):void
         {
             data.length = 0;
         }

         public static function Pop(arrayOrVector:*):void
         {
             arrayOrVector.pop();
         }

         public static function Shift(arrayOrVector:*):void
         {
             arrayOrVector.shift();
         }

         public static function SplitToArrayList(text:String, delimiter:String):Array
         {
             return text.split(delimiter);
         }

         public static function Split(text:String, delimiter:String):Vector.<String>
         {
             var parts:Array = text.split(delimiter);
             var strings:Vector.<String> = new Vector.<String>();
             for (var p:int = 0; p < parts.length; p++) {
                 strings.push(parts[p]);
             }
             return strings;
         }

         public static function Join(texts:*, delimiter:String):String
         {
             return texts.join(delimiter);
         }

         public static function Replace(text:String, from:String, to:String):String
         {
             return Join(Split(text, from), to);
         }

         public static function Trim(text:String):String
         {
            return text.replace(/^\s+|\s+$/g, "");
         }

         /**
          * Is integer or single floating point.
          */
         public static function IsNumber(text:String):Boolean
         {
             return !isNaN(parseFloat(text));
         }

         /**
          * Is data type flat or a class or collection?
          */
         public static function IsFlat(value:*):Boolean
         {
             return Boolean((value is String) || (value is Number) 
                || (value is int) || (null == value));
         }

         /**
          * Only supports basic data types:  int, Number, Boolean, String, and vectors of those.
          */
         public static function ToList(... rest):*
         {
             return ToListItems(rest);
         }

         public static function ToListItems(elements:*):*
         {
            var aList:*;
             if (elements[0] is int) {
                 aList = new Vector.<int>();
             }
             else if (elements[0] is Number) {
                 aList = new Vector.<Number>();
             }
             else if (elements[0] is String) {
                 aList = new Vector.<String>();
             }
             else if (elements[0] is Boolean) {
                 aList = new Vector.<Boolean>();
             }
             else if (elements[0] is Point) {
                 aList = new Vector.<Point>();
             }
             else if (elements[0] is Sprite) {
                 aList = new Vector.<Sprite>();
             }
             else if (elements[0] is Vector.<int>) {
                 aList = new Vector.<Vector.<int>>();
             }
             else if (elements[0] is Vector.<Number>) {
                 aList = new Vector.<Vector.<Number>>();
             }
             else if (elements[0] is Vector.<String>) {
                 aList = new Vector.<Vector.<String>>();
             }
             else if (elements[0] is Vector.<Boolean>) {
                 aList = new Vector.<Vector.<Boolean>>();
             }
             else if (elements[0] is Vector.<Point>) {
                 aList = new Vector.<Vector.<Point>>();
             }
             else if (elements[0] is Vector.<Sprite>) {
                 aList = new Vector.<Vector.<Sprite>>();
             }
             else {
                 aList = new Array();
             }
             for (var i:int = 0; i < elements.length; i++) {
                 aList.push(elements[i]);
             }
             return aList;
         }

         public static function ToArrayList(iterable:*):Array
         {
             var items:Array = [];
             for (var i:int = 0; i < iterable.length; i++) {
                 items.push(iterable[i]);
             }
             return items;
         }
    }
}
