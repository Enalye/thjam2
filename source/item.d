module th.item;

import grimoire;

import th.entity;
import th.grid;
import th.player;

enum ItemType { POWER, SCORE, HAKKERO, GAP, YINYANG, FLIP, STOPWATCH, COUNT }

private string getItemFilePath(ItemType itemType) {
	string filePath = "yinyang";
	switch(itemType) {
		case ItemType.YINYANG:
		filePath = "yinyang";
		break;
		default:
		filePath = "yinyang";
		break;
	}

	return filePath;
}

class Item: Entity {
	private Player _player;
	private ItemType _itemType;
	private Sprite _sprite;

	this(Vec2i gridPosition, Player player, ItemType itemType) {
		_player = player;
		_itemType = itemType;
		_type = Type.Item;
		super(gridPosition, getItemFilePath(_itemType));
	}

	override void update(float deltaTime) {
		if(!collected && isRealInstance(_type) && (_player.gridPosition == _gridPosition)) {	
			removeFromGrid();
			_type = Type.Collected;
		}
	}

	override void draw(bool fromWidget) {
		if(collected && fromWidget) {
			super.draw();
		}

		if(!collected && !fromWidget) {
			super.draw();
		}
	}
}

class Inventory: Widget {
	EntityArray _items;

	this(EntityArray items) {
		_items = items;
	}

	override void onEvent(Event event) {}

	override void update(float deltaTime) {
		foreach(Entity _item, uint id; _items) {
			_item.update(deltaTime);
			if(_item.collected) {
				_item.greyOutSprite(Vec2f(50 + id * GRID_RATIO, 50));
			}
		}
	}

	override void draw() {
		foreach(Entity _item; _items) {
			_item.draw(true);
		}
	}
}