using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using /*<com>*/Finegamedesign.Utils/*<DataUtil>*/;
namespace Monster
{
    /**
     * Portable.  Independent of platform.
     */
    public class MonsterModel
    {
        internal ArrayList cityNames;
        internal int level = 1;
        internal int length;
        internal Dictionary<string, dynamic> changes;
        internal int population;
        internal int health;
        internal Dictionary<string, dynamic> represents;
        internal int result = 0;
        internal int resultNow = 0;
        internal int selectCount = 0;
        internal int selected = 0;
        internal ArrayList gridClassNames = new ArrayList(){
            null, "City", "Forest"}
        ;
        
        private int vacancy;
        private int cellWidth;
        private int cellHeight;
        private int width;
        private int height;
        private int widthInCells;
        private int heightInCells;
        private float period = 2.0f;
        private float accumulated = 0.0f;
        
        private ArrayList grid = new ArrayList(){
        }
        ;
        private ArrayList gridPreviously = new ArrayList(){
        }
        ;
        
        public MonsterModel()
        {
        }
        
        internal void Restart()
        {
            resultNow = 0;
            result = 0;
            periodBase = 120.0f;
            period = 2.0f;
            level = 1;
            selectCount = 0;
            ClearGrid(2);
            RandomlyPlace(grid);
        }
        
        private void InitGrid(ArrayList grid, int cellWidth, int cellHeight)
        {
            this.cellWidth = Mathf.Ceil(cellWidth);
            float isometricHeightMultiplier = 0.5f;
            // 0.5;
            // 1.0;
            cellHeight = Mathf.Ceil(cellHeight * isometricHeightMultiplier);
            this.cellHeight = cellHeight;
            widthInCells = Mathf.Floor(width / cellWidth);
            heightInCells = Mathf.Floor(height / cellHeight);
            ClearGrid(0);
            gridPreviously = DataUtil.CloneList(grid);
        }
        
        private ArrayList ToGrid(Dictionary<string, dynamic> represents, ArrayList cityNames)
        {
            width = Mathf.Ceil(represents.spawnArea.width);
            height = Mathf.Ceil(represents.spawnArea.height);
            for (int c = 0; c < DataUtil.Length(cityNames); c++)
            {
                string name = cityNames[c];
                var child = represents.spawnArea[name];
                if (0 == DataUtil.Length(grid)) {
                    InitGrid(grid, child.width, child.height);
                }
                int column = Mathf.Floor(child.x / cellWidth);
                int row = Mathf.Floor(child.y / cellHeight);
                grid[row * widthInCells + column] = 1;
            }
            length = DataUtil.Length(grid);
            // trace(grid);
            return grid;
        }
        
        internal void Represent(Dictionary<string, dynamic> represents)
        {
            this.represents = represents;
            cityNames = Model.Keys(represents.spawnArea, "city");
            grid = ToGrid(represents, cityNames);
            Restart();
            if (Count(grid, 1) <= 0)
            {
                RandomlyPlace(grid);
            }
        }
        
        /**
         *
        Torri expects isometric grid.
        Represent grid with offsets:
        Expand:  Neighbor is up and down, up-left and down-left (if even), up-right, down-right (if odd).
        Layout each odd indexed row with an offset right.
        2 2 2
        1 1 3
        2 0 2
        1 1 3
         */
        private void ExpandIsometric(ArrayList grid, int row, int column, ArrayList gridNext)
        {
            int index = (row) * widthInCells + column;
            int cell = grid[index];
            if (1 == cell)
            {
                int offset = row % 2;
                int columnOffset = offset == 0 ? -1 : 1;
                if (0 < row)
                {
                    int up = (row-1) * widthInCells + column;
                    if (0 <= up)
                    {
                        gridNext[up] = 1;
                        if (0 <= column + columnOffset)
                        {
                            gridNext[up + columnOffset] = 1;
                        }
                    }
                }
                if (row < heightInCells - 1)
                {
                    int down = (row+1) * widthInCells + column;
                    if (down < length)
                    {
                        gridNext[down] = 1;
                        if (column + columnOffset < widthInCells - 1)
                        {
                            gridNext[down + columnOffset] = 1;
                        }
                    }
                }
            }
        }
        
        private void ExpandTopDown(ArrayList grid, int row, int column, ArrayList gridNext)
        {
            int index = (row) * widthInCells + column;
            int cell = grid[index];
            if (1 == cell)
            {
                if (0 < row)
                {
                    gridNext[(row-1) * widthInCells + column] = 1;
                }
                if (0 < column)
                {
                    gridNext[(row) * widthInCells + column - 1] = 1;
                }
                if (row < heightInCells - 1)
                {
                    gridNext[(row+1) * widthInCells + column] = 1;
                }
                if (column < widthInCells - 1)
                {
                    gridNext[(row) * widthInCells + column + 1] = 1;
                }
            }
        }
        
        private ArrayList Grow(ArrayList grid)
        {
            // trace("grow:   " + grid);
            ArrayList gridNext = DataUtil.CloneList(grid);
            for (int row = 0; row < heightInCells; row++)
            {
                for (int column = 0; column < widthInCells; column++)
                {
                    ExpandIsometric(grid, row, column, gridNext);
                }
            }
            return gridNext;
        }
        
        private float OffsetWidth(int row)
        {
            return (row % 2) * cellWidth * 0.5f;
        }
        
        private Dictionary<string, dynamic> Change(ArrayList gridPreviously, ArrayList grid)
        {
            Dictionary<string, dynamic> changes = new Dictionary<string, dynamic>(){
            }
            ;
            int count = 0;
            for (int row = 0; row < heightInCells; row++)
            {
                for (int column = 0; column < widthInCells; column++)
                {
                    int index = row * widthInCells + column;
                    if (grid[index] != gridPreviously[index]) {
                        if (null == changes.spawnArea)
                        {
                            changes.spawnArea = new Dictionary<string, dynamic>(){
                            }
                            ;
                        }
                        for (int g = 1; g < DataUtil.Length(gridClassNames); g++)
                        {
                            string className = gridClassNames[g];
                            bool isChanged = g == grid[index] || g == gridPreviously[index];
                            if (isChanged)
                            {
                                string name = className + "_" + row + "_" + column;
                                count++;
                                if (g == grid[index])
                                {
                                    changes.spawnArea[name] = new Dictionary<string, dynamic>(){
                                        {
                                            "x", cellWidth * column + cellWidth * 0.5f + OffsetWidth(row)}
                                        ,
                                        {
                                            "y", cellHeight * row + cellHeight * 0.5f}
                                        ,
                                        {
                                            "visible", true}
                                    }
                                    ;
                                }
                                else
                                {
                                    changes.spawnArea[name] = new Dictionary<string, dynamic>(){
                                        {
                                            "visible", false}
                                    }
                                    ;
                                }
                            }
                        }
                    }
                }
            }
            return changes;
        }
        
        internal void Update(float deltaSeconds)
        {
            accumulated += deltaSeconds;
            population = Count(grid, 1);
            health = Count(grid, 2);
            vacancy = DataUtil.Length(grid) - population;
            Win();
            if (period <= accumulated)
            {
                accumulated = 0;
                if (1 <= selectCount)
                {
                    grid = Grow(grid);
                    if (population <= 2)
                    {
                        if (population <= 0)
                        {
                            level++;
                        }
                        RandomlyPlace(grid);
                    }
                }
                period = UpdatePeriod(population, vacancy);
            }
            changes = Change(gridPreviously, grid);
            cityNames = Model.Keys(changes.spawnArea, "city");
            gridPreviously = DataUtil.CloneList(grid);
        }
        
        private int Count(ArrayList counts, int value)
        {
            int sum = 0;
            for (int c = 0; c < DataUtil.Length(counts); c++)
            {
                if (object.ReferenceEquals(value, counts[c]))
                {
                    sum += 1;
                }
            }
            return sum;
        }
        
        private float startingPlaces = 2;
        // 2;
        
        /**
         * Slow to keep trying if there were lot of starting places, but there aren't.
         */
        private void RandomlyPlace(ArrayList grid)
        {
            int attemptMax = 128;
            for (int attempt = 0; Count(grid, 1) < startingPlaces && attempt < attemptMax; attempt++)
            {
                int index = Mathf.Floor((Random.value % 1.0f) * (DataUtil.Length(grid) - 4)) + 2;
                grid[index] = 1;
            }
            // startingPlaces += 0.125;
            // 0.25;
        }
        
        // 120.0;
        // 90.0;
        // 80.0;
        // 60.0;
        // 40.0;
        // 20.0;
        private float periodBase = 120.0f;
        
        private float UpdatePeriod(int population, int vacancy)
        {
            float period = 999999.0f;
            if (population <= 0)
            {
                periodBase = Mathf.Max(3, periodBase * 0.95f);
                period = 2.0f + 3.0f / level;
                accumulated = 0;
                // periodBase * 0.05;
            }
            else if (1 <= vacancy)
            {
                float ratio = Mathf.Pow(population, 0.325f) / DataUtil.Length(grid);
                float exponent = 1.0f;
                // 0.75;
                // 0.25;
                // 1.0;
                // 0.25;
                float power = Mathf.Pow(ratio, exponent);
                period = power * periodBase;
            }
            return period;
        }
        
        private int Win()
        {
            resultNow = result == 0 ? 0 : result;
            if (vacancy <= 0 || health <= 0)
            {
                result = -1;
            }
            else if (population <= 0)
            {
                result = 1;
            }
            else
            {
                result = 0;
            }
            resultNow = resultNow == 0 ? result : 0;
            return resultNow;
        }
        
        internal bool Select(string name)
        {
            ArrayList parts = DataUtil.Split(name, "_");
            int row = int.Parse(parts[1]);
            int column = int.Parse(parts[2]);
            int result = SelectCell(row, column);
            population = Count(grid, 1);
            bool isExplosion = object.ReferenceEquals(1, result);
            if (isExplosion && 0 <= population)
            {
                vacancy = DataUtil.Length(grid) - population;
                period = UpdatePeriod(population, vacancy);
            }
            return isExplosion;
        }
        
        internal int SelectCell(int row, int column)
        {
            int index = row * widthInCells + column;
            int was = grid[index];
            if (!object.ReferenceEquals(0, was))
            {
                if (1 == was)
                {
                    selectCount++;
                }
                grid[index] = 0;
            }
            // trace("select: " + grid);
            return was;
        }
        
        internal void ClearGrid(int value)
        {
            DataUtil.Clear(grid);
            for (int row = 0; row < heightInCells; row++)
            {
                for (int column = 0; column < widthInCells; column++)
                {
                    grid.Add(value);
                }
            }
        }
    }
}