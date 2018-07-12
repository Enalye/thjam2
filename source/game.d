module th.game;

import grimoire;

import th.camera;

private {
    Scene _scene;
}

void startGame() {
    removeWidgets();
    _scene = new Scene;
    addWidget(_scene);
}

private final class Scene: Widget {
    private {
        Camera _camera;
    }

    this() {
        _position = centerScreen;
		_size = screenSize;
		_camera = createCamera(centerScreen, screenSize);
    }

    override void onPosition() {
        _camera.position = _position;
    }

    override void onSize() {
        _camera.size = _size;
    }
    
    override void onEvent(Event event) {}

    override void update(float deltaTime) {}

    override void draw() {
		pushView(_camera.view, true);
		//Render everything in the scene here.

        

        //End scene rendering
		popView();
		_camera.draw();
	}
}