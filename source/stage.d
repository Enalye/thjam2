module th.stage;

import grimoire;
import th.entity;
import th.grid;

class Stage {
	EntityPoolArray pools;

	this(Vec2u scale, string tileSetPath) {
		pools = new EntityPoolArray;
		currentGrid = new Grid(scale, centerScreen(), tileSetPath);
	}

	void update(float deltaTime) {
		foreach(EntityPool pool; pools) {
			pool.update(deltaTime);
		}
	}

	Entity addEnemyData(Vec2i position, uint poolId) {
		currentGrid.set(Type.Enemy, position);
		Entity entity = new Entity(Type.Enemy, position);
		pools[poolId].push(entity);
		return entity;
	}

	Entity addPlayerData(Vec2i position, uint poolId) {
		currentGrid.set(Type.Player, position);
		Entity entity = new Entity(Type.Player, position);
		pools[poolId].push(entity);
		return entity;
	}

	void draw() {
		currentGrid.draw();
		foreach(EntityPool entitypool; pools) {
			entitypool.draw();
		}
	}
}