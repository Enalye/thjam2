module th.game;

import grimoire;

import th.arrows;
import th.camera;
import th.entity;
import th.input;
import th.item;
import th.grid;
import th.player;
import th.enemy;
import th.shot;
import th.epoch;

private {
    Scene _scene;
}

void startGame() {
    removeWidgets();
    _scene = new Scene;
    addWidget(_scene);
    _scene.onStage1();
}

private final class Scene: WidgetGroup {
    private {
        //Modules
        Camera _camera;
        InputManager _inputManager;

        //Entities
        ShotArray _playerShots, _enemyShots;
        EntityArray _enemies, _items;
        Player _player;
        Arrows _arrows;
    }

    this() {
        _position = centerScreen;
		_size = screenSize;
		_camera = createCamera(centerScreen, screenSize);
        _playerShots = createPlayerShotArray();
        _enemyShots = createEnemyShotArray();
        _inputManager = new InputManager;
        _enemies = new EntityArray;
        startEpoch();
        _items = new EntityArray;
    }

    ~this() {
        destroyGrid();
    }

    override void onPosition() {
        _camera.position = _position;
    }

    override void onSize() {
        _camera.size = _size;
    }
    
    override void onEvent(Event event) {
        super.onEvent(event);
    }

    override void update(float deltaTime) {
        //Update player shots
        foreach(Shot shot, uint index; _playerShots) {
			shot.update(deltaTime);
			if(!shot.isAlive)
				_playerShots.markInternalForRemoval(index);
			//Handle collisions with enemies
            foreach(Entity enemy; _enemies) {
                shot.handleCollision(enemy);
            }
		}

        //Update enemy shots
        foreach(Shot shot, uint index; _enemyShots) {
			shot.update(deltaTime);
			if(!shot.isAlive)
				_enemyShots.markInternalForRemoval(index);
			//Handle collisions with the player
            shot.handleCollision(_player);
		}

        //Player input handling
        if(canActEpoch()) {
            Direction input = _inputManager.getKeyPressed(); //to pass on to player
            bool inputValid = _player.checkDirectionValid(input);

            if(inputValid) {
                _player.setDirection(input);
                _player.update(deltaTime);
            }

            _player.updateGridState();
        }
        //Update enemies shots
        foreach(Entity enemy, uint index; _enemies) {
			enemy.update(deltaTime);
			if(!enemy.isAlive) {
				_enemies.markInternalForRemoval(index);
                enemy.removeFromGrid();
            }
            else {
                if(isEpochTimedout()) {
                    (cast(Enemy)enemy).action();
                }
				enemy.updateGridState();
			}
		}

        //Cleanup data
        _playerShots.sweepMarkedData();
        _enemyShots.sweepMarkedData();
        _enemies.sweepMarkedData();

        updateEpoch(deltaTime);

        _camera.update(deltaTime);
        super.update(deltaTime);
    }

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.

        currentGrid.draw();

        foreach(Entity enemy; _enemies) {
            enemy.draw();
        }

        _player.draw();

        foreach(Shot shot; _playerShots) {
            shot.draw();
        }

        foreach(Shot shot; _enemyShots) {
            shot.draw();
        }    

        //End scene rendering
		popView();
		_camera.draw();
        super.draw();
	}

    void onStage1() {
        createGrid(Vec2u(15, 10), "plaine");
        _player = new Player(Vec2i(0, 0));
        moveCameraTo(_player.position, 1f);

        auto enemy = new Enemy(Vec2i(0, 5));
        _enemies.push(enemy);
        enemy = new Enemy(Vec2i(4, 5));
        _enemies.push(enemy);

        auto item = new Item(_player, Vec2i(12, 5), ItemType.YINYANG);
        _items.push(item);

        //UI
        removeChildren();
        _arrows = new Arrows(_player);
        addChild(_arrows);
    }
}