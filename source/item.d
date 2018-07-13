module th.item;

import grimoire;

import th.entity;
import th.grid;
import th.player;

enum ItemType { POWER, SCORE, HAKKERO, GAP, YINYANG, FLIP, STOPWATCH, COUNT }

class Item: Entity {
	private Player _player;
	private ItemType _itemType;

	this(Player player, Vec2i gridPosition, ItemType itemType) {
		_player = player;
		_itemType = itemType;
		_type = Type.Item;
		super(gridPosition);
	}

	override void update(float deltaTime) {
		if(_player.gridPosition == _gridPosition) {	
			removeFromGrid();
		}
	}

	override void draw() {

	}
}

class Inventory: Widget {
	Sprite[ItemType.COUNT] _itemSprites;
	bool[ItemType.COUNT] hasOnlyOne;

	this() {

	}

	override void onEvent(Event event) {

	}

	override void update(float deltaTime) {}


}