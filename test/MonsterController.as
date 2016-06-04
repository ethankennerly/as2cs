package 
{
    import com.finegamedesign.utils.DataUtil;
    /**
     * Portable.  Independent of platform.
     */
    public class MonsterController
    {
        private var model:MonsterModel;
        private var view:*;
        private var classNameCounts:Object;
        private var pools:Object;
        private var explosionSoundCount:int = 4;

        public function MonsterController(view:*)
        {
            this.view = view;
            model = new MonsterModel();
            model.represent(View.represent(view));
            classNameCounts = {
                "Explosion": DataUtil.Length(model)
            };
            for (var g:int = 1; g < model.DataUtil.Length(gridClassNames); g++)
            {
                var className:String = model.gridClassNames[g];
                classNameCounts[className] = DataUtil.Length(model);
            }
            pools = Pool.construct(View.construct, classNameCounts);
            for (var c:int = 0; c < model.DataUtil.Length(cityNames); c++)
            {
                var name:String = model.cityNames[c];
                View.removeChild(view.spawnArea[name]);
            }
            View.initAnimation(view.win);
            View.initAnimation(view.lose);
            View.initAnimation(view.background);
        }

        public function select(event:*):void
        {
            if (model.result == -1)
            {

                View.gotoFrame(view.background,1);
                model.restart();
                return;
            }
            var target:* = View.currentTarget(event);
            var isExplosion:Boolean = model.select(View.getName(target));
            if (isExplosion)
            {
                var index:int = pools["Explosion"].index;
                var explosion:* = pools["Explosion"].next();
                var parent:* = View.getParent(target);
                View.addChild(parent, explosion, "explosion_" + index);
                View.setPosition(explosion, View.getPosition(target));
                View.start(explosion);
                var countingNumber:int = Math.floor(Math.random() * explosionSoundCount) + 1;
                View.playSound("explosion_0" + countingNumber);
            }
        }

        private function updateText(result:int):void
        {
            View.setText(view.countText, model.selectCount.toString());
            View.setText(view.levelText, model.level.toString());
            var text:String;
            if (result == 1) 
            {
                text = "YOU WIN!  You obliterated all humans ... for now.";
            }
            else if (result == -1)
            {
                text = "Humans domesticated all the forests.";
            }
            else
            {
                text = "Mother Nature:\nDraw to destroy humans!\nDo not draw on forests.";
            }
            View.setText(view.text, text);
        }

        internal function update(deltaSeconds:Number):void
        {
            model.update(deltaSeconds);
            if (1 === model.resultNow)
            {
                View.start(view.win);
            }
            else if (-1 === model.resultNow)
            {
                View.start(view.lose);
                View.start(view.background);
            }
            Controller.visit(view, model.changes, create);
            updateText(model.result);
        }
       
        function randomRange(minNum:Number, maxNum:Number):Number
        {
            return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
        }

        /**
         * Would be more flexible to add child to whichever parent.
         */
        internal function create(child:*, key:String, change:*):Object
        {
            if (child)
            {
            }
            else
            {
                if (Controller.isObject(change) && !isNaN(change.x))
                {
                    for (var g:int = 1; g < DataUtil.Length(model.gridClassNames); g++)
                    {
                        var className:String = model.gridClassNames[g];
                        if (key.indexOf(className) === 0)
                        {
                            child = pools[className].next();
                            View.gotoFrame(child, randomRange(1, child.totalFrames));
                            var parent = view.spawnArea;
                            View.addChild(parent, child, key);
                            View.listenToOverAndDown(child, "select", this);
                        }
                    }
                }
            }
            return child;
        }
    }
}
