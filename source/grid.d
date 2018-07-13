module th.grid;

import grimoire;
import std.stdio;

static float GRID_RATIO = 64f;

enum Type { None, OutOfGrid, Player, Enemy };

bool isRealInstance(Type type) {
	return type > Type.OutOfGrid;
}

bool isOpponent(Type type1, Type type2) {
	return (type1 == Type.Player) && (type2 == Type.Enemy) ||
		(type1 == Type.Enemy) && (type2 == Type.Player);
}

Vec2f getTileSize() {
    return Vec2f.one * GRID_RATIO;
}

Vec2f getGridSize() {
    return Vec2f(5f,7f) * getTileSize();
}

Vec2f getGridPosition(Vec2i gridPosition) {
    auto topLeft = centerScreen - (cast(Vec2f)_grid.widthAndHeight) * GRID_RATIO / 2f;
	return topLeft + (cast(Vec2f)gridPosition) * getTileSize();
}

private {
    Grid _grid;
}

Grid createGrid(Vec2u gridSize) {
    return _grid = new Grid(gridSize, centerScreen());
}

void destroyGrid() {
    _grid = null;
}

class Grid {
	Type[][] grid;
	Vec2u widthAndHeight; //width and height
	Vec2f position;
	Vec2f topLeft;

	this(Vec2u dimensions, Vec2f gridPos) {
		widthAndHeight = dimensions;
		grid = new Type[][](widthAndHeight.x, widthAndHeight.y);
		position = gridPos;
		
		topLeft = Vec2f(position.x - (widthAndHeight.x * GRID_RATIO) / 2,
			position.y - (widthAndHeight.y * GRID_RATIO) / 2);
	}

	Type at(Vec2u position) {
		if(position.x < widthAndHeight.x && position.y < widthAndHeight.y) {
			return grid[position.x][position.y];
		} else {
			return Type.OutOfGrid;
		}
	}

	void set(Type type, Vec2i position) {
		if(position.x < widthAndHeight.x && position.y < widthAndHeight.y) {
			grid[position.x][position.y] = type;
		} else {
			writeln("position ", position.x, ",", position.y, " is out of widthAndHeight ", widthAndHeight.x, ",", widthAndHeight.y);
			throw new Exception("Coordinate out of grid bounds!");
		}
	}

	void reset() {
		for(uint i = 0; i < widthAndHeight.x; ++i) {
			for(uint j = 0; j < widthAndHeight.y; ++j) {
				grid[i][j] = Type.None;
			}
		}
	}

	void draw() {
		for(uint i = 0; i < widthAndHeight.x; ++i) {
			for(uint j = 0; j < widthAndHeight.y; ++j) {
				drawRect(Vec2f(topLeft.x + i * GRID_RATIO, topLeft.y + j * GRID_RATIO), Vec2f.one * GRID_RATIO, Color.white);
			}
		}
	}
}