module th.game;

import grimoire;

import th.camera;
import th.entity;
import th.input;
import th.grid;
import th.player;
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
        //Modules
        Camera _camera;
        Stage _stage;
        InputManager _inputManager;

        //Entities
        ShotArray _playerShots, _enemyShots;
        EntityPoolArray _enemies;
        Player _player;
    }

    this() {
        _position = centerScreen;
		_size = screenSize;
		_camera = createCamera(centerScreen, screenSize);
        _playerShots = createPlayerShotArray();
        _enemyShots = createEnemyShotArray();
        _inputManager = new InputManager;
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
            shot.handleCollision(_player);
		}

        foreach(Enemy enemy, uint index; _enemies) {
			enemy.update(deltaTime);
			if(!enemy.isAlive)
				_enemies.markInternalForRemoval(index);
		}

        _playerShots.sweepMarkedData();
        _enemyShots.sweepMarkedData();
        _enemies.sweepMarkedData();

        Direction input = _inputManager.getKeyPressed(); //to pass on to player
        bool inputValid = checkDirectionValid(input);

        if(inputValid) {
            _player.setDirection(input);
        }

        _stage.update(deltaTime);
    }

    bool checkDirectionValid(Direction direction) {
        return _player.canUseDirection(direction) &&
            isPositionValid(_player.getUpdatedPosition(direction));
    }

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.

        _stage.draw();

        foreach(Shot shot; _playerShots) {
            shot.draw();
        }

        foreach(Shot shot; _enemyShots) {
            shot.draw();
        }     

        //End scene rendering
		popView();
		_camera.draw();
	}

    void onStage1() {
        _stage = new Stage(Vec2u(17, 10), "plaine");
        uint enemyPoolId = _stage.pools.push(new EntityPool);
        _player = new Player;
        _player.gridPosition = Vec2i(0, 0);
        auto enemy = new Enemy;
        enemy.gridPosition = Vec2i(0, 5);
        _enemies.push(enemy);
        enemy = new Enemy;
        enemy.gridPosition = Vec2i(4, 5);
        _enemies.push(enemy);
    }
}