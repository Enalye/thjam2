module th.entity;

import grimoire;
import th.grid;
import std.stdio;

alias IndexedArray!(Entity, 50u) EntityArray;
alias IndexedArray!(EntityPool, 10u) EntityPoolArray;

class Entity {
    enum Direction {
        Up, Right, Down, Left
    }

    protected {
	    int _life = 100;

	    Type _type;
	    Vec2i _gridPosition = Vec2i.zero; //Position inside the grid
    	Vec2f _position = Vec2f.zero; //True position in the scene
    	Direction _direction; //Where the entity is looking
    }

    @property {
        Vec2f position() const { return _position; }

        Vec2i gridPosition() const { return _gridPosition; }
        Vec2i gridPosition(Vec2i newGridPosition) {
            _gridPosition = newGridPosition;
            _position = getGridPosition(_gridPosition);
            return _gridPosition;
        }

        bool isAlive() const { return _life > 0; }
    }

	this() {
	}

	private void receiveDamage() {
		_life--;
	}

	void update(float deltaTime) {

	}

    abstract void draw();
}

class EntityPool {
	EntityArray entities;
	Sprite sprite;

	this(string spriteFileName) {
		entities = new EntityArray;
		sprite = fetch!Sprite(spriteFileName);
		sprite.anchor = Vec2f.zero;
		sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
	}

	void update(float deltaTime) {
		foreach(Entity entity, uint index; entities) {
			entity.update(deltaTime);

			if(!entity.isAlive) {
				entities.markInternalForRemoval(index);
			}
		}

		entities.sweepMarkedData();
	}

	void push(Entity entity) {
		entities.push(entity);
	}

	void draw() {
		foreach(Entity entity; entities) {
			entity.draw();
		}
	}
}