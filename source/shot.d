module th.shot;

import grimoire;

alias ShotArray = IndexedArray!(Shot, 2000);

private {
    ShotArray _playerShots, _enemyShots;
}

class Shot {
    private {
        Vec2f _position, _velocity;
        float angle;
        Sprite _sprite;
        float _radius = 25f;
        float _time = 0f, _timeToLive = 1f;
        bool _isAlive = true;
    }

    @property {
        bool isAlive() const { return _isAlive; }

        Vec2f position(Vec2f newPosition) { return _position = newPosition; }
        Vec2f velocity(Vec2f newVelocity) { return _velocity = newVelocity; }
        float timeToLive(float newTTL) { return _timeToLive = newTTL; }

    }

    this() {
        _sprite = fetch!Sprite("shot_0");
    }

    void update(float deltaTime) {
        _position += _velocity * deltaTime;
        _time += deltaTime;
        if(_time > _timeToLive)
            _isAlive = false;
    }

    void draw() {
        _sprite.draw(_position);
    }
}

ShotArray createPlayerShotArray() {
    return _playerShots = new ShotArray;
}

ShotArray createEnemyShotArray() {
    return _enemyShots = new ShotArray;
}

void createPlayerShot(Vec2f pos, float angle, float speed, float timeToLive) {
    auto shot = new Shot;
    shot.position = pos;
    shot.velocity = Vec2f.angled(angle) * speed;
    shot.timeToLive = timeToLive;
    _playerShots.push(shot);
}

void createEnemyShot(Vec2f pos, float angle, float speed, float timeToLive) {
    auto shot = new Shot;
    shot.position = pos;
    shot.velocity = Vec2f.angled(angle) * speed;    
    shot.timeToLive = timeToLive;
    _enemyShots.push(shot);
}