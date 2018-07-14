module th.entity;

import grimoire;
import std.stdio;
import th.grid;
import th.input;
import th.epoch;

EntityArray enemies, items;

alias IndexedArray!(Entity, 50u) EntityArray;

class Entity {
	private Type _type;

    protected {
	    int _life = 5, _maxLife = 5;

	    Vec2i _gridPosition = Vec2i.zero; //Position inside the grid
    	Vec2f _position = Vec2f.zero; //True position in the scene
    	Vec2f _scale = Vec2f.one;
    	Direction _direction; //Input received current update
    	Direction _lastDirection; //Input received last update
    	Sprite _sprite;
    	bool _debug = false;
    	bool _resetDirectionAuto = true;
        Vec2f _newPosition = Vec2f.zero, _lastPosition = Vec2f.zero;
        bool _init = true;
    }

    @property {
    	int life() const { return _life; }
    	bool dead() { return _life <= 0; }
        Vec2f position() const { return _position; }

        Vec2f scale(Vec2f scale) {
        	_scale = _sprite.scale = scale;

        	if(_debug) {
        		writeln("Setting scale ", _scale);
        	}

        	return _scale;
        }

        Vec2i gridPosition() const { return _gridPosition; }
        Vec2i gridPosition(Vec2i newGridPosition) {
            if(_init) {
                _init = false;
                _gridPosition = newGridPosition;
                _position = getRealPosition(_gridPosition);
                _lastPosition = _position;
                _newPosition = _position;
                return _gridPosition;
            }
            _gridPosition = newGridPosition;
            _lastPosition = _position;
            _newPosition = getRealPosition(_gridPosition);
            return _gridPosition;
        }

        Type type() const { return _type; }
        Type type(Type type) {
        	_type = type;
        	currentGrid.set(_type, _gridPosition);
        	return _type;
        }

        Direction direction(Direction direction) {
        	return _direction = direction;
        }

        bool collected() const {
        	return (_type == Type.Collected);
        }

        bool collected(bool isCollected) {
        	if(isCollected) { _type = Type.Collected; }
        	return collected();
        }

        bool isAlive() const { return _life > 0; }
    }

	this(Vec2i gridPos, string filePath = null) {
		gridPosition = gridPos;

		if(filePath	!= null) {
			_sprite = fetch!Sprite(filePath);
			scale = Vec2f.one;
		}
	}

	void handleCollision(int damage = 1) {
 		receiveDamage(damage);
	}

	private void receiveDamage(int damage) {
		_life -= damage;
	}

	Vec2i getUpdatedPosition(Direction direction) {
		return gridPosition + vectorFromMovementDirection(direction);
	}

	Type getNextTileType(Direction direction) {
		Vec2i nextTilePosition = getUpdatedPosition(direction);
		return currentGrid.grid[nextTilePosition.x][nextTilePosition.y];
	}

	bool canUseDirection(Direction direction) {
		return direction != _lastDirection;
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

	void update(float deltaTime) {
        if(transitionTime() >= 1f) {
            _lastPosition = _newPosition;
            _position = _newPosition;
        }
        else {
            _position = lerp(_lastPosition, _newPosition, easeInOutSine(transitionTime()));
        }
    }

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