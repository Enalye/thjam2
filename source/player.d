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
import th.game;
import th.sound;
import th.menu;

Player player;

class Player: Entity {
    private {
        Animation _walkUpAnimation, _walkDownAnimation, _walkLeftAnimation, _walkRightAnimation;
        Inventory _inventory;
        Timer _spawnTimer;
    }

    bool canPlay, isSpawning;

    @property {
        void inventory(Inventory inventory) { _inventory = inventory; }
    }
    
    this(Vec2i gridPosition, string filePath) {
        super(gridPosition);
        _sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
        type = Type.Player;

        _walkUpAnimation = Animation("player_walk_up", TimeMode.Loop);
        _walkDownAnimation = Animation("player_walk_down", TimeMode.Loop);
        _walkLeftAnimation = Animation("player_walk_left", TimeMode.Loop);
        _walkRightAnimation = Animation("player_walk_right", TimeMode.Loop);

        _life = 3;
        onRespawn();
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
        type = Type.Player; // set type of current tile to player at each frame

        _spawnTimer.update(deltaTime);
        _walkUpAnimation.update(deltaTime);
        _walkDownAnimation.update(deltaTime);
        _walkLeftAnimation.update(deltaTime);
        _walkRightAnimation.update(deltaTime);

        if(!_spawnTimer.isRunning && isSpawning) {
            moveCameraTo(_newPosition, 1f);
            isSpawning = false;
        }
        
        if(canPlay && !isSpawning) {
            if(isMovement(_direction)) {
                moveOnGrid();
                moveCameraTo(_newPosition, .5f);
                registerPlayerActionOnEpoch();
                playSound(SoundType.Step);
                if(_gridPosition == currentGrid.goalPos) {
                    writeln("Stage Clear");
                    isSpawning = true;
                    _spawnTimer.start(2f);
                    onNextLevel();
                }
            }
            else if(isFire(_direction)) {
                _lastDirection = _direction;
                float angle = angleFromFireDirection(_direction);

                bool powerUp = _inventory.hasItem(ItemType.POWER);
                Vec2f shotScale = powerUp ? Vec2f.one * 1.5f : Vec2f.one;
                int damage = powerUp ? 3 : 1;

                createPlayerShot(_direction, _position, shotScale, damage, Color.red, angle, 15f, 5 * 60f);
                registerPlayerActionOnEpoch();
            }
            else if(Direction.SPACE) {
                auto pos = getUpdatedPosition(moveFromFireDirection(_lastDirection));
                if(isPositionValid(pos)) {
                    if(_inventory.hasItem(ItemType.BOMB)) {
                        enemies.push(new Bomb(pos));
                        playSound(SoundType.Drop);
                    }
                }
            }
        }

        currentGrid.playerPosition = _gridPosition;
    }

    override void handleCollision(Shot shot) {
        super.handleCollision(shot);     
    }

    override void receiveDamage(int damage = 1) {
        if(isSpawning) {
            return;
        }
        
        //Respawn
        _inventory.reset();

        playSound(SoundType.Hurt);
        isSpawning = true;
        currentGrid.set(Type.None, gridPosition);
        gridPosition = currentGrid.spawnPos;
        _spawnTimer.start(2f);
        shakeCamera(Vec2f.one * 25f, 1.5f);
        _lastDirection = Direction.RIGHT;
        onRespawn();

        super.receiveDamage(damage);

        if(_life < 0) {
            onGameOver();
        }
    }

    override void draw(bool inhibitDraw = false) {
        if(isSpawning)
            return;

        final switch(_lastDirection) with(Direction) {
        case NONE:
            _walkRightAnimation.draw(_position);
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
        return max(-1, min(_lastDirection - 1, 8));
    }
}