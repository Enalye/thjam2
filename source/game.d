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
import th.sound;
import th.menu;

Scene currentScene;

void startGame() {
    removeWidgets();
    currentScene = new Scene;
    addWidget(currentScene);

    //Stages
    _stages ~= &onStage00;
    _stages ~= &onStage01;
    _stages ~= &onStage02;
    _stages ~= &onStage03;
    _stages ~= &onStage04;
    _stages ~= &onStage05;
    _stages ~= &onStage06; 
    _stages ~= &onStage07; 
    _stages ~= &onStage08;
    _stages ~= &onStage09;
    _stages ~= &onStage10;
    _stages ~= &onStage11;
    _stages ~= &onStage12;
    _stages ~= &onStage13;

    //Launch the first one
    currentScene.onNewStage(0);
}

private {
    alias StageCallback = void function();
    StageCallback[] _stages;
    StageCallback _onRespawn;
}

void onRespawn() {
    if(_onRespawn !is null) {
        _onRespawn();
    }
}

void onStage00() {
    createGrid(Vec2u(2, 1), "plaine", Vec2i(0,0), Vec2i(1,0));
    setText(Vec2f(600f, 250f), "{b}Welcome to the first stage !{n}To win, you just have to move to the {red}gap{white} to your right !");
    playMusic("stage1");
    setBackground("title_background_1");
}

void onStage01() {
    createGrid(Vec2u(3, 1), "plaine", Vec2i(0,0), Vec2i(2,0));
    setText(Vec2f(600f, 250f), "{b}That was fast !{n}{n}Unfortunately, you won't be able to use the same key {red}twice{white}{n}Try to {red}shoot{white} so you can use the {red}right key{white} again !");
}

void onStage02() {
    createGrid(Vec2u(5, 3), "plaine", Vec2i(0,1), Vec2i(4,1));
    setText(Vec2f(600f, 250f), "{b}{red}Yin yang orbs{white} will damage you !{n}Fire at them to change the direction in which they bounce.{n}");

    addObstacle(Vec2i(0, 0), ObstacleType.TREE);
    addObstacle(Vec2i(0, 2), ObstacleType.TREE);
    addObstacle(Vec2i(4, 0), ObstacleType.TREE);
    addObstacle(Vec2i(4, 2), ObstacleType.TREE);

    addYinyang(Vec2i(2, 0), Direction.DOWN);
}

void onStage03() {
    createGrid(Vec2u(4, 3), "plaine", Vec2i(0,1), Vec2i(3,1));
    setText(Vec2f(600f, 250f), "{b}Be wary of {red}enemies{white} ! Know that you do not take damage on the tori.{n}You can try to destroy them by firing at them, but there are other ways too...{n}");

    addEnemy(Vec2i(2, 2), EnemyType.FAIRY_PURPLE, 5);
}

void onRespawnStage04() {
    addItem(Vec2i(2, 1), ItemType.BOMB);
}

void onStage04() {
    createGrid(Vec2u(5, 3), "plaine", Vec2i(0,1), Vec2i(4,1));
    setText(Vec2f(600f, 220f), "{b}Use the {red}bomb{white} with space to destroy the wall !{n}Be wary, it will be placed in the direction you are facing, and explodes horizontally.{n}Hint: You can alwaysreset with {red}\"R\"");

    addObstacle(Vec2i(3, 0), ObstacleType.LAMP);
    addObstacle(Vec2i(3, 1), ObstacleType.WALL);
    addObstacle(Vec2i(3, 2), ObstacleType.LAMP);

    addYinyang(Vec2i(0, 0), Direction.RIGHT);

    _onRespawn = &onRespawnStage04;
}

void onStage05() {
    createGrid(Vec2u(7, 3), "plaine", Vec2i(0,1), Vec2i(6,1));

    addObstacle(Vec2i(3, 0), ObstacleType.WALL);
    addObstacle(Vec2i(5, 1), ObstacleType.WALL);
    addEnemy(Vec2i(4, 1), EnemyType.FAIRY_GREEN, 5);
    addObstacle(Vec2i(3, 2), ObstacleType.WALL);

    addYinyang(Vec2i(1, 1), Direction.DOWN);
}

void onStage06() {
    createGrid(Vec2u(7, 5), "plaine", Vec2i(0,0), Vec2i(6, 4));
    addObstacle(Vec2i(6, 3), ObstacleType.LAMP);
    addObstacle(Vec2i(5, 3), ObstacleType.TREE);
    addObstacle(Vec2i(4, 3), ObstacleType.LAMP);
    addObstacle(Vec2i(3, 3), ObstacleType.TREE);
    addObstacle(Vec2i(2, 3), ObstacleType.LAMP);
    addObstacle(Vec2i(1, 3), ObstacleType.TREE);

    addEnemy(Vec2i(3, 1), EnemyType.FAIRY_YELLOW, 5);

    addYinyang(Vec2i(0, 4), Direction.RIGHT);
}

void onStage07() {
    createGrid(Vec2u(7, 7), "plaine", Vec2i(0,0), Vec2i(6, 6));

    addObstacle(Vec2i(1, 0), ObstacleType.TREE);
    addObstacle(Vec2i(1, 1), ObstacleType.TOMB);
    addObstacle(Vec2i(1, 2), ObstacleType.LAMP);
    addObstacle(Vec2i(1, 3), ObstacleType.TREE);
    addObstacle(Vec2i(1, 4), ObstacleType.TOMB);
    addObstacle(Vec2i(1, 5), ObstacleType.LAMP);

    addEnemy(Vec2i(3, 2), EnemyType.FAIRY_GREEN, 4);
    addEnemy(Vec2i(3, 3), EnemyType.FAIRY_PURPLE, 4);
    addEnemy(Vec2i(3, 4), EnemyType.FAIRY_YELLOW, 4);
}

void onRespawnStage08() {
    addItem(Vec2i(1, 0), ItemType.BOMB);
    addItem(Vec2i(1, 2), ItemType.BOMB);
}

void onStage08() {
    createGrid(Vec2u(7, 3), "plaine", Vec2i(0,0), Vec2i(6, 2));

    addObstacle(Vec2i(1, 1), ObstacleType.WALL);
    addObstacle(Vec2i(2, 0), ObstacleType.WALL);
    addObstacle(Vec2i(2, 2), ObstacleType.WALL);
    addObstacle(Vec2i(3, 0), ObstacleType.WALL);
    addObstacle(Vec2i(3, 2), ObstacleType.WALL);
    addObstacle(Vec2i(4, 0), ObstacleType.WALL);
    addObstacle(Vec2i(4, 2), ObstacleType.WALL);
    addObstacle(Vec2i(5, 1), ObstacleType.WALL);

    addYinyang(Vec2i(3, 1), Direction.RIGHT);

    _onRespawn = &onRespawnStage08;
}

void onStage09() {
    createGrid(Vec2u(10, 8), "plaine", Vec2i(0,0), Vec2i(9, 7));

    addObstacle(Vec2i(1, 0), ObstacleType.RIVER, 0);
    addObstacle(Vec2i(1, 1), ObstacleType.RIVER, 1);
    addObstacle(Vec2i(1, 2), ObstacleType.RIVER, 2);
    addObstacle(Vec2i(1, 3), ObstacleType.RIVER, 3);
    addObstacle(Vec2i(1, 4), ObstacleType.RIVER, 4);
    addObstacle(Vec2i(1, 5), ObstacleType.RIVER, 5);
    addObstacle(Vec2i(1, 6), ObstacleType.RIVER, 6);

    addEnemy(Vec2i(2, 3), EnemyType.FAIRY_GREEN, 4);

    addObstacle(Vec2i(3, 1), ObstacleType.BAMBOO);
    addObstacle(Vec2i(3, 2), ObstacleType.TOMB);
    addObstacle(Vec2i(3, 3), ObstacleType.BAMBOO);
    addObstacle(Vec2i(3, 4), ObstacleType.TOMB);
    addObstacle(Vec2i(3, 5), ObstacleType.BAMBOO);
    addObstacle(Vec2i(3, 6), ObstacleType.TOMB);
    addObstacle(Vec2i(3, 7), ObstacleType.BAMBOO);

    addEnemy(Vec2i(4, 3), EnemyType.FAIRY_PURPLE, 4);

    addObstacle(Vec2i(5, 0), ObstacleType.RIVER, 0);
    addObstacle(Vec2i(5, 1), ObstacleType.RIVER, 1);
    addObstacle(Vec2i(5, 2), ObstacleType.RIVER, 2);
    addObstacle(Vec2i(5, 3), ObstacleType.RIVER, 3);
    addObstacle(Vec2i(5, 4), ObstacleType.RIVER, 4);
    addObstacle(Vec2i(5, 5), ObstacleType.RIVER, 5);
    addObstacle(Vec2i(5, 6), ObstacleType.RIVER, 6);

    addEnemy(Vec2i(6, 3), EnemyType.FAIRY_YELLOW, 4);

    addObstacle(Vec2i(7, 1), ObstacleType.BAMBOO);
    addObstacle(Vec2i(7, 2), ObstacleType.TOMB);
    addObstacle(Vec2i(7, 3), ObstacleType.BAMBOO);
    addObstacle(Vec2i(7, 4), ObstacleType.TOMB);
    addObstacle(Vec2i(7, 5), ObstacleType.BAMBOO);
    addObstacle(Vec2i(7, 6), ObstacleType.TOMB);
    addObstacle(Vec2i(7, 7), ObstacleType.BAMBOO);

    addObstacle(Vec2i(9, 0), ObstacleType.RIVER, 0);
    addObstacle(Vec2i(9, 1), ObstacleType.RIVER, 1);
    addObstacle(Vec2i(9, 2), ObstacleType.RIVER, 2);
    addObstacle(Vec2i(9, 3), ObstacleType.RIVER, 3);
    addObstacle(Vec2i(9, 4), ObstacleType.RIVER, 4);
    addObstacle(Vec2i(9, 5), ObstacleType.RIVER, 5);
    addObstacle(Vec2i(9, 6), ObstacleType.RIVER, 6);

    addItem(Vec2i(8, 4), ItemType.HEART);
}

void onRespawnStage10() {
    addItem(Vec2i(1, 1), ItemType.BOMB);
    addItem(Vec2i(2, 3), ItemType.POWER);
}

void onStage10() {
    createGrid(Vec2u(6, 6), "netherworld", Vec2i(0,0), Vec2i(5,5));
    playMusic("stage2");
    setBackground("title_background_2");

    addEnemy(Vec2i(2, 2), EnemyType.GHOST, 5);

    addObstacle(Vec2i(1, 5), ObstacleType.TREE);

    addObstacle(Vec2i(4, 4), ObstacleType.WALL);
    addObstacle(Vec2i(4, 5), ObstacleType.WALL);
    addObstacle(Vec2i(5, 4), ObstacleType.WALL);

    addYinyang(Vec2i(0, 5), Direction.RIGHT);
    addItem(Vec2i(2, 5), ItemType.HEART);

    _onRespawn = &onRespawnStage10;
}

void onRespawnStage11() {
    addItem(Vec2i(5, 2), ItemType.BOMB);
    addItem(Vec2i(5, 3), ItemType.POWER);
}

void onStage11() {
    createGrid(Vec2u(12, 6), "netherworld", Vec2i(0,0), Vec2i(11,5));

    addObstacle(Vec2i(9, 3), ObstacleType.WALL);
    addObstacle(Vec2i(9, 4), ObstacleType.WALL);
    addObstacle(Vec2i(9, 5), ObstacleType.WALL);
    addObstacle(Vec2i(10, 3), ObstacleType.WALL);
    addObstacle(Vec2i(11, 3), ObstacleType.WALL);

    addObstacle(Vec2i(4, 1), ObstacleType.TREE);
    addObstacle(Vec2i(4, 4), ObstacleType.TREE);
    addObstacle(Vec2i(6, 1), ObstacleType.TREE);
    addObstacle(Vec2i(6, 4), ObstacleType.TREE);

    addEnemy(Vec2i(10, 4), EnemyType.GHOST, 5);
    addEnemy(Vec2i(10, 5), EnemyType.GHOST, 5);
    addEnemy(Vec2i(11, 4), EnemyType.GHOST, 5);

    addYinyang(Vec2i(0, 5), Direction.RIGHT);

    _onRespawn = &onRespawnStage11;
}

void onStage12() {
    createGrid(Vec2u(6, 6), "netherworld", Vec2i(0,0), Vec2i(5,5));

    addYinyang(Vec2i(1, 0), Direction.DOWN);
    addYinyang(Vec2i(2, 5), Direction.UP);
    addYinyang(Vec2i(3, 0), Direction.DOWN);
    addYinyang(Vec2i(4, 5), Direction.UP);
}

void onRespawnStage13() {
    addItem(Vec2i(1, 1), ItemType.BOMB);
    addItem(Vec2i(3, 11), ItemType.BOMB);
    addItem(Vec2i(8, 8), ItemType.HEART);
    addItem(Vec2i(5, 7), ItemType.POWER);
    addItem(Vec2i(6, 4), ItemType.POWER);
    addItem(Vec2i(10, 4), ItemType.POWER);
}

void onStage13() {
    createGrid(Vec2u(12, 12), "netherworld", Vec2i(0,0), Vec2i(0,11));

    addObstacle(Vec2i(3, 0), ObstacleType.WALL);
    addObstacle(Vec2i(3, 1), ObstacleType.WALL);
    addObstacle(Vec2i(3, 2), ObstacleType.WALL);
    addObstacle(Vec2i(3, 3), ObstacleType.WALL);
    addObstacle(Vec2i(0, 1), ObstacleType.WALL);
    addObstacle(Vec2i(0, 2), ObstacleType.WALL);
    addObstacle(Vec2i(1, 2), ObstacleType.WALL);
    addObstacle(Vec2i(0, 4), ObstacleType.WALL);
    addObstacle(Vec2i(1, 4), ObstacleType.WALL);
    addObstacle(Vec2i(2, 4), ObstacleType.WALL);
    addObstacle(Vec2i(3, 4), ObstacleType.WALL);

    addObstacle(Vec2i(5, 0), ObstacleType.WALL);
    addObstacle(Vec2i(5, 2), ObstacleType.WALL);
    addObstacle(Vec2i(5, 3), ObstacleType.WALL);

    addObstacle(Vec2i(6, 0), ObstacleType.WALL);
    addObstacle(Vec2i(7, 0), ObstacleType.WALL);
    addObstacle(Vec2i(8, 0), ObstacleType.WALL);

    addObstacle(Vec2i(0, 10), ObstacleType.WALL);
    addObstacle(Vec2i(1, 10), ObstacleType.WALL);
    addObstacle(Vec2i(2, 10), ObstacleType.WALL);
    addObstacle(Vec2i(3, 10), ObstacleType.WALL);
    addObstacle(Vec2i(4, 10), ObstacleType.WALL);

    addObstacle(Vec2i(1, 6), ObstacleType.WALL);
    addObstacle(Vec2i(1, 7), ObstacleType.WALL);
    addObstacle(Vec2i(1, 8), ObstacleType.WALL);

    addObstacle(Vec2i(2, 11), ObstacleType.WALL);

    addYinyang(Vec2i(0, 3), Direction.RIGHT);
    addYinyang(Vec2i(4, 0), Direction.DOWN);
    addYinyang(Vec2i(11, 11), Direction.LEFT);

    addEnemy(Vec2i(7, 2), EnemyType.GHOST, 5);
    addEnemy(Vec2i(7, 10), EnemyType.GHOST, 5);
    addEnemy(Vec2i(10, 10), EnemyType.FAIRY_PURPLE, 10);
    addEnemy(Vec2i(11, 9), EnemyType.FAIRY_PURPLE, 10);

    _onRespawn = &onRespawnStage13;
}

void addEnemy(Vec2i pos, EnemyType enemyType, int life) {
    auto enemy = new Enemy(pos, enemyType);
    enemy.setLife(life);
    enemies.push(enemy);
}

void addObstacle(Vec2i pos, ObstacleType obstacleType, int id = 0) {
    auto obstacle = new Obstacle(pos, obstacleType, id);
    obstacles.push(obstacle);
}

void addItem(Vec2i pos, ItemType type) {
    auto item = new Item(pos, type);
    items.push(item);
}

void addYinyang(Vec2i pos, Direction dir) {
    auto yinyang = new YinYang(pos, dir);
    enemies.push(yinyang);
}

void onNextLevel() {
    currentScene.onNextLevel();
}

void setBackground(string name) {
    currentScene.setBackground(name);
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
        Timer _victoryTimer;
        bool _isVictory = false;
        Sprite _reimuSmugSprite, _stageClearSprite, _backgroundSprite;
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
        effects = new EntityArray;

        _reimuSmugSprite = fetch!Sprite("reimu_smug");
        _stageClearSprite = fetch!Sprite("stage_clear");

        startEpoch();
    }

    ~this() {
        destroyGrid();
    }

    void setBackground(string name) {
        _backgroundSprite = fetch!Sprite(name);
    }

    void reset() {
        items.reset();
        enemies.reset();
        obstacles.reset();
        enemyShots.reset();
        playerShots.reset();
        _onRespawn = null;
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
        _victoryTimer.update(deltaTime);
        if(_isVictory) {
            if(!_victoryTimer.isRunning) {
                _isVictory = false;

                if(_level == _stages.length)
                    onVictory();
                else
                    onNewStage(_level); 
            }
        }
        else if(getKeyDown("reset")) {
            onNewStage(_level);
        }
        else {
            //Update player shots
            foreach(Shot shot, uint index; playerShots) {
                shot.update(deltaTime);
                if(!shot.isAlive)
                    playerShots.markInternalForRemoval(index);
                //Handle collisions with enemies
                foreach(Entity enemy; enemies) {
                    shot.handleCollision(enemy);
                }

            //Handle collisions with obstacles
            foreach(Entity obstacle, uint index; obstacles) {
                shot.handleCollision(obstacle);
            }
            }

            //Update enemy shots
            foreach(Shot shot, uint index; enemyShots) {
                shot.update(deltaTime);
                if(!shot.isAlive)
                    enemyShots.markInternalForRemoval(index);
                //Handle collisions with the player
                shot.handleCollision(player);

            //Handle collisions with obstacles
            foreach(Entity obstacle, uint index; obstacles) {
                shot.handleCollision(obstacle);
            }
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
                else if(!player.canUseDirection(input) && input != Direction.NONE && player.isAlive) {
                    playSound(SoundType.Nope);
                }
            }
            player.update(deltaTime);
            if(canActEpoch())
                player.updateGridState();

            _inventory.update(deltaTime);

            //Update enemies
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

            foreach(Entity effect, uint index; effects) {
                effect.update(deltaTime);
                if(!effect.isAlive) {
                    effects.markInternalForRemoval(index);
                    effect.removeFromGrid();
                }
            }

            //Cleanup data
            playerShots.sweepMarkedData();
            enemyShots.sweepMarkedData();
            enemies.sweepMarkedData();
            obstacles.sweepMarkedData();
            effects.sweepMarkedData();

            updateEpoch(deltaTime);
        }
        _camera.update(deltaTime);
        super.update(deltaTime);
    }

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.
        _backgroundSprite.draw(_camera.viewPosition);

        currentGrid.draw();

        player.draw();

        foreach(Entity enemy; enemies) {
            enemy.draw();
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

        foreach(Entity obstacle; obstacles) {
            obstacle.draw();
        }

        foreach(Entity effect; effects) {
            effect.draw();
        }


        foreach(Entity entity; enemies) {
            Enemy enemy = cast(Enemy)entity;
            enemy.drawLifeBar();
        }

        currentGrid.drawText();

        //End scene rendering
		popView();
		_camera.draw();
        super.draw();

        if(_isVictory) {

            Vec2f orig = centerScreen + Vec2f(200f, 0f);
            Vec2f dest = centerScreen - Vec2f(200f, 0f);
            Vec2f clearPos, smugPos;
            if(_victoryTimer.time < .5f) {
                float t = _victoryTimer.time * 2f;
                clearPos = orig.lerp(centerScreen, easeOutSine(t));
                _stageClearSprite.size = Vec2f(_stageClearSprite.size.x, _stageClearSprite.clip.w * easeOutQuad(t));
               // _reimuSmugSprite.size = Vec2f(_reimuSmugSprite.size.x, _reimuSmugSprite.clip.w * easeOutQuad(t));
                _stageClearSprite.color = Color.white;
                _reimuSmugSprite.color = Color.white; 
                smugPos = dest.lerp(centerScreen, easeInSine(t)) + Vec2f(0f, _stageClearSprite.clip.w);
                _reimuSmugSprite.color = lerp(Color.white, Color.clear, 1f - easeOutSine(t));
            }
            else {
                float t = (_victoryTimer.time - .5f) * 2f;
                clearPos = dest.lerp(centerScreen, 1f - easeInSine(t));
                _stageClearSprite.color = lerp(Color.white, Color.clear, easeInSine(t));
                _reimuSmugSprite.color = lerp(Color.white, Color.clear, easeInSine(t));
                smugPos = orig.lerp(centerScreen, 1f - easeOutSine(t)) + Vec2f(0f, _stageClearSprite.clip.w);
            }
            _reimuSmugSprite.draw(smugPos);
            _stageClearSprite.draw(clearPos);
        }
	}

    void onNewStage(int level) {
        removeChildren();
        reset();
        setText(Vec2f.zero, "");

        _stages[level]();

        int currentLife = 3;
        if(player)
            currentLife = player.life;
        player = new Player(currentGrid.spawnPos, "reimu_idle");
        player.setLife(currentLife);
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
        playSound(SoundType.Clear);
        _victoryTimer.start(2f);
        _isVictory = true;
    }
}

