module th.input;

import std.stdio;

import grimoire;

import derelict.sdl2.sdl;

enum { NONE, UP, DOWN, LEFT, RIGHT, FIRE_UP, FIRE_DOWN, FIRE_LEFT, FIRE_RIGHT }

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
			return UP;
		}
		else if (getKeyDown("down")) {
			return DOWN;
		}
		else if (getKeyDown("left")) {
			return LEFT;
		}
		else if (getKeyDown("right")) {
			return RIGHT;
		}
		else if (getKeyDown("fireUp")) {
			return FIRE_UP;
		}
		else if (getKeyDown("fireDown")) {
			return FIRE_DOWN;
		}
		else if (getKeyDown("fireLeft")) {
			return FIRE_LEFT;
		}
		else if (getKeyDown("fireRight")) {
			return FIRE_RIGHT;
		}

		return NONE;
	}
}