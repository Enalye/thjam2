module th.yinyang;

import grimoire;

import th.enemy;
import th.entity;
import th.player;
import th.grid;
import th.input;
import th.shot;
import th.sound;

class YinYang: Enemy {
	this(Vec2i gridPosition, Direction direction) {
		super(gridPosition, "yinyang", Vec2f.one * 0.5f);
		_direction = direction;
		_resetDirectionAuto = false;
        showLifebar = false;
	}

	override void action() {
		if(isMovement(_direction) && checkDirectionValid(_direction)) {
			if(isOpponent(type, getNextTileType(_direction))) {
				bounce();
			} else if(checkDirectionValid(_direction)) {
				moveOnGrid();
			}
		} else {
			bounce();
		}
	}

	override void handleCollision(Shot shot) {
		_direction = moveFromFireDirection(shot.direction);
	}

	void bounce() {
		Vec2i nextTileGridPosition = getUpdatedPosition(_direction);
		foreach(Entity enemy; enemies) {
			if(enemy.gridPosition == nextTileGridPosition) {
				enemy.receiveDamage();
			}
		}

		if(player.gridPosition == nextTileGridPosition) {
			player.receiveDamage();
		}

		_direction = getOppositeDirection(_direction);
		if(checkDirectionValid(_direction)) {
			moveOnGrid();
            playSound(SoundType.Bounce);
		}
	}
}