module th.enemy;

import std.random;

import grimoire;

import th.grid;
import th.entity;
import th.input;
import th.shot;
import th.game;

enum EnemyType { FAIRY_PURPLE, FAIRY_GREEN, FAIRY_YELLOW, GHOST, YINYANG, NONE }

class Enemy: Entity {
    private {
        EnemyType _enemyType;
        Animation _walkUpAnimation, _walkDownAnimation, _walkLeftAnimation, _walkRightAnimation;

        int _actionsBeforeShooting = 2;
        bool _shootAuthorized = true;
        float _lastBarRatio = 1f, _lifeRatio = 1f;
        bool _inhibitDraw = false;
    }

    bool showLifebar = true;

    private void getAntimationFromEnemyType() {
        final switch(_enemyType) {
            case EnemyType.FAIRY_PURPLE:
                _walkUpAnimation = Animation("fairyPurple_walk_up", TimeMode.Loop);
                _walkDownAnimation = Animation("fairyPurple_walk_down", TimeMode.Loop);
                _walkLeftAnimation = Animation("fairyPurple_walk_left", TimeMode.Loop);
                _walkRightAnimation = Animation("fairyPurple_walk_right", TimeMode.Loop);
                _inhibitDraw = true;
                break;
            case EnemyType.FAIRY_GREEN:
                _walkUpAnimation = Animation("fairyGreen_walk_up", TimeMode.Loop);
                _walkDownAnimation = Animation("fairyGreen_walk_down", TimeMode.Loop);
                _walkLeftAnimation = Animation("fairyGreen_walk_left", TimeMode.Loop);
                _walkRightAnimation = Animation("fairyGreen_walk_right", TimeMode.Loop);
                _inhibitDraw = true;
                break;
            case EnemyType.FAIRY_YELLOW:
                _walkUpAnimation = Animation("fairyYellow_walk_up", TimeMode.Loop);
                _walkDownAnimation = Animation("fairyYellow_walk_down", TimeMode.Loop);
                _walkLeftAnimation = Animation("fairyYellow_walk_left", TimeMode.Loop);
                _walkRightAnimation = Animation("fairyYellow_walk_right", TimeMode.Loop);
                _inhibitDraw = true;
                break;
            case EnemyType.GHOST:
                _sprite = fetch!Sprite("bakebake");
                break;
            case EnemyType.YINYANG:
                _sprite = fetch!Sprite("yinyang");
                break;
            case EnemyType.NONE:
                break;
        }
    }

    this(Vec2i gridPosition, EnemyType enemyType = EnemyType.NONE, Vec2f spriteScale = Vec2f.one) {
        super(gridPosition);

        type = Type.Enemy;
        _enemyType = enemyType;

        getAntimationFromEnemyType();
        _sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
        scale = spriteScale;
    }

    //Called when the enemy is acting
    override void action() {
        _direction = _lastDirection;
        while(_direction == _lastDirection) {
            _direction = cast(Direction)(uniform!"[]"(cast(int)Direction.UP, cast(int)Direction.FIRE_RIGHT));
        }

        if(isMovement(_direction) && checkDirectionValid(_direction) && canUseDirection(_direction)) {
            moveOnGrid();

            if(!_shootAuthorized) {
                _actionsBeforeShooting--;
                if(_actionsBeforeShooting == 0) {
                    _actionsBeforeShooting = 2;
                    _shootAuthorized = true;
                }
            }
        }

        if(isFire(_direction)) {
            if(_shootAuthorized) {
                float angle = angleFromFireDirection(_direction);
                uint n = 3;
                for(int i = 0; i < n; ++i) {
                    createEnemyShot(_position, Color(0f, 1f, 1f, 0.5f), angle + i * 360 / n, 2.5f, 5 * 60f);
                }
                _shootAuthorized = false;
            }
        }

        _lastDirection = _direction;
    }

    override bool checkDirectionValid(Direction direction) {
        return (direction != Direction.NONE) && isPositionValid(getUpdatedPosition(direction)) && isTileFreeForEnemy(gridPosition + vectorFromMovementDirection(direction));
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
        //Lifebar
        if(showLifebar) {
            _lifeRatio = cast(float)(_life) / _maxLife;
            _lastBarRatio = lerp(_lastBarRatio, _lifeRatio, deltaTime * .1f);
        }
    }

    override void draw(bool inhibitDraw = false) {
        super.draw(_inhibitDraw);

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

        //Lifebar
        if(showLifebar) {
            Vec2f lbPos = _position - Vec2f(0f, 50f);
            Vec2f lbSize = Vec2f(35f, 10f);
            Vec2f lbBorderSize = lbSize + Vec2f(2f, 2f);
            Vec2f lbLifeSize = Vec2f(lbSize.x * _lifeRatio, lbSize.y);
            Vec2f lbLifeSize2 = Vec2f(lbSize.x * _lastBarRatio, lbSize.y);
            drawFilledRect(lbPos - lbBorderSize / 2f, lbBorderSize, Color.white);
            drawFilledRect(lbPos - lbSize / 2f, lbSize, Color.black);
            drawFilledRect(lbPos - lbSize / 2f, lbLifeSize2, Color.white);
            drawFilledRect(lbPos - lbSize / 2f, lbLifeSize, Color.red);
        }
    }
}