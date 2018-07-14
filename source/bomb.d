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
	MixScaleFilterRect _particleFilter;
	Timer _timer; Vec2f _size;

	bool _debug = false;

	this(Vec2i gridPosition) {
		super(gridPosition);
		type = Type.Enemy;
		scale = Vec2f(4f, 2f);
		_size = Vec2f(5 * GRID_RATIO, GRID_RATIO);

		_particleSource = new ParticleSource();
		_particleSource.sprite = fetch!Sprite("starParticle");
		_particleSource.sprite.blend = Blend.AdditiveBlending;
        _particleSource.spawnDelay = 9999999f;

		_particleFilter = new MixScaleFilterRect();
		_particleFilter.position = position;
		_particleFilter.property(0, _size.x);
		_particleFilter.property(1, _size.y);
		_particleFilter.property(2, 0);
		_particleFilter.property(3, 0.04f);

		_timer.start(1f);
		_debug = true;
	}

	override void update(float deltaTime) {
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
			particle_left.timeToLive = 1f * 60f;
			particle_left.scale = 0.5f;
			particle_left.color = Color.white;
            particle_left.time = 0f;

			Particle particle_right = new Particle;
			particle_right.position.x = uniform!"[]"(position.x - 0.05, position.x + 0.05);
			particle_right.position.y = uniform!"[]"(position.y - 5, position.y + 5);
			particle_right.velocity.x = uniform!"[]"(5f, 6f);
			particle_right.velocity.y = 0;
			particle_right.timeToLive = 1f * 60f;
			particle_right.scale = 0.5f;
			particle_right.color = Color.white;
            particle_right.time = 0f;

			_particleSource.particles.push(particle_left);
			_particleSource.particles.push(particle_right);
			_debug = false;
		}

		foreach(Particle particle; _particleSource.particles) {
			_particleFilter.apply(particle, deltaTime);
		}

		_particleSource.update(deltaTime);
	}

	override void draw(bool inhibitDraw = false) {
		_particleSource.draw();

		if(_debug) {
			drawRect(position - _size / 2, _size, Color.white);
		}
	}

	override void handleCollision(int damage = 1) { }
}