module th.stage;

import grimoire;
import th.entity;
import th.grid;

class Stage {
	EntityPoolArray pools;

	this(Vec2u scale) {
		pools = new EntityPoolArray;
		currentGrid = new Grid(scale, centerScreen());
	}

	void update(float deltaTime) {
		foreach(EntityPool pool; pools) {
			pool.update(deltaTime);
		}

		currentGrid.reset();
	}

	void addEnemyData(Vec2i position, uint poolId) {
		currentGrid.set(Type.Enemy, position);
		pools[poolId].push(new Entity(Type.Enemy, position));
	}

	void addPlayerData(Vec2i position, uint poolId) {
		currentGrid.set(Type.Player, position);
		pools[poolId].push(new Entity(Type.Player, position));
	}

	void draw() {
		foreach(EntityPool entitypool; pools) {
			entitypool.draw();
		}
		currentGrid.draw();
	}
}