module th.entity;

import grimoire;
import th.grid;
import std.stdio;

alias IndexedArray!(Entity, 50u) EntityArray;
alias IndexedArray!(EntityPool, 10u) EntityPoolArray;

class Entity {
	int life;
	Type type;
	Vec2i gridPosition; //position inside the grid
	Vec2i direction; //direction for next frame e.g. (0, 1) is up

	this(Type tileType, Vec2i pos) {
		life = 100;
		type = tileType;
		gridPosition = pos;
	}

	private void receiveDamage() {
		life--;
	}

	Vec2i getUpdatedPosition(Vec2i potentialDirection) {
		return gridPosition + potentialDirection;
	}

	void update(float deltaTime) {
		currentGrid.set(Type.None, gridPosition); //when going away reset grid data to none
		gridPosition = getUpdatedPosition(direction);
		direction = Vec2i.zero;

		if(isRealInstance(type) && isOpponent(type, currentGrid.at(gridPosition))) {
			receiveDamage();
		}
	}

	void updateGridState() {
		currentGrid.set(type, gridPosition);
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

	void update(float deltaTime) {
		foreach(Entity entity, uint index; entities) {
			entity.update(deltaTime);

			if(entity.life < 0) {
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
			sprite.draw(currentGrid.computeRealPosition(entity.gridPosition));
		}
	}
}