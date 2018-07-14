module th.player;

import grimoire;

import std.algorithm.comparison;

import th.bomb;
import th.camera;
import th.entity;
import th.epoch;
import th.grid;
import th.input;
import th.inventory;
import th.item;
import th.shot;

Player player;

class Player: Entity {
    private {
        Animation _walkUpAnimation, _walkDownAnimation, _walkLeftAnimation, _walkRightAnimation;
        Inventory _inventory;
    }

    bool canPlay;

    @property {
        void inventory(Inventory inventory) { _inventory = inventory; }
    }
    
    this(Vec2i gridPosition, string filePath) {
        super(gridPosition, null);
        type = Type.Player;

        _walkUpAnimation = Animation("player_walk_up", TimeMode.Loop);
        _walkDownAnimation = Animation("player_walk_down", TimeMode.Loop);
        _walkLeftAnimation = Animation("player_walk_left", TimeMode.Loop);
        _walkRightAnimation = Animation("player_walk_right", TimeMode.Loop);

        _life = 3;
    }

    override void update(float deltaTime) {
        _walkUpAnimation.update(deltaTime);
        _walkDownAnimation.update(deltaTime);
        _walkLeftAnimation.update(deltaTime);
        _walkRightAnimation.update(deltaTime);
        
        if(canPlay) {
            if(isMovement(_direction)) {
                moveOnGrid();
                moveCameraTo(_position, .5f);
                registerPlayerActionOnEpoch();
            }
            else if(isFire(_direction)) {
                _lastDirection = _direction;
                float angle = angleFromFireDirection(_direction);

                bool powerUp = _inventory.hasItem(ItemType.POWER);
                Vec2f shotScale = powerUp ? Vec2f.one * 1.5f : Vec2f.one;
                int damage = powerUp ? 2 : 1;

                createPlayerShot(_position, shotScale, damage, Color.red, angle, 15f, 5 * 60f);
                registerPlayerActionOnEpoch();
            }
            else if(Direction.SPACE && _inventory.hasItem(ItemType.BOMB)) {
                enemies.push(new Bomb(getUpdatedPosition(_lastDirection)));
            }
        }

        currentGrid.playerPosition = _gridPosition;
    }

    override void draw(bool inhibitDraw = false) {
        final switch(_lastDirection) with(Direction) {
        case NONE:
            _walkDownAnimation.draw(_position);
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
        case SPACE:
        }
    }

    int arrowIndexFromLastDirection() {
        return max(-1, min(_lastDirection - 1, 4));
    }
}