module th.stage;

import grimoire;
import th.entity;
import th.grid;
import th.player;
import th.enemy;

class Stage {
	EntityPoolArray pools;
	Grid grid;

	this(Vec2u scale) {
		pools = new EntityPoolArray;
		grid = createGrid(scale);
	}

    ~this() {
        destroyGrid();
    }

	void update(float deltaTime) {
		foreach(EntityPool pool; pools) {
			pool.update(deltaTime);
		}

		grid.reset();
	}

	void addEnemyData(Vec2i position, uint poolId) {
		grid.set(Type.Enemy, position);
        auto enemy = new Enemy;
        enemy.gridPosition = position;
		pools[poolId].push(enemy);
	}

	void addPlayerData(Vec2i position, uint poolId) {
		grid.set(Type.Player, position);
        auto player = new Player;
        player.gridPosition = position;
		pools[poolId].push(player);
	}

	void draw() {
		foreach(EntityPool entitypool; pools) {
			entitypool.draw();
		}
		grid.draw();
	}
}