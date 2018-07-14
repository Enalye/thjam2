module th.input;

import std.stdio;

import grimoire;

import derelict.sdl2.sdl;

enum Direction { NONE, UP, DOWN, LEFT, RIGHT, FIRE_UP, FIRE_DOWN, FIRE_LEFT, FIRE_RIGHT, SPACE }

bool isMovement(Direction direction) {
	return direction == Direction.UP ||
		direction == Direction.DOWN ||
		direction == Direction.LEFT ||
		direction == Direction.RIGHT;
}

bool isFire(Direction direction) {
	return direction == Direction.FIRE_UP ||
		direction == Direction.FIRE_DOWN ||
		direction == Direction.FIRE_LEFT ||
		direction == Direction.FIRE_RIGHT;
}

Direction getOppositeDirection(Direction direction) {
	Direction oppositeDirection;
	switch(direction) {
		case Direction.UP:
		oppositeDirection = Direction.DOWN;
		break;
		case Direction.DOWN:
		oppositeDirection = Direction.UP;
		break;
		case Direction.LEFT:
		oppositeDirection = Direction.RIGHT;
		break;
		case Direction.RIGHT:
		oppositeDirection = Direction.LEFT;
		break;
		case Direction.FIRE_UP:
		oppositeDirection = Direction.FIRE_DOWN;
		break;
		case Direction.FIRE_DOWN:
		oppositeDirection = Direction.FIRE_UP;
		break;
		case Direction.FIRE_LEFT:
		oppositeDirection = Direction.FIRE_RIGHT;
		break;
		case Direction.FIRE_RIGHT:
		oppositeDirection = Direction.FIRE_LEFT;
		break;
		default:
		oppositeDirection = Direction.NONE;
		break;
	}

	return oppositeDirection;
}


Vec2i vectorFromMovementDirection(Direction direction) {
	Vec2i vector = Vec2i.zero;

	if(direction == Direction.UP) {
		vector = Vec2i(0, -1);
	}

	if(direction == Direction.DOWN) {
		vector = Vec2i(0, 1);
	}

	if(direction == Direction.LEFT) {
		vector = Vec2i(-1, 0);
	}

	if(direction == Direction.RIGHT) {
		vector = Vec2i(1, 0);
	}

	return vector;
}


float angleFromFireDirection(Direction direction) {
	float angle = 0;

	if(direction == Direction.FIRE_UP) {
		angle = -90;
	}

	if(direction == Direction.FIRE_DOWN) {
		angle = 90;
	}

	if(direction == Direction.FIRE_LEFT) {
		angle = 180;
	}

	if(direction == Direction.FIRE_RIGHT) {
		angle = 0;
	}

	return angle;
}

class InputManager {
	this() {
		init();
	}

	void init(){
		bindKey("up", SDL_SCANCODE_UP);
		bindKey("down", SDL_SCANCODE_DOWN);
		bindKey("left", SDL_SCANCODE_LEFT);
		bindKey("right", SDL_SCANCODE_RIGHT);
		bindKey("fireUp", SDL_SCANCODE_W);
		bindKey("fireDown", SDL_SCANCODE_S);
		bindKey("fireLeft", SDL_SCANCODE_A);
		bindKey("fireRight", SDL_SCANCODE_D);
		bindKey("space", SDL_SCANCODE_SPACE);
	}
	
	Direction getKeyPressed() {
		if (getKeyDown("up")) {
			return Direction.UP;
		}
		else if (getKeyDown("down")) {
			return Direction.DOWN;
		}
		else if (getKeyDown("left")) {
			return Direction.LEFT;
		}
		else if (getKeyDown("right")) {
			return Direction.RIGHT;
		}
		else if (getKeyDown("fireUp")) {
			return Direction.FIRE_UP;
		}
		else if (getKeyDown("fireDown")) {
			return Direction.FIRE_DOWN;
		}
		else if (getKeyDown("fireLeft")) {
			return Direction.FIRE_LEFT;
		}
		else if (getKeyDown("fireRight")) {
			return Direction.FIRE_RIGHT;
		} else if (getKeyDown("space")) {
			return Direction.SPACE;
		}

		return Direction.NONE;
	}
}