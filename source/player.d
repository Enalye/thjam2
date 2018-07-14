module th.player;

import grimoire;

import std.algorithm.comparison;

import th.camera;
import th.entity;
import th.epoch;
import th.grid;
import th.input;
import th.inventory;
import th.item;
import th.shot;

class Player: Entity {
    private {
        Animation _animation;
        Inventory _inventory;
    }

    bool hasPlayed, canPlay;

    @property {
        void inventory(Inventory inventory) { _inventory = inventory; }
    }
    
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
            moveOnGrid();
            moveCameraTo(_position, .5f);

            if(isRealInstance(_type) && isOpponent(_type, currentGrid.at(gridPosition))) {
                receiveDamage();
            }
            registerPlayerActionOnEpoch();
        }
        else if(isFire(_direction)) {
            _lastDirection = _direction;
            float angle = angleFromFireDirection(_direction);

            bool powerUp = _inventory.hasItem(ItemType.POWER);
            Vec2f shotScale = powerUp ? Vec2f.one * 1.5f : Vec2f.one;
            int damage = powerUp ? 2 : 1;

            createPlayerShot(_position, shotScale, damage, Color.red, angle, 5f, 5 * 60f);
            registerPlayerActionOnEpoch();
        }

        currentGrid.playerPosition = _gridPosition;
    }

    override void draw(bool inhibitDraw = false) {
        _animation.draw(_position);
    }

    int arrowIndexFromLastDirection() {
        return max(-1, min(_lastDirection - 1, 4));
    }
}