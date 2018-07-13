module th.game;

import grimoire;

import th.camera;
import th.entity;
import th.stage;
import th.grid;
import th.input;

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
        InputManager _inputManager;
        Entity _player;
        uint lastInput;
    }

    this() {
        _position = centerScreen;
		_size = screenSize;
		_camera = createCamera(centerScreen, screenSize);
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
        bool inputValid = false;
        uint input = _inputManager.getKeyPressed(); //to pass on to player

        if(input != lastInput) {
            if(input == UP) {
                inputValid = checkDirectionValid(Vec2i(0, -1));
            }

            if(input == DOWN) {
                inputValid = checkDirectionValid(Vec2i(0, 1));
            }

            if(input == LEFT) {
                inputValid = checkDirectionValid(Vec2i(-1, 0));
            }

            if(input == RIGHT) {
                inputValid = checkDirectionValid(Vec2i(1, 0));
            }

            if(inputValid) {
                lastInput = input;
            }
        }

        _stage.update(deltaTime);
    }

    bool checkDirectionValid(Vec2i direction) {
        Vec2i newPosition = _player.getUpdatedPosition(direction);
        if(currentGrid.isPositionValid(newPosition) && !currentGrid.alreadyOccupied(newPosition)) {
            _player.direction = direction;
            return true;
        } 

        return false;
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
        _stage = new Stage(Vec2u(18, 10), "plaine");
        uint playerPoolId = _stage.pools.push(new EntityPool("reimu_omg"));
        uint enemyPoolId = _stage.pools.push(new EntityPool("fairy_default"));
        _player = _stage.addPlayerData(Vec2i(0, 0), playerPoolId);
        _stage.addEnemyData(Vec2i(0, 5), enemyPoolId);
        _stage.addEnemyData(Vec2i(4, 5), enemyPoolId);
    }
}