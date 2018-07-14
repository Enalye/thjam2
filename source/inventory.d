module th.inventory;

import grimoire;

import th.entity;
import th.grid;
import th.item;

class Inventory: Widget {
	private {
		EntityArray _items;
	}

	this(EntityArray items) {
		_items = items;
	}

	override void onEvent(Event event) {}

	override void update(float deltaTime) {
		foreach(Entity _entity, uint id; _items) {
			_entity.update(deltaTime);
			if(_entity.collected) {
				_entity.greyOutSprite(Vec2f(50 + id * GRID_RATIO, 125));
			}
		}
	}

	override void draw() {
		foreach(Entity _entity; _items) {
			_entity.draw(true);
		}
	}

	bool hasItem(ItemType itemType) {
		bool found = false;
		foreach(Entity _entity, uint id; _items) {
			Item item = cast(Item)(_entity);
			if(item.collected && (item.itemType == itemType)) {
				_items.markInternalForRemoval(id);
				found = true;
				break;
			}
		}

		_items.sweepMarkedData();
		return found;
	}
}