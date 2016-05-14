package com.finegamedesign.utils
{
    public final class DataUtil
    {
         public static function CloneList(original:*):*
         {
             return original.concat();
         }

         public static function Length(data:*):int
         {
             return data.length;
         }

         public static function Clear(data:*):void
         {
             data.length = 0;
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
    }
}
