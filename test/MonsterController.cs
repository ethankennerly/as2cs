using UnityEngine;
using System.Collections.Generic;

using com.finegamedesign.utils/*<DataUtil>*/;
/**
 * Portable.  Independent of platform.
 */
public class MonsterController
{
    private MonsterModel model;
    private dynamic view;
    private Dictionary<string, dynamic> classNameCounts;
    private Dictionary<string, dynamic> pools;
    private int explosionSoundCount = 4;
    
    public MonsterController(dynamic view)
    {
        this.view = view;
        model = new MonsterModel();
        model.represent(View.represent(view));
        classNameCounts = new Dictionary<string, dynamic>(){
            {
                "Explosion", DataUtil.Length(model)}
        }
        ;
        for (int g = 1; g < model.DataUtil.Length(gridClassNames); g++)
        {
            string className = model.gridClassNames[g];
            classNameCounts[className] = DataUtil.Length(model);
        }
        pools = Pool.construct(View.construct, classNameCounts);
        for (int c = 0; c < model.DataUtil.Length(cityNames); c++)
        {
            string name = model.cityNames[c];
            View.removeChild(view.spawnArea[name]);
        }
        View.initAnimation(view.win);
        View.initAnimation(view.lose);
        View.initAnimation(view.background);
    }
    
    public void select(dynamic event)
    {
        if (model.result == -1)
        {
            
            View.gotoFrame(view.background,1);
            model.restart();
            return;
        }
        dynamic target = View.currentTarget(event);
        bool isExplosion = model.select(View.getName(target));
        if (isExplosion)
        {
            int index = pools["Explosion"].index;
            dynamic explosion = pools["Explosion"].next();
            dynamic parent = View.getParent(target);
            View.addChild(parent, explosion, "explosion_" + index);
            View.setPosition(explosion, View.getPosition(target));
            View.start(explosion);
            int countingNumber = Mathf.Floor((Random.value % 1.0f) * explosionSoundCount) + 1;
            View.playSound("explosion_0" + countingNumber);
        }
    }
    
    private void updateText(int result)
    {
        View.setText(view.countText, model.selectCount.toString());
        View.setText(view.levelText, model.level.toString());
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
        View.setText(view.text, text);
    }
    
    internal void update(float deltaSeconds)
    {
        model.update(deltaSeconds);
        if (object.ReferenceEquals(1, model.resultNow))
        {
            View.start(view.win);
        }
        else if (object.ReferenceEquals(-1, model.resultNow))
        {
            View.start(view.lose);
            View.start(view.background);
        }
        Controller.visit(view, model.changes, create);
        updateText(model.result);
    }
    
    float randomRange(float minNum, float maxNum)
    {
        return (Mathf.Floor((Random.value % 1.0f) * (maxNum - minNum + 1)) + minNum);
    }
    
    /**
     * Would be more flexible to add child to whichever parent.
     */
    internal Dictionary<string, dynamic> create(dynamic child, string key, dynamic change)
    {
        if (child)
        {
        }
        else
        {
            if (Controller.isObject(change) && !isNaN(change.x))
            {
                for (int g = 1; g < DataUtil.Length(model.gridClassNames); g++)
                {
                    string className = model.gridClassNames[g];
                    if (object.ReferenceEquals(key.IndexOf(className), 0))
                    {
                        child = pools[className].next();
                        View.gotoFrame(child, randomRange(1, child.totalFrames));
                        parent = view.spawnArea;
                        View.addChild(parent, child, key);
                        View.listenToOverAndDown(child, "select", this);
                    }
                }
            }
        }
        return child;
    }
}