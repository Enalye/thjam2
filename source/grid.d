module th.grid;

import grimoire;

enum Type { None, OutOfGrid, Player, Enemy };

bool isRealInstance(Type type) {
	return type > Type.OutOfGrid;
}

bool isOpponent(Type type1, Type type2) {
	return (type1 == Type.Player) && (type2 == Type.Enemy) ||
		(type1 == Type.Enemy) && (type2 == Type.Player);
}

class Grid {
	Type[][] _grid;
	Vec2u _scale; //width and height

	this(Vec2u scale) {
		_scale = scale;
		_grid = new Type[][](scale.x, scale.y);
	}

	Type at(Vec2u position) {
		if(position.x < _scale.x && position.y < _scale.y) {
			return _grid[position.x][position.y];
		} else {
			return Type.OutOfGrid;
		}
	}

	void set(Type type, Vec2u position) {
		_grid[position.x][position.y] = type;
	}

	void reset() {
		for(uint i = 0; i < _scale.x; ++i) {
			for(uint j = 0; j < _scale.y; ++j) {
				_grid[i][j] = Type.None;
			}
		}
	}
}