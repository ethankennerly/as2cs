package monster
{
    import com.finegamedesign.utils.DataUtil;
    /**
     * Portable.  Independent of platform.
     */
    public class MonsterModel
    {
        internal var cityNames:Array;
        internal var level:int = 1;
        internal var length:int;
        internal var changes:Object;
        internal var population:int;
        internal var health:int;
        internal var represents:Object;
        internal var result:int = 0;
        internal var resultNow:int = 0;
        internal var selectCount:int = 0;
        internal var selected:int = 0;
        internal var gridClassNames:Array = [null, "City", "Forest"];

        private var vacancy:int;
        private var cellWidth:int;
        private var cellHeight:int;
        private var width:int;
        private var height:int;
        private var widthInCells:int;
        private var heightInCells:int;
        private var period:Number = 2.0;
        private var accumulated:Number = 0.0;

        private var grid:Array = [];
        private var gridPreviously:Array = [];

        public function MonsterModel()
        {
        }

        internal function restart():void
        {
            resultNow = 0;
            result = 0;
            periodBase = 120.0;
            period = 2.0;
            level = 1;
            selectCount = 0;
            clearGrid(2);
            randomlyPlace(grid);
        }

        private function initGrid(grid:Array, cellWidth:int, cellHeight:int):void
        {
            this.cellWidth = Math.ceil(cellWidth);
            var isometricHeightMultiplier:Number = 0.5;
            // 0.5;
            // 1.0; 
            cellHeight = Math.ceil(cellHeight * isometricHeightMultiplier);
            this.cellHeight = cellHeight;
            widthInCells = Math.floor(width / cellWidth);
            heightInCells = Math.floor(height / cellHeight);
            clearGrid(0);
            gridPreviously = DataUtil.CloneList(grid);
        }

        private function toGrid(represents:Object, cityNames:Array):Array
        {
            width = Math.ceil(represents.spawnArea.width);
            height = Math.ceil(represents.spawnArea.height);
            for (var c:int = 0; c < DataUtil.Length(cityNames); c++)
            {
                var name:String = cityNames[c];
                var child:* = represents.spawnArea[name];
                if (0 == DataUtil.Length(grid)) {
                    initGrid(grid, child.width, child.height);
                }
                var column:int = Math.floor(child.x / cellWidth);
                var row:int = Math.floor(child.y / cellHeight);
                grid[row * widthInCells + column] = 1;
            }
            length = DataUtil.Length(grid);
            // trace(grid);
            return grid;
        }

        internal function represent(represents:Object):void
        {
            this.represents = represents;
            cityNames = Model.keys(represents.spawnArea, "city");
            grid = toGrid(represents, cityNames);
            restart();
            if (count(grid, 1) <= 0)
            {
                randomlyPlace(grid);
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
        private function expandIsometric(grid:Array, row:int, column:int, gridNext:Array):void
        {
            var index:int = (row) * widthInCells + column;
            var cell:int = grid[index];
            if (1 == cell)
            {
                var offset:int = row % 2;
                var columnOffset:int = offset == 0 ? -1 : 1;
                if (0 < row)
                {
                    var up:int = (row-1) * widthInCells + column;
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
                    var down:int = (row+1) * widthInCells + column;
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

        private function expandTopDown(grid:Array, row:int, column:int, gridNext:Array):void
        {
            var index:int = (row) * widthInCells + column;
            var cell:int = grid[index];
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

        private function grow(grid:Array):Array
        {
            // trace("grow:   " + grid);
            var gridNext:Array = DataUtil.CloneList(grid);
            for (var row:int = 0; row < heightInCells; row++)
            {
                for (var column:int = 0; column < widthInCells; column++)
                {
                    expandIsometric(grid, row, column, gridNext);
                }
            }
            return gridNext;
        }

        private function offsetWidth(row:int):Number
        {
            return (row % 2) * cellWidth * 0.5;
        }

        private function change(gridPreviously:Array, grid:Array):Object
        {
            var changes:Object = {};
            var count:int = 0;
            for (var row:int = 0; row < heightInCells; row++)
            {
                for (var column:int = 0; column < widthInCells; column++)
                {
                    var index:int = row * widthInCells + column;
                    if (grid[index] != gridPreviously[index]) {
                        if (null == changes.spawnArea)
                        {
                            changes.spawnArea = {};
                        }
                        for (var g:int = 1; g < DataUtil.Length(gridClassNames); g++)
                        {
                            var className:String = gridClassNames[g];
                            var isChanged:Boolean = g == grid[index] || g == gridPreviously[index];
                            if (isChanged)
                            {
                                var name:String = className + "_" + row + "_" + column;
                                count++;
                                if (g == grid[index]) 
                                {
                                    changes.spawnArea[name] = {
                                        x: cellWidth * column + cellWidth * 0.5 + offsetWidth(row),
                                        y: cellHeight * row + cellHeight * 0.5,
                                        visible: true};
                                }
                                else
                                {
                                    changes.spawnArea[name] = {visible: false};
                                }
                            }
                        }
                    }
                }
            }
            return changes;
        }

        internal function update(deltaSeconds:Number):void
        {
            accumulated += deltaSeconds;
            population = count(grid, 1);
            health = count(grid, 2);
            vacancy = DataUtil.Length(grid) - population;
            win();
            if (period <= accumulated) 
            {
                accumulated = 0;
                if (1 <= selectCount)
                {
                    grid = grow(grid);
                    if (population <= 2) 
                    {
                        if (population <= 0)
                        {
                            level++;
                        }
                        randomlyPlace(grid);
                    }
                }
                period = updatePeriod(population, vacancy);
            }
            changes = change(gridPreviously, grid);
            cityNames = Model.keys(changes.spawnArea, "city");
            gridPreviously = DataUtil.CloneList(grid);
        }

        private function count(counts:Array, value:int):int
        {
            var sum:int = 0;
            for (var c:int = 0; c < DataUtil.Length(counts); c++)
            {
                if (value === counts[c])
                {
                    sum += 1;
                }
            }
            return sum;
        }

        private var startingPlaces:Number = 2; 
        // 2;

        /**
         * Slow to keep trying if there were lot of starting places, but there aren't.
         */
        private function randomlyPlace(grid:Array):void
        {
            var attemptMax:int = 128;
            for (var attempt:int = 0; count(grid, 1) < startingPlaces && attempt < attemptMax; attempt++)
            {
                var index:int = Math.floor(Math.random() * (DataUtil.Length(grid) - 4)) + 2;
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
        private var periodBase:Number = 120.0;

        private function updatePeriod(population:int, vacancy:int):Number
        {
            var period:Number = 999999.0;
            if (population <= 0)
            {
                periodBase = Math.max(3, periodBase * 0.95);
                period = 2.0 + 3.0 / level;
                accumulated = 0;
                // periodBase * 0.05;
            }
            else if (1 <= vacancy)
            {
                var ratio:Number = Math.pow(population, 0.325) / DataUtil.Length(grid);
                var exponent:Number = 1.0;
                // 0.75;
                // 0.25;
                // 1.0;
                // 0.25;
                var power:Number = Math.pow(ratio, exponent);
                period = power * periodBase;
            }
            return period;
        }

        private function win():int
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

        internal function select(name:String):Boolean
        {
            var parts:Array = DataUtil.Split(name, "_");
            var row:int = parseInt(parts[1]);
            var column:int = parseInt(parts[2]);
            var result:int = selectCell(row, column);
            population = count(grid, 1);
            var isExplosion:Boolean = 1 === result;
            if (isExplosion && 0 <= population)
            {
                vacancy = DataUtil.Length(grid) - population;
                period = updatePeriod(population, vacancy);
            }
            return isExplosion;
        }

        internal function selectCell(row:int, column:int):int
        {
            var index:int = row * widthInCells + column;
            var was:int = grid[index];
            if (0 !== was)
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

        internal function clearGrid(value:int):void
        {
            DataUtil.Clear(grid);
            for (var row:int = 0; row < heightInCells; row++)
            {
                for (var column:int = 0; column < widthInCells; column++)
                {
                    grid.push(value);
                }
            }
        }
    }
}
