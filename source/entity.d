module th.entity;

import grimoire;
import th.grid;
import std.stdio;

alias IndexedArray!(Entity, 50u) EntityArray;
alias IndexedArray!(EntityPool, 10u) EntityPoolArray;

class Entity {
	int life;
	Type type;
	bool turnBased; //if false, update is delta based
	Vec2f position; //real world position
	Vec2u gridPosition; //position inside the grid
	Vec2f direction; //direction for next frame e.g. (0, 1) is up

	this(Type tileType, Vec2u pos, Vec2f gridOffset) {
		life = 100;
		type = tileType;
		gridPosition = pos;
		turnBased = true;
		position = Vec2f(gridPosition.x * GRID_RATIO, gridPosition.y * GRID_RATIO) + gridOffset;
		writeln("Position x", position.x, " y ", position.y);
	}

	private void receiveDamage() {
		life--;
	}

	void update(float deltaTime, Grid grid) {
		computeGridPosition();
		grid.set(Type.None, gridPosition); //when going away reset grid data to none

		if(turnBased) {
			position += direction;
		} //todo else

		computeGridPosition();

		if(isRealInstance(type) && isOpponent(type, grid.at(gridPosition))) {
			receiveDamage();
		}
	}

	void updateGridState(Grid grid) {
		grid.set(type, gridPosition);
	}

	void computeGridPosition() {
		gridPosition = Vec2u(cast(int)(position.x / GRID_RATIO), cast(int)(position.y / GRID_RATIO));
	}
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

	void update(float deltaTime, Grid grid) {
		foreach(Entity entity, uint index; entities) {
			entity.update(deltaTime, grid);

			if(entity.life < 0) {
				entities.markInternalForRemoval(index);
			} else {
				entity.updateGridState(grid);
			}
		}

		entities.sweepMarkedData();
	}

	void push(Entity entity) {
		entities.push(entity);
	}

	void draw() {
		foreach(Entity entity; entities) {
			sprite.draw(entity.position);
		}
	}
}