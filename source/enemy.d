module th.enemy;

import grimoire;

import th.stage;
import th.grid;
import th.entity;

class Enemy: Entity {
    private {
        Sprite _sprite;
    }

    this() {
        _type = Type.Enemy;

        _sprite = fetch!Sprite("fairy_default");
        _sprite.anchor = Vec2f.zero;
		_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
    }

    override void update(float deltaTime) {

    }

    //Called when the player is acting
    void action() {

    }

    override void draw() {
        _sprite.draw(position);
    }
}