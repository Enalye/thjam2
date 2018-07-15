module th.shot;

import grimoire;
import th.entity;
import th.epoch;
import th.input;

alias ShotArray = IndexedArray!(Shot, 2000);

private {
    ShotArray _playerShots, _enemyShots;
}

ShotArray playerShots, enemyShots;

class Shot {
    protected {
        Vec2f _position, _velocity;
        Sprite _sprite;
        float _radius = 25f;
        float _time = 0f, _timeToLive = 1f;
        bool _isAlive = true;
        int _damage = 1;
        Direction _direction;
    }

    @property {
        bool isAlive() const { return _isAlive; }
        Direction direction() const{ return _direction; }
        int damage() const { return _damage; }

        Vec2f position(Vec2f newPosition) { return _position = newPosition; }
        Vec2f velocity(Vec2f newVelocity) { return _velocity = newVelocity; }
        float timeToLive(float newTTL) { return _timeToLive = newTTL; }
        int damage(int damage) { return _damage = damage; }
    }

    this(string fileName, Color color = Color.white, Vec2f scale = Vec2f.one, Direction direction = Direction.NONE) {
        _sprite = fetch!Sprite(fileName);
        _sprite.color = color;
        _sprite.scale = scale;
        _direction = direction;
    }

    void update(float deltaTime) {
        _position += _velocity * deltaTime;
        _time += deltaTime;
        if(_time > _timeToLive) {
            _isAlive = false;
        }
    }

    void draw() {
        _sprite.draw(_position);
    }

    bool handleCollision(Entity entity) {
        if(entity.position.distance(_position) < _radius) {
            entity.handleCollision(this);
            _isAlive = false;
            return true;
        }
        return false;
    }
}

ShotArray createPlayerShotArray() {
    return _playerShots = new ShotArray;
}

ShotArray createEnemyShotArray() {
    return _enemyShots = new ShotArray;
}

void createPlayerShot(Direction direction, Vec2f pos, Vec2f scale, int damage, Color color, float angle, float speed, float timeToLive) {
    auto shot = new Shot("shot_0", color, scale, direction);
    shot.position = pos;
    shot.velocity = Vec2f.angled(angle) * speed;
    shot.timeToLive = timeToLive;
    shot.damage = damage;
    _playerShots.push(shot);
}

void createEnemyShot(Vec2f pos, Color color, float angle, float speed, float timeToLive) {
    auto shot = new Shot("shot_0", color);
    shot.position = pos;
    shot.velocity = Vec2f.angled(angle) * speed;    
    shot.timeToLive = timeToLive;
    _enemyShots.push(shot);
}