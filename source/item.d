module th.item;

import grimoire;

import th.entity;
import th.grid;
import th.player;
import th.inventory;

enum ItemType { POWER, SCORE, HAKKERO, GAP, YINYANG, FLIP, STOPWATCH, COUNT }

private string getItemFilePath(ItemType itemType) {
	string filePath = null;
	switch(itemType) {
		case ItemType.POWER:
		filePath = "power";
		break;
		case ItemType.YINYANG:
		filePath = "yinyang";
		break;
		default:
		filePath = null;
		break;
	}

	return filePath;
}

class Item: Entity {
	private ItemType _itemType;
	protected bool _collectible = true;

	@property {
		int itemType() const { return _itemType; }
	}

	this(Vec2i gridPosition, ItemType itemType) {
		_itemType = itemType;
		_type = Type.Item;
		super(gridPosition, getItemFilePath(_itemType));
	}

	override void update(float deltaTime) {
		if(!collected && _collectible && isRealInstance(_type) && (currentGrid.playerPosition == _gridPosition)) {	
			removeFromGrid();
			_type = Type.Collected;
		}

		updateGridState();
	}

	override void draw(bool fromWidget) {
		if(collected && fromWidget) {
			_sprite.scale = Vec2f.one;
			super.draw();
		}

		if(!collected && !fromWidget) {
			_sprite.scale = Vec2f.one * 0.5f;
			super.draw();
		}
	}
}