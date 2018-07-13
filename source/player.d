module th.player;

import grimoire;

import th.entity;
import th.grid;
import th.input;
import th.stage;

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
        if(_direction != Direction.NONE) {
            _lastDirection = _direction;
            currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none

            gridPosition = getUpdatedPosition(_direction);

            if(isRealInstance(_type) && isOpponent(_type, currentGrid.at(gridPosition))) {
                receiveDamage();
            }
        }
    }

    override void draw() {
        _sprite.draw(position);
    }
}