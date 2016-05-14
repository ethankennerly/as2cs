package com.finegamedesign.anagram
{
    import com.finegamedesign.utils.Model;

    public class TestSyntaxModel
    {
        private static function shuffle(cards:Vector.<String>):void
        {
            for (var i:int = DataUtil.Length(cards) - 1; 1 <= i; i--)
            {
                var r:int = int(Math.floor(Math.random() * (i + 1)));
                var swap:String = cards[r];
                cards[r] = cards[i];
                cards[i] = swap;
            }
        }

        internal var helpState:String;
        internal var letterMax:int = 10;
        internal var inputs:Vector.<String> = new Vector.<String>();
        /**
         * From letter graphic.
         */
        internal var letterWidth:Number = 42.0;
        internal var /*<delegate>*/ ActionDelegate:/*<void>*/*;
        internal var onComplete:/*<ActionDelegate>*/Function; 
        internal var /*<delegate>*/ IsJustPressed:Boolean, letter:String;
        internal var help:String;
        internal var outputs:Vector.<String> = new Vector.<String>();
        internal var completes:Vector.<String> = new Vector.<String>();
        internal var text:String;
        internal var word:Vector.<String>;
        internal var wordPosition:Number = 0.0;
        internal var wordPositionScaled:Number = 0.0;
        internal var points:int = 0;
        internal var score:int = 0;
        internal var state:String;
        internal var levels:Levels = new Levels();
        private var available:Vector.<String>;
        private var repeat:Object = {};
        private var selects:Vector.<String>;
        private var wordHash:Object;
        private var isVerbose:Boolean = false;

        public function TestSyntaxModel()
        {
            wordHash = {"aa": true};
            // trial(levels.getParams());
            trial({"help": "Hello world"});
        }

        internal function trial(parameters:Object):void
        {
            wordPosition = 0.0;
            help = "";
            wordWidthPerSecond = -0.01;
            if (null != parameters["text"]) {
                text = String(parameters["text"]);
            }
            if (null != parameters["help"]) {
                help = String(parameters["help"]);
            }
            if (null != parameters["wordWidthPerSecond"]) {
                wordWidthPerSecond = Number(parameters["wordWidthPerSecond"]);
            }
            if (null != parameters["wordPosition"]) {
                wordPosition = Number(parameters["wordPosition"]);
            }
            available = DataUtil.Split(text, "");
            word = DataUtil.CloneList(available);
            if ("" == help)
            {
                shuffle(word);
                wordWidthPerSecond = // -0.05;
                                     // -0.02;
                                     // -0.01;
                                     // -0.005;
                                     -0.002;
                                     // -0.001;
                var power:Number = 
                                   // 1.5;
                                   // 1.75;
                                   2.0;
                var baseRate:int = Math.max(1, letterMax - DataUtil.Length(text));
                wordWidthPerSecond *= Math.pow(baseRate, power);
            }
            selects = DataUtil.CloneList(word);
            repeat = {};
            if (isVerbose) trace("Model.trial: word[0]: <" + word[0] + ">");
        }

        private var previous:int = 0;
        private var now:int = 0;

        internal function updateNow(cumulativeMilliseconds:int):void
        {
            var deltaSeconds:Number = (now - previous) / 1000.0;
            update(deltaSeconds);
            previous = now;
        }

        internal function update(deltaSeconds:Number):void
        {
            updatePosition(deltaSeconds);
        }

        internal var width:Number = 720;
        internal var scale:Number = 1.0;
        private var wordWidthPerSecond:Number;

        internal function scaleToScreen(screenWidth:Number):void
        {
            scale = screenWidth / width;
        }

        /**
         * Test case:  2015-03 Use Mac. Rosa Zedek expects to read key to change level.
         */
        private function clampWordPosition():void
        {
            var wordWidth:Number = 160;
            var min:Number = wordWidth - width;
            if (wordPosition <= min)
            {
                help = "GAME OVER! TO SKIP ANY WORD, PRESS THE PAGEUP KEY (MAC: FN+UP).  TO GO BACK A WORD, PRESS THE PAGEDOWN KEY (MAC: FN+DOWN).";
                helpState = "gameOver";
            }
            wordPosition = Math.max(min, Math.min(0, wordPosition));
        }

        private function updatePosition(seconds:Number):void
        {
            wordPosition += (seconds * width * wordWidthPerSecond);
            clampWordPosition();
            wordPositionScaled = wordPosition * scale;
            if (isVerbose) trace("Model.updatePosition: " + wordPosition);
        }

        private var outputKnockback:Number = 0.0;

        internal function mayKnockback():Boolean
        {
            return 0 < outputKnockback && 1 <= DataUtil.Length(outputs);
        }

        /**
         * Clamp word to appear on screen.  Test case:  2015-04-18 Complete word.  See next word slide in.
         */
        private function prepareKnockback(length:int, complete:Boolean):void
        {
            var perLength:Number = 
                                   0.03;
                                   // 0.05;
                                   // 0.1;
            outputKnockback = perLength * width * length;
            if (complete) {
                outputKnockback *= 3;
            }
            clampWordPosition();
        }

        internal function onOutputHitsWord():Boolean
        {
            var enabled:Boolean = mayKnockback();
            if (enabled)
            {
                wordPosition += outputKnockback;
                shuffle(word);
                selects = DataUtil.CloneList(word);
                for (var i:int = 0; i < DataUtil.Length(inputs); i++)
                {
                    var letter:String = inputs[i];
                    var selected:int = selects.indexOf(letter);
                    if (0 <= selected)
                    {
                        selects[selected] = letter.toLowerCase();
                    }
                }
                outputKnockback = 0;
            }
            return enabled;
        }

        /**
         * @param   justPressed     Filter signature justPressed(letter):Boolean.
         */
        internal function getPresses(justPressed:/*<IsJustPressed>*/Function):Vector.<String>
        {
            var presses:Vector.<String> = new Vector.<String>();
            var letters:Object = {};
            for (var i:int = 0; i < DataUtil.Length(available); i++) 
            {
                var letter:String = available[i];
                if (letter in letters)
                {
                    continue;
                }
                else
                {
                    letters[letter] = true;
                }
                if (justPressed(letter)) 
                {
                    presses.push(letter);
                }
            }
            return presses;
        }

        /**
         * If letter not available, disable typing it.
         * @return Vector of word indexes.
         */
        internal function press(presses:Vector.<String>):Vector.<int>
        {
            var letters:Object = {};
            var selectsNow:Vector.<int> = new Vector.<int>();
            for (var i:int = 0; i < DataUtil.Length(presses); i++) 
            {
                var letter:String = presses[i];
                if (letter in letters)
                {
                    continue;
                }
                else
                {
                    letters[letter] = true;
                }
                var index:int = available.indexOf(letter);
                if (0 <= index)
                {
                    available.splice(index, 1);
                    inputs.push(letter);
                    var selected:int = selects.indexOf(letter);
                    if (0 <= selected)
                    {
                        selectsNow.push(selected);
                        selects[selected] = letter.toLowerCase();
                    }
                }
            }
            return selectsNow;
        }

        internal function backspace():Vector.<int>
        {
            var selectsNow:Vector.<int> = new Vector.<int>();
            if (1 <= DataUtil.Length(inputs))
            {
                var letter:String = DataUtil.Pop(inputs);
                available.push(letter);
                var selected:int = selects.lastIndexOf(letter.toLowerCase());
                if (0 <= selected)
                {
                    selectsNow.push(selected);
                    selects[selected] = letter;
                }
            }
            return selectsNow;
        }

        /**
         * @return animation state.
         *      "submit" or "complete":  Word shoots. Test case:  2015-04-18 Anders sees word is a weapon.
         *      "submit":  Shuffle letters.  Test case:  2015-04-18 Jennifer wants to shuffle.  Irregular arrangement of letters.  Jennifer feels uncomfortable.
         * Test case:  2015-04-19 Backspace. Deselect. Submit. Type. Select.
         */
        internal function submit():String
        {
            var submission:String = DataUtil.Join(inputs, "");
            var accepted:Boolean = false;
            state = "wrong";
            if (1 <= DataUtil.Length(submission))
            {
                if (submission in wordHash)
                {
                    if (submission in repeat)
                    {
                        state = "repeat";
                        if (levels.index <= 50 && "" == help)
                        {
                            help = "YOU CAN ONLY ENTER EACH SHORTER WORD ONCE.";
                            helpState = "repeat";
                        }
                    }
                    else
                    {
                        if ("repeat" == helpState)
                        {
                            helpState = "";
                            help = "";
                        }
                        repeat[submission] = true;
                        accepted = true;
                        scoreUp(submission);
                        var complete:Boolean = DataUtil.Length(text) == DataUtil.Length(submission);
                        prepareKnockback(DataUtil.Length(submission), complete);
                        if (complete)
                        {
                            completes = DataUtil.CloneList(word);
                            // trial(levels.up());
                            trial({});
                            state = "complete";
                            if (null != onComplete)
                            {
                                onComplete();
                            }
                        }
                        else 
                        {
                            state = "submit";
                        }
                    }
                }
                outputs = DataUtil.CloneList(inputs);
            }
            if (isVerbose) trace("Model.submit: " + submission + ". Accepted " + accepted);
            DataUtil.Clear(inputs);
            available = DataUtil.CloneList(word);
            selects = DataUtil.CloneList(word);
            return state;
        }

        private function scoreUp(submission:String):void
        {
            points = DataUtil.Length(submission);
            score += points;
        }

        internal function cheatLevelUp(add:int):void
        {
            score = 0;
            // trial(levels.up(add));
            trial({});
            wordPosition = 0.0;
        }
    }
}
