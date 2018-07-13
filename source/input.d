module th.input;

import std.stdio;

import grimoire;

import derelict.sdl2.sdl;

enum Direction { NONE, UP, DOWN, LEFT, RIGHT, FIRE_UP, FIRE_DOWN, FIRE_LEFT, FIRE_RIGHT }

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
	
	enum getKeyPressed() {
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