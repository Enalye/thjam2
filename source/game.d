module th.game;

import grimoire;

import th.camera;
import th.enemy;
import th.entity;
import th.epoch;
import th.input;
import th.inventory;
import th.item;
import th.grid;
import th.gui;
import th.player;
import th.shot;
import th.yinyang;

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

        //Sub widgets
        Inventory _inventory;
        GUI _arrows;
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
        _player.canPlay = false;
        if(canActEpoch()) {
            Direction input = _inputManager.getKeyPressed(); //to pass on to player
            bool inputValid = _player.checkDirectionValid(input) && _player.canUseDirection(input);

            if(inputValid) {
                _player.canPlay = true;
                _player.direction = input;
            }
        }
        _player.update(deltaTime);
        if(canActEpoch())
            _player.updateGridState();

        _inventory.update(deltaTime);

        //Update enemies shots
        foreach(Entity enemy, uint index; _enemies) {
			enemy.update(deltaTime);
			if(!enemy.isAlive) {
				_enemies.markInternalForRemoval(index);
                enemy.removeFromGrid();
            }
            else {
                if(isEpochTimedout()) {
                    enemy.action();
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

        foreach(Entity item; _items) {
            item.draw();
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
        createGrid(Vec2u(20, 20), "plaine");
        _player = new Player(Vec2i(0, 0), "reimu_idle");
        moveCameraTo(_player.position, 1f);

        auto enemy = new Enemy(Vec2i(14, 10), "fairy_default");
        _enemies.push(enemy);
        enemy = new Enemy(Vec2i(5, 10), "fairy_default");
        _enemies.push(enemy);

        auto item = new Item(Vec2i(1, 1), ItemType.POWER);
        _items.push(item);

        auto yinyang = new YinYang(Vec2i(0, 5), Direction.RIGHT);
        _enemies.push(yinyang);

        //UI
        removeChildren();
        _arrows = new GUI(_player);
        addChild(_arrows);
        _inventory = new Inventory(_items);
        _player.inventory = _inventory;
        addChild(_inventory);
    }

    void onStage2() {
        createGrid(Vec2u(20, 20), "netherworld");
        _player = new Player(Vec2i(0, 0), "reimu_omg");
        moveCameraTo(_player.position, 1f);
    }
}