module th.game;

import grimoire;

import th.camera;
import th.entity;
import th.stage;
import th.shot;

private {
    Scene _scene;
}

void startGame() {
    removeWidgets();
    _scene = new Scene;
    addWidget(_scene);
    _scene.onStage1();
}

private final class Scene: Widget {
    private {
        Camera _camera;
        Stage _stage;
        ShotArray _playerShots, _enemyShots;
    }

    this() {
        _position = centerScreen;
		_size = screenSize;
		_camera = createCamera(centerScreen, screenSize);
        _playerShots = createPlayerShotArray();
        _enemyShots = createEnemyShotArray();
    }

    override void onPosition() {
        _camera.position = _position;
    }

    override void onSize() {
        _camera.size = _size;
    }
    
    override void onEvent(Event event) {}

    override void update(float deltaTime) {
        //Update shots
        foreach(Shot shot, uint index; _playerShots) {
			shot.update(deltaTime);
			if(!shot.isAlive)
				_playerShots.markInternalForRemoval(index);
			//Handle collisions with enemies

		}

        foreach(Shot shot, uint index; _enemyShots) {
			shot.update(deltaTime);
			if(!shot.isAlive)
				_enemyShots.markInternalForRemoval(index);
			//Handle collisions with the player

		}

        _playerShots.sweepMarkedData();
        _enemyShots.sweepMarkedData();

    }

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.

        _stage.draw();        

        //End scene rendering
		popView();
		_camera.draw();
	}

    void onStage1() {
        _stage = new Stage(Vec2u(5, 7));
        uint playerPoolId = _stage.pools.push(new EntityPool);
        uint enemyPoolId = _stage.pools.push(new EntityPool);
        _stage.addPlayerData(Vec2i(0, 0), playerPoolId);
        _stage.addEnemyData(Vec2i(0, 5), enemyPoolId);
        _stage.addEnemyData(Vec2i(4, 5), enemyPoolId);
    }
}