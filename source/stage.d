module th.stage;

import grimoire;
import th.entity;
import th.grid;
import th.player;
import th.enemy;

class Stage {
	EntityPoolArray pools;
	Grid grid;

	this(Vec2u scale, string tileSetPath) {
		pools = new EntityPoolArray;
<<<<<<< working copy
		currentGrid = new Grid(scale, centerScreen(), tileSetPath);
=======
		grid = createGrid(scale);
>>>>>>> merge rev
	}

    ~this() {
        destroyGrid();
    }

	void update(float deltaTime) {
		foreach(EntityPool pool; pools) {
			pool.update(deltaTime);
		}
<<<<<<< working copy
=======

		grid.reset();
>>>>>>> merge rev
	}

<<<<<<< working copy
	Entity addEnemyData(Vec2i position, uint poolId) {
		currentGrid.set(Type.Enemy, position);
		Entity entity = new Entity(Type.Enemy, position);
		pools[poolId].push(entity);
		return entity;
=======
	void addEnemyData(Vec2i position, uint poolId) {
		grid.set(Type.Enemy, position);
        auto enemy = new Enemy;
        enemy.gridPosition = position;
		pools[poolId].push(enemy);
>>>>>>> merge rev
	}

<<<<<<< working copy
	Entity addPlayerData(Vec2i position, uint poolId) {
		currentGrid.set(Type.Player, position);
		Entity entity = new Entity(Type.Player, position);
		pools[poolId].push(entity);
		return entity;
=======
	void addPlayerData(Vec2i position, uint poolId) {
		grid.set(Type.Player, position);
        auto player = new Player;
        player.gridPosition = position;
		pools[poolId].push(player);
>>>>>>> merge rev
	}

	void draw() {
		currentGrid.draw();
		foreach(EntityPool entitypool; pools) {
			entitypool.draw();
		}
<<<<<<< working copy
=======
		grid.draw();
>>>>>>> merge rev
	}
}