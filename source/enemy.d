module th.enemy;

import std.random;

import grimoire;

import th.grid;
import th.entity;
import th.input;
import th.shot;

class Enemy: Entity {
    private {
        Sprite _sprite;

    }

    this() {
        _type = Type.Enemy;

        _sprite = fetch!Sprite("fairy_default");
		_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
    }

    override void update(float deltaTime) {
        
    }

    //Called when the player is acting
    void action() {
        _direction = cast(Direction)(uniform!"[]"(cast(int)Direction.NONE, cast(int)Direction.FIRE_RIGHT));
        import std.stdio;
        writeln(_direction);
        if(isMovement(_direction)) {
            _lastDirection = _direction;
            currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none

            gridPosition = getUpdatedPosition(_direction);
        }

        if(isFire(_direction)) {
            _lastDirection = _direction;
            float angle = angleFromFireDirection(_direction);
            createEnemyShot(_position, Color.blue, angle, 5f, 5 * 60f);
        }
    }

    override void draw() {
        _sprite.draw(position);
    }
}