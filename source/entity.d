module th.entity;

import grimoire;
import std.stdio;
import th.grid;
import th.input;

alias IndexedArray!(Entity, 50u) EntityArray;

class Entity {
    protected {
	    int _life = 1;

	    Type _type;
	    Vec2i _gridPosition = Vec2i.zero; //Position inside the grid
    	Vec2f _position = Vec2f.zero; //True position in the scene
    	Direction _direction; //Input received current update
    	Direction _lastDirection; //Input received last update
    	Sprite _sprite;
    }

    @property {
    	int life() const { return _life; }
        Vec2f position() const { return _position; }

        Vec2i gridPosition() const { return _gridPosition; }
        Vec2i gridPosition(Vec2i newGridPosition) {
            _gridPosition = newGridPosition;
            _position = getGridPosition(_gridPosition);
            return _gridPosition;
        }

        void direction(Direction direction) {
        	_direction = direction;
        }

        bool collected() const {
        	return (_type == Type.Collected);
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

	this(Vec2i gridPos, string filePath) {
		gridPosition = gridPos;
		currentGrid.set(_type, _gridPosition);

		if(filePath	!= null) {
			_sprite = fetch!Sprite(filePath);
			_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
		}
	}

	void receiveDamage() {
		_life--;
	}

	void removeFromGrid() {
		_type = currentGrid.grid[_gridPosition.x][_gridPosition.y] = Type.OutOfGrid;
	}

	void update(float deltaTime) {}

	void action() {}

	void updateGridState() {
		if(_direction != Direction.NONE) {
			currentGrid.set(_type, gridPosition);
			_direction = Direction.NONE;
		}
	}

    bool checkDirectionValid(Direction direction) {
        return (direction != Direction.NONE) && canUseDirection(direction) &&
            isPositionValid(getUpdatedPosition(direction))
            && !isOpponent(_type, currentGrid.at(gridPosition + vectorFromMovementDirection(direction)));
    }

    void greyOutSprite(Vec2f position) {
    	_position = position;
    	_sprite.color = Color(1f, 1f, 1f, 0.25f);
    }

    void draw(bool inhibitDraw = false) {
    	if(_type != Type.None && !inhibitDraw) {
        	_sprite.draw(position);
    	}
    }
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