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
    	bool _debug = false;
    	bool _resetDirectionAuto = true;
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

        Type type(Type type) {
        	_type = type;
        	currentGrid.set(_type, _gridPosition);
        	return _type;
        }

        void direction(Direction direction) {
        	_direction = direction;
        }

        bool collected() const {
        	return (_type == Type.Collected);
        }

        bool isAlive() const { return _life > 0; }

        Vec2i getUpdatedPosition(Direction direction) {
			return gridPosition + vectorFromMovementDirection(direction);
		}

		bool canUseDirection(Direction direction) {
			return direction != _lastDirection;
		}
    }

	this(Vec2i gridPos, string filePath) {
		gridPosition = gridPos;

		if(filePath	!= null) {
			_sprite = fetch!Sprite(filePath);
			_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
		}
	}

	void receiveDamage(int damage = 1) {
		_life -= damage;
	}

	protected void moveOnGrid() {
		if(_debug) {
	        writeln("Last direction ", _lastDirection, " current direction ", _direction);
	    }

		_lastDirection = _direction;
        currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none
        gridPosition = getUpdatedPosition(_direction);

        if(_debug) {
	        writeln("Moving to ", gridPosition, " on tile with type ", currentGrid.at(gridPosition));
	    }
	}

	void removeFromGrid() {
		_type = currentGrid.grid[_gridPosition.x][_gridPosition.y] = Type.OutOfGrid;
	}

	void update(float deltaTime) {}

	void action() {}

	void updateGridState() {
		if(_direction != Direction.NONE) {
			currentGrid.set(_type, gridPosition);

			if(_resetDirectionAuto) {
				_direction = Direction.NONE;
			}
		}
	}

    bool checkDirectionValid(Direction direction) {
		bool canMove = (direction != Direction.NONE) && isPositionValid(getUpdatedPosition(direction)); 
		if(_debug) { writeln(canMove ? "can move!" : "cannot move !"); }
		return canMove;
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