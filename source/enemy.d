module th.enemy;

import std.random;

import grimoire;

import th.grid;
import th.entity;
import th.input;
import th.shot;
import th.game;

class Enemy: Entity {
    this(Vec2i gridPosition, string filePath) {
        _type = Type.Enemy;
        super(gridPosition, filePath);
    }

    override void update(float deltaTime) {
        
    }

    //Called when the enemy is acting
    override void action() {
        _direction = _lastDirection;
        while(_direction == _lastDirection) {
            _direction = cast(Direction)(uniform!"[]"(cast(int)Direction.UP, cast(int)Direction.FIRE_RIGHT));
        }

        if(isMovement(_direction) && checkDirectionValid(_direction) && canUseDirection(_direction)) {
            moveOnGrid();
        }

        if(isFire(_direction)) {
            float angle = angleFromFireDirection(_direction);
            uint n = 5;
            for(int i = 0; i < 5; ++i) {
                createEnemyShot(_position, Color.blue, angle + i * 360 / n, 5f, 5 * 60f);
            }
        }

        _lastDirection = _direction;
    }

    override bool checkDirectionValid(Direction direction) {
        return (direction != Direction.NONE) && isPositionValid(getUpdatedPosition(direction)) && isTileFreeForEnemy(gridPosition + vectorFromMovementDirection(direction));
    }
}