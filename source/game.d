module th.game;

import grimoire;

import th.bomb;
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

Scene currentScene;

void startGame() {
    removeWidgets();
    currentScene = new Scene;
    addWidget(currentScene);

    //Stages
    _stages ~= &onStage00;
    _stages ~= &onStage01;

    //Launch the first one
    currentScene.onNewStage(0);
}

private {
    alias StageCallback = void function();
    StageCallback[] _stages;
}

void onStage00() {
    createGrid(Vec2u(20, 20), "netherworld", Vec2i(0,0), Vec2i(3,3));

    addEnemy(Vec2i(14, 10), "ghost", 5);
    addEnemy(Vec2i(5, 10), "ghost", 5);

    addItem(Vec2i(1, 1), ItemType.BOMB);
    addYinyang(Vec2i(0, 5), Direction.RIGHT);
}

void onStage01() {
    createGrid(Vec2u(3, 1), "plaine", Vec2i(0,0), Vec2i(2,0));
}

void addEnemy(Vec2i pos, string name, int life) {
    auto enemy = new Enemy(pos, name);
    enemy.setLife(life);
    enemies.push(enemy);
}

void addItem(Vec2i pos, ItemType type) {
    auto bomb = new Item(pos, type);
    items.push(bomb);
}

void addYinyang(Vec2i pos, Direction dir) {
    auto yinyang = new YinYang(pos, dir);
    enemies.push(yinyang);
}

void onNextLevel() {
    currentScene.onNextLevel();
}

private final class Scene: WidgetGroup {
    private {
        //Modules
        Camera _camera;
        InputManager _inputManager;

        //Sub widgets
        Inventory _inventory;
        GUI _arrows;
        int _level = 0;
    }

    this() {
        _position = centerScreen;
		_size = screenSize;
		_camera = createCamera(centerScreen, screenSize);

        playerShots = createPlayerShotArray();
        enemyShots = createEnemyShotArray();

        _inputManager = new InputManager;
        enemies = new EntityArray;
        items = new EntityArray;
        startEpoch();
    }

    ~this() {
        destroyGrid();
    }

    void reset() {
        items.reset();
        enemies.reset();
        enemyShots.reset();
        playerShots.reset();
        startEpoch();
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
        foreach(Shot shot, uint index; playerShots) {
			shot.update(deltaTime);
			if(!shot.isAlive)
				playerShots.markInternalForRemoval(index);
			//Handle collisions with enemies
            foreach(Entity enemy; enemies) {
                shot.handleCollision(enemy);
            }
		}

        //Update enemy shots
        foreach(Shot shot, uint index; enemyShots) {
			shot.update(deltaTime);
			if(!shot.isAlive)
				enemyShots.markInternalForRemoval(index);
			//Handle collisions with the player
            shot.handleCollision(player);
		}

        //Player input handling
        player.canPlay = false;
        if(canActEpoch()) {
            Direction input = _inputManager.getKeyPressed(); //to pass on to player
            bool inputValid = player.checkDirectionValid(input) && player.canUseDirection(input);

            if(inputValid) {
                player.canPlay = true;
                player.direction = input;
            }
        }
        player.update(deltaTime);
        if(canActEpoch())
            player.updateGridState();

        _inventory.update(deltaTime);

        //Update enemies shots
        foreach(Entity enemy, uint index; enemies) {
			enemy.update(deltaTime);
			if(!enemy.isAlive) {
				enemies.markInternalForRemoval(index);
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
        playerShots.sweepMarkedData();
        enemyShots.sweepMarkedData();
        enemies.sweepMarkedData();

        updateEpoch(deltaTime);

        _camera.update(deltaTime);
        super.update(deltaTime);
    }

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.

        currentGrid.draw();

        foreach(Entity enemy; enemies) {
            enemy.draw();
        }

        foreach(Entity item; items) {
            item.draw();
        }

        player.draw();

        foreach(Shot shot; playerShots) {
            shot.draw();
        }

        foreach(Shot shot; enemyShots) {
            shot.draw();
        }    

        //End scene rendering
		popView();
		_camera.draw();
        super.draw();
	}

    void onNewStage(int level) {
        removeChildren();
        reset();

        _stages[level]();

        player = new Player(currentGrid.spawnPos, "reimu_idle");
        moveCameraTo(player.position, 1f);

        //UI
        _arrows = new GUI(player);
        addChild(_arrows);
        _inventory = new Inventory(items);
        player.inventory = _inventory;
        addChild(_inventory);
    }

    void onNextLevel() {
        _level ++;
        if(_level == _stages.length) {
            writeln("END OF STAGES");
            return;
        }
        onNewStage(_level);
    }
}

