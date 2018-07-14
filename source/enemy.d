module th.enemy;

import std.random;

import grimoire;

import th.grid;
import th.entity;
import th.input;
import th.shot;
import th.game;

class Enemy: Entity {
    private bool _shootAuthorized = true;
    private int _actionsBeforeShooting = 2;

    this(Vec2i gridPosition, string filePath = null, Vec2f spriteScale = Vec2f.one) {
        super(gridPosition, filePath);
        type = Type.Enemy;
        scale = spriteScale;
    }

    //Called when the enemy is acting
    override void action() {
        _direction = _lastDirection;
        while(_direction == _lastDirection) {
            _direction = cast(Direction)(uniform!"[]"(cast(int)Direction.UP, cast(int)Direction.FIRE_RIGHT));
        }

        if(isMovement(_direction) && checkDirectionValid(_direction) && canUseDirection(_direction)) {
            moveOnGrid();

            if(!_shootAuthorized) {
                _actionsBeforeShooting--;
                if(_actionsBeforeShooting == 0) {
                    _actionsBeforeShooting = 2;
                    _shootAuthorized = true;
                }
            }
        }

        if(isFire(_direction)) {
            if(_shootAuthorized) {
                float angle = angleFromFireDirection(_direction);
                uint n = 5;
                for(int i = 0; i < 5; ++i) {
                    createEnemyShot(_position, Color.blue, angle + i * 360 / n, 5f, 5 * 60f);
                }
                _shootAuthorized = false;
            }
        }

        _lastDirection = _direction;
    }

    override bool checkDirectionValid(Direction direction) {
        return (direction != Direction.NONE) && isPositionValid(getUpdatedPosition(direction)) && isTileFreeForEnemy(gridPosition + vectorFromMovementDirection(direction));
    }
}