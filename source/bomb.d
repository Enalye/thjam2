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
	Timer _timer;

	this(Vec2i gridPosition) {
		super(gridPosition);
		type = Type.Enemy;
		scale = Vec2f(4f, 2f);

		_particleSource = new ParticleSource();
		_particleSource.sprite = fetch!Sprite("starParticle");
		_particleSource.sprite.blend = Blend.AdditiveBlending;
		_particleSource.sprite.scale = Vec2f.one * 0.1f;
		_timer.start(3f);
	}

	override void update(float deltaTime) {
		for(int i = -2; i < 3; ++i) {
			Vec2i explosionPos = Vec2i(gridPosition.x + i, gridPosition.y);

			if(currentGrid.grid[explosionPos.x][explosionPos.y] != Type.None) {
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

		Particle particle_left = new Particle;
		particle_left.position.x = uniform!"[]"(position.x - 0.05, position.x + 0.05);
		particle_left.position.y = uniform!"[]"(position.y - 5, position.x + 5);
		particle_left.velocity.x = uniform!"[]"(-3f, -2f);
		particle_left.velocity.y = 0;
		particle_left.timeToLive = uniform!"[]"(0.2f, 0.5f);
		particle_left.scale = uniform!"[]"(3f, 4f);
		particle_left.color = Color(1f, 1f - _timer.time(), 1f - _timer.time());

		Particle particle_right = particle_left;
		particle_left.velocity.x = uniform!"[]"(2f, 3f);

		_particleSource.particles.push(particle_left);
		_particleSource.particles.push(particle_right);
		_particleSource.update(deltaTime);
	}

	override void draw(bool inhibitDraw = false) {
		_particleSource.draw();
	}

	override void handleCollision(int damage = 1) { }
}