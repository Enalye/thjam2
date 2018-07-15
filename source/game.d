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
    currentScene.onStage1();
}

private final class Scene: WidgetGroup {
    private {
        //Modules
        Camera _camera;
        InputManager _inputManager;

        //Sub widgets
        Inventory _inventory;
        GUI _arrows;
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
            obstacle.update(deltaTime);
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

        foreach(Entity obstacle; obstacles) {
            obstacle.draw();
        }

        //End scene rendering
		popView();
		_camera.draw();
        super.draw();
	}

    void onStage1() {
        createGrid(Vec2u(20, 20), "netherworld", Vec2i(0,0), Vec2i(19,19));
        player = new Player(Vec2i(0, 0), "reimu_idle");
        moveCameraTo(player.position, 1f);

        auto enemy = new Enemy(Vec2i(14, 10), "ghost", Vec2f(0.5f, 1f));
        enemies.push(enemy);
        enemy = new Enemy(Vec2i(5, 10), "ghost", Vec2f(0.5f, 1f));
        enemies.push(enemy);

       /* auto power = new Item(Vec2i(1, 1), ItemType.POWER, Vec2f(0.5f, 0.5f));
        _items.push(power);*/

        auto bomb = new Item(Vec2i(1, 1), ItemType.BOMB, Vec2f(0.7f, 0.85f));
        items.push(bomb);

        auto yinyang = new YinYang(Vec2i(0, 5), Direction.RIGHT);
        enemies.push(yinyang);

        auto tree1 = new Obstacle(Vec2i(1, 5), ObstacleType.TREE);
        obstacles.push(tree1);

        //UI
        removeChildren();
        _arrows = new GUI(player);
        addChild(_arrows);
        _inventory = new Inventory(items);
        player.inventory = _inventory;
        addChild(_inventory);
    }

    void onStage2() {
        createGrid(Vec2u(20, 20), "plaine", Vec2i(0,0), Vec2i(3,3));
        player = new Player(Vec2i(0, 0), "reimu_omg");
        moveCameraTo(player.position, 1f);
    }
}