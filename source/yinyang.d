module th.yinyang;

import grimoire;

import th.grid;
import th.input;
import th.item;

class YinYang: Item {
	private {
		Direction _direction;
	}

	this(Vec2i gridPosition, Direction direction) {
		super(gridPosition, ItemType.YINYANG);
		type = Type.Enemy;
		_direction = direction;
		_resetDirectionAuto = false;
		_debug = true;
		_collectible = false;
	}

	override void action() {
		if(isMovement(_direction) && checkDirectionValid(_direction)) {
			moveOnGrid();
		} else {
			_direction = getOppositeDirection(_direction);
		}
	}
}