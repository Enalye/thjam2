module th.entity;

import grimoire;
import th.grid;

alias IndexedArray!(Entity, 50u) EntityArray;
alias IndexedArray!(EntityPool, 10u) EntityPoolArray;

class Entity {
	int _life;
	Type _type;
	bool _turnBased; //if false, update is delta based
	Vec2u _position; //position inside the grid
	Vec2u _direction; //direction for next frame e.g. (0, 1) is up

	private void receiveDamage() {
		_life--;
	}

	void update(float deltaTime, Grid grid) {
		grid.set(Type.None, _position);

		if(_turnBased) {
			_position += _direction;
		} //todo else

		if(isRealInstance(_type) && isOpponent(_type, grid.at(_position))) {
			receiveDamage();
		}
	}

	void updateGridState(Grid grid) {
		grid.set(_type, _position);
	}
}

class EntityPool {
	EntityArray _entities;
	Sprite sprite;

	this() {
		_entities = new EntityArray;
	}

	void update(float deltaTime, Grid grid) {
		foreach(Entity entity, uint index; _entities) {
			entity.update(deltaTime, grid);

			if(entity._life < 0) {
				_entities.markInternalForRemoval(index);
			} else {
				entity.updateGridState(grid);
			}
		}

		_entities.sweepMarkedData();
	}
}

class Stage {
	EntityPoolArray _pools;
	Grid _grid;

	this(Vec2u scale) {
		_pools = new EntityPoolArray;
		_grid = new Grid(scale);
	}

	void update(float deltaTime) {
		foreach(EntityPool pool; _pools) {
			pool.update(deltaTime, _grid);
		}

		_grid.reset();
	}

	void addEnemyData(Vec2u position) {
		_grid.set(Type.Enemy, position);
	}

	void addPlayerData(Vec2u position) {
		_grid.set(Type.Player, position);
	}
}