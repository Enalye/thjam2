import std.stdio;

import grimoire;

import derelict.sdl2.sdl;

class Input{

	this(){
		init();
	}
	void init(){
		bindKey("up",SDL_SCANCODE_UP);
		bindKey("down",SDL_SCANCODE_DOWN);
		bindKey("left",SDL_SCANCODE_LEFT);
		bindKey("right",SDL_SCANCODE_RIGHT);
		bindKey("fireUp",SDL_SCANCODE_W);
		bindKey("fireDown",SDL_SCANCODE_S);
		bindKey("fireLeft",SDL_SCANCODE_A);
		bindKey("fireRight",SDL_SCANCODE_D);
	}
	
	string getKeyPressed(){
		if (getKeyDown("up")){
			return "up";
		}
		else if (getKeyDown("down")){
			return "down";
		}
		else if (getKeyDown("left")){
			return "left";
		}
		else if (getKeyDown("right")){
			return "right";
		}
		else if (getKeyDown("fireUp")){
			return "fireUp";
		}
		else if (getKeyDown("fireDown")){
			return "fireDown";
		}
		else if (getKeyDown("fireLeft")){
			return "fireLeft";
		}
		else if (getKeyDown("fireRight")){
			return "fireRight";
		}
		return null;
	}
}