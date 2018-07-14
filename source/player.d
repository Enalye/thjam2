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
        Animation _walkUpAnimation, _walkDownAnimation, _walkLeftAnimation, _walkRightAnimation;
    }

    bool canPlay;
    
    this(Vec2i gridPosition) {
        _type = Type.Player;
        super(gridPosition);

        _walkUpAnimation = Animation("player_walk_up", TimeMode.Loop);
        _walkDownAnimation = Animation("player_walk_down", TimeMode.Loop);
        _walkLeftAnimation = Animation("player_walk_left", TimeMode.Loop);
        _walkRightAnimation = Animation("player_walk_right", TimeMode.Loop);
    }

    override void update(float deltaTime) {
        _walkUpAnimation.update(deltaTime);
        _walkDownAnimation.update(deltaTime);
        _walkLeftAnimation.update(deltaTime);
        _walkRightAnimation.update(deltaTime);
        
        if(canPlay) {
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
    }

    override void draw() {
        final switch(_lastDirection) with(Direction) {
        case NONE:
            _walkUpAnimation.draw(_position);
            break;
        case UP:
        case FIRE_UP:
            _walkUpAnimation.draw(_position);
            break;
        case DOWN:
        case FIRE_DOWN:
            _walkDownAnimation.draw(_position);
            break;
        case LEFT:
        case FIRE_LEFT:
            _walkLeftAnimation.draw(_position);
            break;
        case RIGHT:
        case FIRE_RIGHT:
            _walkRightAnimation.draw(_position);
            break;
        }
    }

    int arrowIndexFromLastDirection() {
        return max(-1, min(_lastDirection - 1, 4));
    }
}