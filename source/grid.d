module th.grid;

import grimoire;
import std.stdio;

static float GRID_RATIO = 64f;

enum Type { None, OutOfGrid, Player, Enemy };

Grid currentGrid;

bool isRealInstance(Type type) {
	return type > Type.OutOfGrid;
}

bool isOpponent(Type type1, Type type2) {
	return (type1 == Type.Player) && (type2 == Type.Enemy) ||
		(type1 == Type.Enemy) && (type2 == Type.Player);
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

	Type at(Vec2i position) {
		if(position.x < widthAndHeight.x && position.y < widthAndHeight.y) {
			return grid[position.x][position.y];
		} else {
			return Type.OutOfGrid;
		}
	}

	void set(Type type, Vec2i position) {
		if(isPositionValid(position)) {
			grid[position.x][position.y] = type;
		} else {
			writeln("position ", position, " is out of widthAndHeight ", widthAndHeight);
			throw new Exception("Coordinate out of grid bounds!");
		}
	}

	bool isPositionValid(Vec2i position) {
		return position.x < widthAndHeight.x && position.y < widthAndHeight.y;
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

	Vec2f computeRealPosition(Vec2i gridPosition) {
		return Vec2f(gridPosition.x * GRID_RATIO, gridPosition.y * GRID_RATIO) + topLeft;
	}
}