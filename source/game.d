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
import th.obstacle;
import th.player;
import th.shot;
import th.yinyang;

Scene currentScene;

void startGame() {
    removeWidgets();
    currentScene = new Scene;
    addWidget(currentScene);

    //Stages
    _stages ~= &onStage01;
    _stages ~= &onStage02;
    _stages ~= &onStage05;

    //Launch the first one
    currentScene.onNewStage(0);
}

private {
    alias StageCallback = void function();
    StageCallback[] _stages;
}

void onStage01() {
    createGrid(Vec2u(3, 1), "plaine", Vec2i(0,0), Vec2i(2,0));
}

void onStage02() {
    createGrid(Vec2u(5, 3), "plaine", Vec2i(0,1), Vec2i(4,1));

    addObstacle(Vec2i(0, 0), ObstacleType.TREE);
    addObstacle(Vec2i(0, 2), ObstacleType.TREE);
    addObstacle(Vec2i(4, 0), ObstacleType.TREE);
    addObstacle(Vec2i(4, 2), ObstacleType.TREE);

    addYinyang(Vec2i(2, 0), Direction.DOWN);
}

void onStage05() {
    createGrid(Vec2u(6, 6), "netherworld", Vec2i(0,0), Vec2i(5,5));

    addEnemy(Vec2i(2, 2), "ghost", 5);

    addObstacle(Vec2i(1, 5), ObstacleType.TREE);

    addObstacle(Vec2i(4, 4), ObstacleType.WALL);
    addObstacle(Vec2i(4, 5), ObstacleType.WALL);
    addObstacle(Vec2i(5, 4), ObstacleType.WALL);

    addItem(Vec2i(1, 1), ItemType.BOMB);
    addItem(Vec2i(2, 3), ItemType.POWER);
    addYinyang(Vec2i(0, 5), Direction.RIGHT);
}

void addEnemy(Vec2i pos, string name, int life) {
    auto enemy = new Enemy(pos, name);
    enemy.setLife(life);
    enemies.push(enemy);
}

void addObstacle(Vec2i pos, ObstacleType obstacleType) {
    auto obstacle = new Obstacle(pos, obstacleType);
    obstacles.push(obstacle);
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
        obstacles = new EntityArray;
        startEpoch();
    }

    ~this() {
        destroyGrid();
    }

    void reset() {
        items.reset();
        enemies.reset();
        obstacles.reset();
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

        //Update obstacles
        foreach(Entity obstacle, uint index; obstacles) {
            if(!obstacle.isAlive) {
                obstacles.markInternalForRemoval(index);
                obstacle.removeFromGrid();
            }
        }

        //Cleanup data
        playerShots.sweepMarkedData();
        enemyShots.sweepMarkedData();
        enemies.sweepMarkedData();
        obstacles.sweepMarkedData();

        updateEpoch(deltaTime);

        _camera.update(deltaTime);
        super.update(deltaTime);
    }

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.

        currentGrid.draw();

        player.draw();

        foreach(Entity enemy; enemies) {
            enemy.draw();
        }

        foreach(Entity obstacle; obstacles) {
            obstacle.draw();
        }

        foreach(Entity item; items) {
            item.draw();
        }

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

