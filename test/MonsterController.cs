using UnityEngine;
using System.Collections.Generic;

using /*<com>*/Finegamedesign.Utils/*<DataUtil>*/;
namespace Monster
{
    /**
     * Portable.  Independent of platform.
     */
    public class MonsterController
    {
        private MonsterModel model;
        private /*<var>*/dynamic view;
        private Dictionary<string, dynamic> classNameCounts;
        private Dictionary<string, dynamic> pools;
        private int explosionSoundCount = 4;
        
        public MonsterController(/*<var>*/dynamic view)
        {
            this.view = view;
            model = new MonsterModel();
            //+ model.represent(View.represent(view));
            classNameCounts = new Dictionary<string, dynamic>(){
                {
                    "Explosion", model.Count}
            }
            ;
            for (int g = 1; g < DataUtil.Length(model.gridClassNames); g++)
            {
                string className = model.gridClassNames[g];
                classNameCounts[className] = model.Count;
            }
            pools = Pool.Construct(View.construct, classNameCounts);
            for (int c = 0; c < DataUtil.Length(model.cityNames); c++)
            {
                string name = model.cityNames[c];
                View.RemoveChild(view.spawnArea[name]);
            }
            View.InitAnimation(view.win);
            View.InitAnimation(view.lose);
            View.InitAnimation(view.background);
        }
        
        public void Select(/*<var>*/dynamic mouseEvent)
        {
            if (model.result == -1)
            {
                
                View.GotoFrame(view.background,1);
                model.Restart();
                return;
            }
            var target = View.CurrentTarget(mouseEvent);
            bool isExplosion = model.Select(View.GetName(target));
            if (isExplosion)
            {
                int index = pools["Explosion"].index;
                var pool = pools["Explosion"];
                var explosion = pool.Next();
                var parent = View.GetParent(target);
                View.AddChild(parent, explosion, "explosion_" + index);
                View.SetPosition(explosion, View.GetPosition(target));
                View.Start(explosion);
                int countingNumber = Mathf.Floor((Random.value % 1.0f) * explosionSoundCount) + 1;
                View.PlaySound("explosion_0" + countingNumber);
            }
        }
        
        private void UpdateText(int result)
        {
            View.SetText(view.countText, model.selectCount.ToString());
            View.SetText(view.levelText, model.level.ToString());
            string text;
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
            View.SetText(view.text, text);
        }
        
        internal void Update(float deltaSeconds)
        {
            model.Update(deltaSeconds);
            if (object.ReferenceEquals(1, model.resultNow))
            {
                View.Start(view.win);
            }
            else if (object.ReferenceEquals(-1, model.resultNow))
            {
                View.Start(view.lose);
                View.Start(view.background);
            }
            Controller.Visit(view, model.changes, create);
            UpdateText(model.result);
        }
        
        float RandomRange(float minNum, float maxNum)
        {
            return (Mathf.Floor((Random.value % 1.0f) * (maxNum - minNum + 1)) + minNum);
        }
        
        /**
         * Would be more flexible to add child to whichever parent.
         */
        internal Dictionary<string, dynamic> Create(/*<var>*/dynamic child, string key, /*<var>*/dynamic change)
        {
            if (child)
            {
            }
            else
            {
                if (Controller.IsObject(change) && !IsNaN(change.x))
                {
                    for (int g = 1; g < DataUtil.Length(model.gridClassNames); g++)
                    {
                        string className = model.gridClassNames[g];
                        if (object.ReferenceEquals(key.IndexOf(className), 0))
                        {
                            pool = pools[className];
                            child = pool.Next();
                            View.GotoFrame(child, RandomRange(1, child.totalFrames));
                            parent = view.spawnArea;
                            View.AddChild(parent, child, key);
                            View.ListenToOverAndDown(child, "select", this);
                        }
                    }
                }
            }
            return child;
        }
    }
}