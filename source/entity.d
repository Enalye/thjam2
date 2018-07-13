module th.entity;

import grimoire;
import std.stdio;
import th.grid;
import th.input;

alias IndexedArray!(Entity, 50u) EntityArray;

class Entity {
    protected {
	    int _life = 100;

	    Type _type;
	    Vec2i _gridPosition = Vec2i.zero; //Position inside the grid
    	Vec2f _position = Vec2f.zero; //True position in the scene
    	Direction _direction; //Input received current update
    	Direction _lastDirection; //Input received last update
    }

    @property {
        Vec2f position() const { return _position; }

        Vec2i gridPosition() const { return _gridPosition; }
        Vec2i gridPosition(Vec2i newGridPosition) {
            _gridPosition = newGridPosition;
            _position = getGridPosition(_gridPosition);
            return _gridPosition;
        }

        void setDirection(Direction direction) {
        	_direction = direction;
        }

        bool isAlive() const { return _life > 0; }

        Vec2i getUpdatedPosition(Direction direction) {
        	Vec2i potentialDirection = vectorFromMovementDirection(direction);
			return gridPosition + potentialDirection;
		}

		bool canUseDirection(Direction direction) {
			return direction != _lastDirection;
		}
    }

	this() {
	}

	void receiveDamage() {
		_life--;
	}

	void update(float deltaTime) {}

	void updateGridState() {
		if(_direction != Direction.NONE) {
			currentGrid.set(_type, gridPosition);
			_direction = Direction.NONE;
		}
	}

    abstract void draw();
}

class EntityPool {
	EntityArray entities;

	this() {
		entities = new EntityArray;
	}

	void update(float deltaTime) {
		foreach(Entity entity, uint index; entities) {
			entity.update(deltaTime);

			if(!entity.isAlive) {
				entities.markInternalForRemoval(index);
			} else {
				entity.updateGridState();
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