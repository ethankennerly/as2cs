using System.Collections;
using System.Collections.Generic;

using com.finegamedesign.utils/*<DataUtil>*/;
namespace com.finegamedesign.anagram
{
    public class Levels
    {
        
        internal int index = 0;
        /**
         * Some anagrams copied from:
         * http://www.enchantedlearning.com/english/anagram/numberofletters/5letters.shtml
         * Test case:  2015-04-18 Redbeard at The MADE types word.  Got stumped by anagram "ERISIOUS" and "NIOMTENTPO"
         * http://www.cse.unr.edu/~cohen/text.php
         */
        internal ArrayList parameters = new ArrayList(){
            new Dictionary<string, dynamic>(){
                {
                    "text", "START"}
                , {
                    "help", "ANAGRAM ATTACK\n\nCLICK HERE. TYPE 'START'.  PRESS THE SPACE KEY OR ENTER KEY."}
                ,
                {
                    "wordWidthPerSecond", 0.0f}
                ,
                {
                    "wordPosition", 0.0f}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LSEPL"}
                , {
                    "help", "TO ADVANCE, USE ALL THE LETTERS.  HINT:  'SPELL'.  THEN PRESS THE SPACE KEY OR ENTER KEY."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DWORS"}
                , {
                    "help", "SHORTER WORDS SHUFFLE SAME LETTERS. EXAMPLES: 'ROD', 'RODS', 'WORD', 'SWORD'."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "STARE"}
                , {
                    "help", "SHORTER WORDS KNOCKBACK.  YOU CAN USE EACH SHORT WORD ONCE. EXAMPLE:  'EAT', 'TEAR', 'STARE'"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "FOR"}
                , {
                    "help", "WORDS WITH FEW LETTERS MOVE FAST!"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "EAT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ART"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SAP"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SATE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "APT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ARM"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ERA"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "POST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "OWN"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PLEA"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "BATS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LEAD"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "BEAST"}
                , {
                    "help", "FOR BONUS POINTS, FIRST ENTER SHORT WORDS.  EXAMPLES: 'BE', 'BATS', 'AT'."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DIET"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "INKS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LIVE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "RACES"}
                , {
                    "help", "TOO CLOSE?  ENTER SHORT WORDS."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "KALE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SNOW"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "NEST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "STEAM"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "EMIT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "NAME"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SWAY"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PEARS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SKATE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "BREAD"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CODE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DIETS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CRATES"}
                , {
                    "help", "SHORT WORDS SHUFFLES LETTERS, BUT THEY REMAIN THE SAME."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "TERSE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LAPSE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PROSE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SPREAD"}
                , {
                    "help", "FOR BONUS POINTS OR KNOCKBACK, ENTER SHORT WORDS. TO ADVANCE, ENTER FULL WORD."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SMILE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ALERT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "BEGIN"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "TIMERS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "HEROS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PETAL"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LITER"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PETALS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "VERSE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "RESIN"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "NOTES"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SHEAR"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SUBTLE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SPARSE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "REWARD"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "REPLAYS"}
                , {
                    "help", "NEXT SESSION, TO SKIP WORDS, PRESS PAGEUP."}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "MANTEL"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DESIGN"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LASTED"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "RECANTS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "FOREST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "POINTS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "MASTER"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "THREADS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DANGER"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "SPRITES"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ARTIST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "TENSOR"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ARIDEST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "LISTEN"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PIRATES"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ALERTED"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ALLERGY"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "REDUCES"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "MEDICAL"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "RAPIDS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "RETARDS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "REALIST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "MEANEST"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ADMIRER"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "TRAINERS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "RECOUNTS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PARROTED"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DESIGNER"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CRATERED"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CALIPERS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CREATIVE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ARROGANT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "EMIGRANTS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "AUCTIONED"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CASSEROLE"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "UPROARS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "ANTIGEN"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "DEDUCTIONS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "INTRODUCES"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "PERCUSSION"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "CONFIDENT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "HARMONICAS"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "OMNIPOTENT"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "YOU"}
            }
            ,
            new Dictionary<string, dynamic>(){
                {
                    "text", "WIN"}
            }
        }
        ;
        
        internal Dictionary<string, dynamic> getParams()
        {
            return (Dictionary<string, dynamic>)parameters[index];
        }
        
        internal Dictionary<string, dynamic> up(int add = 1)
        {
            index = (index + add) % DataUtil.Length(parameters);
            while (index < 0)
            {
                index += DataUtil.Length(parameters);
            }
            return getParams();
        }
        
        internal int current()
        {
            return index + 1;
        }
        
        internal int count()
        {
            return DataUtil.Length(parameters);
        }
    }
}