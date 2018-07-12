module th.camera;

import std.conv: to;
import std.random: uniform01;
import std.algorithm.comparison: clamp;

import grimoire;

private {
	Camera _camera;
}

Camera createCamera(Vec2f newPosition, Vec2f newSize) {
	return _camera = new Camera(newPosition, newSize);
}

void destroyCamera() {
	_camera = null;
}

Vec2f getCameraPosition() {
	return _camera.viewPosition;
}

void shakeCamera(Vec2f intensity, float duration) {
	if(!_camera)
		return;
	_camera.shake(intensity, duration);
}

void moveCameraTo(Vec2f position, float duration = 0f) {
	if(!_camera)
		return;
	_camera.moveTo(position, duration);
}

class Camera: Widget {
	private {
		View _view;
		Vec2f _lastMousePos, _viewPosition, _shakeIntensity = Vec2f.zero;
		bool _isGrabbed = false;
		Vec4f _clip = Vec4f.zero;
		Timer _shakeTimer, _translationTimer;
		Vec2f _translationOrigin, _translationDestination;
	}

	@property {
		Vec2f viewPosition() { return _view.position; }
		Vec2f viewPosition(Vec2f newPosition) {
			_view.position = newPosition;
			return _viewPosition = newPosition;
		}

		Vec2f viewSize() { return _view.size; }
		Vec2f viewSize(Vec2f newSize) {
			return _view.size = newSize;
		}

		Vec4f clip() { return _clip; }
		Vec4f clip(Vec4f newClip) {
			return _clip = newClip;
		}

		const(View) view() const { return _view; }
	}

	float zoom = 1f;

	this(Vec2f newPosition, Vec2f newSize) {
		_view = new View(newSize);
		_position = newPosition;
		_size = newSize;
		_viewPosition = _view.position;
	}
	
	override void update(float deltaTime) {
        //Mouse movement
		Vec2f delta = (getViewVirtualPos(getMousePos(), _position) - _viewPosition) / _view.size;
		_view.size = _view.size.lerp(_size * zoom, deltaTime * .5f);
		Vec2f delta2 = (getViewVirtualPos(getMousePos(), _position) - _viewPosition) / _view.size;
		_viewPosition += (delta2 - delta) * _view.size;

        //Controller movement
        Vec2f stick = inputRAnalog;
        if(stick.lengthSquared > .1f) {
            _viewPosition += stick * deltaTime * 10f;
        }

		//Translation
		if(_translationTimer.isRunning) {
			_translationTimer.update(deltaTime);			
			_viewPosition = _translationOrigin.lerp(_translationDestination, easeOutSine(_translationTimer.time));
		}

		//clamp
		if(_clip.z > _clip.x) {
			if(_view.size.x > (_clip.z - _clip.x))
				_viewPosition.x = 0f;
			else
				_viewPosition.x = clamp(_viewPosition.x, _clip.x + _view.size.x / 2f, _clip.z - _view.size.x / 2f);
		}
		if(_clip.w > _clip.y) {
			if(_view.size.y > (_clip.w - _clip.y))
				_viewPosition.y = 0f;
			else
				_viewPosition.y = clamp(_viewPosition.y, _clip.y + _view.size.y / 2f, _clip.w - _view.size.y / 2f);
		}

		//Apply post effects
		if(_shakeTimer.isRunning) {
			Vec2f currentShake = -_shakeIntensity + 2f * _shakeIntensity * Vec2f(uniform01(), uniform01());
			_shakeTimer.update(deltaTime);
			_view.position = _viewPosition + currentShake.lerp(Vec2f.zero, _shakeTimer.time);
		}
		else
			_view.position = _viewPosition;
	}

	override void onEvent(Event event) {
		switch(event.type) with(EventType) {
		case MouseDown:
			if(isButtonDown(3)) {
				_isGrabbed = true;
				_lastMousePos = event.position;
			}
			break;
		case MouseUp:
			if(!isButtonDown(3))
				_isGrabbed = false;
			break;
		case MouseUpdate:
			if(_isGrabbed) {
				_viewPosition += (_lastMousePos - event.position) * zoom;
				_lastMousePos = event.position;
			}
			break;
		case MouseWheel:
			if(event.position.y > 0f) {
				if(zoom > .4f)
					zoom -= .25f;
			}
			else {
				if(zoom < 1f) {
					zoom += .25f;
					if(zoom > 1f)
						zoom = 1f;
				}
			}
			break;
		default:
			break;
		}
	}

    override void onSize() {
        _view.renderSize = cast(Vec2u)_size;
    }

	override void draw() {
		_view.draw(_position);
	}

	void shake(Vec2f intensity, float duration) {
		_shakeIntensity = intensity;
		_shakeTimer.start(duration);
	}

	void moveTo(Vec2f pos, float duration) {
		_translationOrigin = _view.position;
		_translationDestination = pos;
		_translationTimer.start(duration);
	}
}