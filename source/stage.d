module th.stage;

import grimoire;
import th.entity;
import th.grid;

class Stage {
	EntityPoolArray pools;
	Grid grid;

	this(Vec2u scale) {
		pools = new EntityPoolArray;
		grid = new Grid(scale, centerScreen());
	}

	void update(float deltaTime) {
		foreach(EntityPool pool; pools) {
			pool.update(deltaTime, grid);
		}

		grid.reset();
	}

	void addEnemyData(Vec2u position, uint poolId) {
		grid.set(Type.Enemy, position);
		pools[poolId].push(new Entity(Type.Enemy, position, grid.topLeft));
	}

	void addPlayerData(Vec2u position, uint poolId) {
		grid.set(Type.Player, position);
		pools[poolId].push(new Entity(Type.Player, position, grid.topLeft));
	}

	void draw() {
		foreach(EntityPool entitypool; pools) {
			entitypool.draw();
		}
		grid.draw();
	}
}