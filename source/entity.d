module th.entity;

import grimoire;
import th.grid;

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
	IndexedArray!(Entity, 50u) _entities;
	Sprite sprite;

	this() {
		_entities = new IndexedArray!(Entity, 50u);
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
	IndexedArray!(EntityPool, 10u) _pools;
	Grid _grid;

	this(Grid grid) {
		_pools = new IndexedArray!(EntityPool, 10u);
		_grid = grid;
	}

	void update(float deltaTime) {
		foreach(EntityPool pool; _pools) {
			pool.update(deltaTime, _grid);
		}

		_grid.reset();
	}
}