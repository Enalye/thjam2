module th.shot;

import grimoire;
import th.entity;
import th.epoch;

alias ShotArray = IndexedArray!(Shot, 2000);

private {
    ShotArray _playerShots, _enemyShots;
}

class Shot {
    protected {
        Vec2f _position, _velocity;
        Sprite _sprite;
        float _radius = 25f;
        float _time = 0f, _timeToLive = 1f;
        bool _isAlive = true;
        int _damage = 1;
    }

    @property {
        bool isAlive() const { return _isAlive; }

        Vec2f position(Vec2f newPosition) { return _position = newPosition; }
        Vec2f velocity(Vec2f newVelocity) { return _velocity = newVelocity; }
        float timeToLive(float newTTL) { return _timeToLive = newTTL; }
        int damage(int damage) { return _damage = damage; }
    }

    this(string fileName, Color color = Color.white, Vec2f scale = Vec2f.one) {
        _sprite = fetch!Sprite(fileName);
        _sprite.color = color;
        _sprite.scale = scale;
    }

    void update(float deltaTime) {
        if(lockTimerRunning) {
            _position += _velocity * deltaTime;
            _time += deltaTime;
            if(_time > _timeToLive) {
                _isAlive = false;
            }
        }
    }

    void draw() {
        _sprite.draw(_position);
    }

    bool handleCollision(Entity entity) {
        if(entity.position.distance(_position) < _radius) {
            entity.handleCollision(_damage);
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

void createPlayerShot(Vec2f pos, Vec2f scale, int damage, Color color, float angle, float speed, float timeToLive) {
    auto shot = new Shot("shot_0", color, scale);
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