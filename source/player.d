module th.player;

import grimoire;

import std.algorithm.comparison;

import th.entity;
import th.grid;
import th.input;
import th.shot;

class Player: Entity {
    private {
        Sprite _sprite;
    }
    
    this() {
        _type = Type.Player;

        _sprite = fetch!Sprite("reimu_omg");
        _sprite.anchor = Vec2f.zero;
		_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
    }

    override void update(float deltaTime) {
        if(isMovement(_direction)) {
            _lastDirection = _direction;
            currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none

            gridPosition = getUpdatedPosition(_direction);

            if(isRealInstance(_type) && isOpponent(_type, currentGrid.at(gridPosition))) {
                receiveDamage();
            }
        }

        if(isFire(_direction)) {
            _lastDirection = _direction;
            float angle = angleFromFireDirection(_direction);
            createPlayerShot(_position + Vec2f.one * GRID_RATIO / 2, Color.red, angle, 5f, 5 * 60f);
        }
    }

    override void draw() {
        _sprite.draw(position);
    }

    int arrowIndexFromLastDirection() {
        return max(-1, min(_lastDirection - 1, 4));
    }
}