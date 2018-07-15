module th.bomb;

import grimoire;

import th.entity;
import th.enemy;
import th.item;
import th.grid;
import th.input;
import th.manualParticleSource;
import th.player;
import th.shot;
import th.sound;

import std.algorithm.comparison;
import std.random;

alias IndexedArray!(Timer, 5000u) TimersArray;

class Bomb: Enemy {
	private {
		Sprite[3] _sprites;
		int _timer;
	}

	this(Vec2i gridPosition) {
		_sprites[0] = fetch!Sprite("bomb_1");
		_sprites[1] = fetch!Sprite("bomb_2");
		_sprites[2] = fetch!Sprite("bomb_3");
		super(gridPosition);
		_sprite = _sprites[2];
		scale = Vec2f.one;
		_timer = 2;
		_debug = true;
	}

	override void update(float deltaTime) {
		if(dead) {  
            playSound(SoundType.Explosion);
			enemies.push(new Explosion(_gridPosition));
		}
	}

	override void action() {
		_timer = min(0, _timer - 1);

		if(_timer < 0) {
			_life = 0;
		}
	}

	override void draw(bool inhibitDraw = false) {
		if(isAlive) {
			_sprite = _sprites[_timer];
		}

		super.draw();
	}
}

class Explosion: Entity {
	ManualParticleSource _particleSource;

	MixScaleFilterRect _scaleDown;
	SetColorFilterRect _whiteToYellowLeft;
	SetColorFilterRect _yellowToOrangeLeft;
	SetColorFilterRect _orangeToRedLeft;
	SetColorFilterRect _whiteToYellowRight;
	SetColorFilterRect _yellowToOrangeRight;
	SetColorFilterRect _orangeToRedRight;

	Timer _timer, _timerBeforeDelete; Vec2f _size;
	Vec2f _colorSize;

	bool _debug = false;
	bool _deletionStarted = false;

	this(Vec2i gridPosition) {
		super(gridPosition);
		type = Type.Enemy;
		scale = Vec2f(4f, 2f);

		_size = Vec2f(5 * GRID_RATIO, GRID_RATIO);
		_colorSize = Vec2f(0.5 * GRID_RATIO, GRID_RATIO);

		_particleSource = new ManualParticleSource();
		_particleSource.sprite = fetch!Sprite("starParticle");
		_particleSource.sprite.blend = Blend.AdditiveBlending;

		_scaleDown = new MixScaleFilterRect();
		_scaleDown.position = position;
		_scaleDown.property(0, _size.x);
		_scaleDown.property(1, _size.y);
		_scaleDown.property(2, 0.15f);
		_scaleDown.property(3, 0.06f);

		_whiteToYellowLeft = new SetColorFilterRect();
		_whiteToYellowLeft.position = position - Vec2f(0.7 * GRID_RATIO, 0);
		_whiteToYellowLeft.property(0, _colorSize.x);
		_whiteToYellowLeft.property(1, _colorSize.y);
		_whiteToYellowLeft.property(2, 1);
		_whiteToYellowLeft.property(3, 1);
		_whiteToYellowLeft.property(4, 0);
		_whiteToYellowLeft.property(5, 0.75);

		_yellowToOrangeLeft = new SetColorFilterRect();
		_yellowToOrangeLeft.position = position - Vec2f(1.4 * GRID_RATIO, 0);
		_yellowToOrangeLeft.property(0, _colorSize.x);
		_yellowToOrangeLeft.property(1, _colorSize.y);
		_yellowToOrangeLeft.property(2, 1);
		_yellowToOrangeLeft.property(3, 0.28);
		_yellowToOrangeLeft.property(4, 0);
		_yellowToOrangeLeft.property(5, 0.50);

		_orangeToRedLeft = new SetColorFilterRect();
		_orangeToRedLeft.position = position - Vec2f(2.1 * GRID_RATIO, 0);
		_orangeToRedLeft.property(0, _colorSize.x);
		_orangeToRedLeft.property(1, _colorSize.y);
		_orangeToRedLeft.property(2, 1);
		_orangeToRedLeft.property(3, 0);
		_orangeToRedLeft.property(4, 0);
		_orangeToRedLeft.property(5, 0.25);

		_whiteToYellowRight = new SetColorFilterRect();
		_whiteToYellowRight.position = position + Vec2f(0.7 * GRID_RATIO, 0);
		_whiteToYellowRight.property(0, _colorSize.x);
		_whiteToYellowRight.property(1, _colorSize.y);
		_whiteToYellowRight.property(2, 1);
		_whiteToYellowRight.property(3, 1);
		_whiteToYellowRight.property(4, 0);
		_whiteToYellowRight.property(5, 0.75);

		_yellowToOrangeRight = new SetColorFilterRect();
		_yellowToOrangeRight.position = position + Vec2f(1.4 * GRID_RATIO, 0);
		_yellowToOrangeRight.property(0, _colorSize.x);
		_yellowToOrangeRight.property(1, _colorSize.y);
		_yellowToOrangeRight.property(2, 1);
		_yellowToOrangeRight.property(3, 0.28);
		_yellowToOrangeRight.property(4, 0);
		_yellowToOrangeRight.property(5, 0.50);

		_orangeToRedRight = new SetColorFilterRect();
		_orangeToRedRight.position = position + Vec2f(2.1 * GRID_RATIO, 0);
		_orangeToRedRight.property(0, _colorSize.x);
		_orangeToRedRight.property(1, _colorSize.y);
		_orangeToRedRight.property(2, 1);
		_orangeToRedRight.property(3, 0);
		_orangeToRedRight.property(4, 0);
		_orangeToRedRight.property(5, 0.25);

		_timer.start(1f);
	}

	override void update(float deltaTime) {
		_timer.update(deltaTime);
		_timerBeforeDelete.update(deltaTime);

		if(_timer.isRunning()) {
			for(int i = -2; i < 3; ++i) {
				Vec2i explosionPos = Vec2i(gridPosition.x + i, gridPosition.y);

				if(currentGrid.at(explosionPos) != Type.None) {
					foreach(Entity enemy; enemies) {
						if(enemy.gridPosition == explosionPos) {
							enemy.receiveDamage();
						}
					}

					foreach(Entity obstacle; obstacles) {
						if(obstacle.gridPosition == explosionPos) {
							obstacle.receiveDamage();
						}
					}

					if(player.gridPosition == explosionPos) {
						player.receiveDamage();
					}
				}
			}

        	_timer.update(deltaTime);
			Particle particle_left = new Particle;
			particle_left.position.x = uniform!"[]"(position.x - 0.05, position.x + 0.05);
			particle_left.position.y = uniform!"[]"(position.y - 5, position.y + 5);
			particle_left.velocity.x = uniform!"[]"(-6f, -5f);
			particle_left.velocity.y = 0;
			particle_left.timeToLive = 0.5f * 60f;
			particle_left.scale = 0.5f;
			particle_left.color = Color.white;
            particle_left.time = 0f;

			Particle particle_right = new Particle;
			particle_right.position.x = uniform!"[]"(position.x - 0.05, position.x + 0.05);
			particle_right.position.y = uniform!"[]"(position.y - 5, position.y + 5);
			particle_right.velocity.x = uniform!"[]"(5f, 6f);
			particle_right.velocity.y = 0;
			particle_right.timeToLive = 0.5f * 60f;
			particle_right.scale = 0.5f;
			particle_right.color = Color.white;
            particle_right.time = 0f;

			_particleSource.particles.push(particle_left);
			_particleSource.particles.push(particle_right);
		} else if(!_deletionStarted) {
			_timerBeforeDelete.start(1f);
			_deletionStarted = true;
		}

		if(_deletionStarted && !_timerBeforeDelete.isRunning()) {
			_life = 0;
		}


		foreach(Particle particle; _particleSource.particles) {
			_scaleDown.apply(particle, deltaTime);
			_whiteToYellowLeft.apply(particle, deltaTime);
			_yellowToOrangeLeft.apply(particle, deltaTime);
			_orangeToRedLeft.apply(particle, deltaTime);
			_whiteToYellowRight.apply(particle, deltaTime);
			_yellowToOrangeRight.apply(particle, deltaTime);
			_orangeToRedRight.apply(particle, deltaTime);
		}

		_particleSource.update(deltaTime);
	} 

	override void draw(bool inhibitDraw = false) {
		_particleSource.draw();

		if(_debug) {
			drawRect(position - _size / 2, _size, Color.white);
			drawRect(_whiteToYellowLeft.position - _colorSize / 2, _colorSize, Color.yellow);
			drawRect(_yellowToOrangeLeft.position - _colorSize / 2, _colorSize, Color(1f, 0.64f, 0));
			drawRect(_orangeToRedLeft.position - _colorSize / 2, _colorSize, Color.red);
			drawRect(_whiteToYellowRight.position - _colorSize / 2, _colorSize, Color.yellow);
			drawRect(_yellowToOrangeRight.position - _colorSize / 2, _colorSize, Color(1f, 0.64f, 0));
			drawRect(_orangeToRedRight.position - _colorSize / 2, _colorSize, Color.red);
		}
	}

	override void receiveDamage(int damage) { }
}