module th.bomb;

import grimoire;

import th.entity;
import th.enemy;
import th.item;
import th.grid;
import th.input;
import th.player;

import std.algorithm.comparison;
import std.random;

alias IndexedArray!(Timer, 5000u) TimersArray;

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
			enemies.push(new Explosion(_gridPosition));
		}
	}

	override void action() {
		timer = min(0, timer - 1);

		if(timer < 0) {
			_life = 0;
		}
	}

	override void draw(bool inhibitDraw = false) {
		if(isAlive) {
			_sprite = _sprites[timer];
		}

		super.draw();
	}
}

class Explosion: Entity {
	ParticleSource _particleSource;

	MixScaleFilterRect _scaleDown;
	SetColorFilterRect _whiteToYellow;
	SetColorFilterRect _yellowToOrange;
	SetColorFilterRect _orangeToRed;

	Timer _timer; Vec2f _size;
	Vec2f _colorSize;

	bool _debug = false;

	this(Vec2i gridPosition) {
		super(gridPosition);
		type = Type.Enemy;
		scale = Vec2f(4f, 2f);

		_size = Vec2f(5 * GRID_RATIO, GRID_RATIO);
		_colorSize = Vec2f(0.5 * GRID_RATIO, GRID_RATIO);

		_particleSource = new ParticleSource();
		_particleSource.sprite = fetch!Sprite("starParticle");
		_particleSource.sprite.blend = Blend.AdditiveBlending;
        _particleSource.spawnDelay = 9999999f;

		_scaleDown = new MixScaleFilterRect();
		_scaleDown.position = position;
		_scaleDown.property(0, _size.x);
		_scaleDown.property(1, _size.y);
		_scaleDown.property(2, 0);
		_scaleDown.property(3, 0.06f);

		_whiteToYellow = new SetColorFilterRect();
		_whiteToYellow.position = position - Vec2f(0.7 * GRID_RATIO, 0);
		_whiteToYellow.property(0, _colorSize.x);
		_whiteToYellow.property(1, _colorSize.y);
		_whiteToYellow.property(2, 1);
		_whiteToYellow.property(3, 1);
		_whiteToYellow.property(4, 0);
		_whiteToYellow.property(5, 0.75);

		_yellowToOrange = new SetColorFilterRect();
		_yellowToOrange.position = position - Vec2f(1.4 * GRID_RATIO, 0);
		_yellowToOrange.property(0, _colorSize.x);
		_yellowToOrange.property(1, _colorSize.y);
		_yellowToOrange.property(2, 1);
		_yellowToOrange.property(3, 0.28);
		_yellowToOrange.property(4, 0);
		_yellowToOrange.property(5, 0.50);

		_orangeToRed = new SetColorFilterRect();
		_orangeToRed.position = position - Vec2f(2.1 * GRID_RATIO, 0);
		_orangeToRed.property(0, _colorSize.x);
		_orangeToRed.property(1, _colorSize.y);
		_orangeToRed.property(2, 1);
		_orangeToRed.property(3, 0);
		_orangeToRed.property(4, 0);
		_orangeToRed.property(5, 0.25);

		_timer.start(1f);
		_debug = true;
	}

	override void update(float deltaTime) {
		_timer.update(deltaTime);

		for(int i = -2; i < 3; ++i) {
			Vec2i explosionPos = Vec2i(gridPosition.x + i, gridPosition.y);

			if(currentGrid.at(explosionPos) != Type.None) {
				foreach(Entity enemy, uint index; enemies) {
					if(enemy.gridPosition == explosionPos) {
						enemy.handleCollision();
					}
				}

				if(player.gridPosition == explosionPos) {
					player.handleCollision();
				}
			}
		}

        _timer.update(deltaTime);
		if(_timer.isRunning()) {
			Particle particle_left = new Particle;
			particle_left.position.x = uniform!"[]"(position.x - 0.05, position.x + 0.05);
			particle_left.position.y = uniform!"[]"(position.y - 5, position.y + 5);
			particle_left.velocity.x = uniform!"[]"(-6f, -5f);
			particle_left.velocity.y = 0;
			particle_left.timeToLive = 2f;
			particle_left.scale = 0.5f;
			particle_left.color = Color.white;

			Particle particle_right = new Particle;
			particle_right.position.x = uniform!"[]"(position.x - 0.05, position.x + 0.05);
			particle_right.position.y = uniform!"[]"(position.y - 5, position.y + 5);
			particle_right.velocity.x = uniform!"[]"(5f, 6f);
			particle_right.velocity.y = 0;
			particle_right.timeToLive = 2f;
			particle_right.scale = 0.5f;
			particle_right.color = Color.white;

			_particleSource.particles.push(particle_left);
			_particleSource.particles.push(particle_right);
		}

		foreach(Particle particle; _particleSource.particles) {
			_scaleDown.apply(particle, deltaTime);
			_whiteToYellow.apply(particle, deltaTime);
			_yellowToOrange.apply(particle, deltaTime);
			//_orangeToRed.apply(particle, deltaTime);
		}

		_particleSource.update(deltaTime);
	}

	override void draw(bool inhibitDraw = false) {
		_particleSource.draw();

		if(_debug) {
			drawRect(position - _size / 2, _size, Color.white);
			drawRect(_whiteToYellow.position - _colorSize / 2, _colorSize, Color.yellow);
			drawRect(_yellowToOrange.position - _colorSize / 2, _colorSize, Color(1f, 0.64f, 0));
			drawRect(_orangeToRed.position - _colorSize / 2, _colorSize, Color.red);
		}
	}

	override void handleCollision(int damage = 1) { }
}