module th.bomb;

import grimoire;

import th.entity;
import th.enemy;
import th.item;
import th.grid;
import th.input;

class Bomb: Enemy {
	Sprite[3] _sprites;
	int timer;

	this(Vec2i gridPosition) {
		_sprites[0] = fetch!Sprite("bomb_1");
		_sprites[1] = fetch!Sprite("bomb_2");
		_sprites[2] = fetch!Sprite("bomb_3");
		super(gridPosition);
		_sprite = _sprites[2];
		scale = Vec2f.one;
		timer = 2;
		_debug = true;
	}

	override void update(float deltaTime) {
		if(dead) {
			writeln("BOOOOOOOOOOOOM!");
		}
	}

	override void action() {
		writeln("action bomb");
		timer--;
		_sprite = _sprites[timer];

		if(timer < 0) {
			_life = 0;
		}
	}
}