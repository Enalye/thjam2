module th.player;

import grimoire;

import std.algorithm.comparison;

import th.entity;
import th.grid;
import th.input;
import th.shot;
import th.camera;
import th.epoch;

class Player: Entity {
    private {
        Animation _animation;
    }

    bool hasPlayed, canPlay;
    
    this(Vec2i gridPosition, string filePath) {
        _type = Type.Player;
        _animation = Animation(filePath, TimeMode.Loop);
        _animation.start(10f, TimeMode.Loop);
        _animation.scale = Vec2f.one * 0.26f;
        super(gridPosition, null);
        _life = 3;
    }

    override void update(float deltaTime) {
        _animation.update(deltaTime);

        if(isMovement(_direction)) {
            _lastDirection = _direction;
            currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none

            gridPosition = getUpdatedPosition(_direction);
            moveCameraTo(_position, .5f);

            if(isRealInstance(_type) && isOpponent(_type, currentGrid.at(gridPosition))) {
                receiveDamage();
            }
            registerPlayerActionOnEpoch();
        }
        else if(isFire(_direction)) {
            _lastDirection = _direction;
            float angle = angleFromFireDirection(_direction);
            createPlayerShot(_position, Color.red, angle, 5f, 5 * 60f);
            registerPlayerActionOnEpoch();
        }
    }

    override void draw(bool inhibitDraw = false) {
        _animation.draw(_position);
    }

    int arrowIndexFromLastDirection() {
        return max(-1, min(_lastDirection - 1, 4));
    }
}