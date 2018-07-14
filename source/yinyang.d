module th.yinyang;

import grimoire;

import th.enemy;
import th.grid;
import th.input;

class YinYang: Enemy {
	this(Vec2i gridPosition, Direction direction) {
		super(gridPosition, "yinyang", Vec2f.one * 0.5f);
		_direction = direction;
		_resetDirectionAuto = false;
	}

	override void action() {
		if(isMovement(_direction) && checkDirectionValid(_direction)) {
			if(isOpponent(type, getNextTileType(_direction))) {
				bounce();
				//dmg player here???
			} else {
				moveOnGrid();
			}
		} else {
			bounce();
		}
	}

	override void handleCollision(int damage = 1) {
		bounce();
	}

	void bounce() {
		_direction = getOppositeDirection(_direction);
		moveOnGrid();
	}
}