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

    //Called when the player is acting
    void action() {
        _direction = cast(Direction)(uniform!"[]"(cast(int)Direction.UP, cast(int)Direction.RIGHT));
        if(!checkDirectionValid(_direction)) {
            _lastDirection = _direction;
            return;
        }
        if(isMovement(_direction)) {
            _lastDirection = _direction;
            currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none

            gridPosition = getUpdatedPosition(_direction);
        }
        _direction = cast(Direction)(uniform!"[]"(cast(int)Direction.FIRE_UP, cast(int)Direction.FIRE_RIGHT));
        if(isFire(_direction)) {
            _lastDirection = _direction;
            float angle = angleFromFireDirection(_direction);
            createEnemyShot(_position, Color.blue, angle, 5f, 5 * 60f);
        }
    }

    /*override void draw() {
        _sprite.draw(position);
    }*/
}