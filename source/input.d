module th.input;

import std.stdio;

import grimoire;

import derelict.sdl2.sdl;

enum Direction { NONE, UP, DOWN, LEFT, RIGHT, FIRE_UP, FIRE_DOWN, FIRE_LEFT, FIRE_RIGHT }

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


Vec2f vectorFromFireDirection(Direction direction) {
	Vec2f vector = Vec2f.zero;

	if(direction == Direction.FIRE_UP) {
		vector = Vec2f(0, -1);
	}

	if(direction == Direction.FIRE_DOWN) {
		vector = Vec2f(0, 1);
	}

	if(direction == Direction.FIRE_LEFT) {
		vector = Vec2f(-1, 0);
	}

	if(direction == Direction.FIRE_RIGHT) {
		vector = Vec2f(1, 0);
	}

	return vector;
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
		}

		return Direction.NONE;
	}
}