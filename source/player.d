module th.player;

import grimoire;

import th.stage;
import th.grid;
import th.entity;

class Player: Entity {
    private {
        Sprite _sprite;
    }
    
    this() {
        _type = Type.Player;

        _sprite = fetch!Sprite("fairy_default");
        _sprite.anchor = Vec2f.zero;
		_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
    }

    override void update(float deltaTime) {
        //Handle inputs
        if(getKeyDown("right")) {
            gridPosition += Vec2i(0, 1);
        }
    }

    override void draw() {
        _sprite.draw(position);
    }
}