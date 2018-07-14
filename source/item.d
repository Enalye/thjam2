module th.item;

import grimoire;

import th.entity;
import th.grid;
import th.player;
import th.inventory;

enum ItemType { POWER, SCORE, BOMB, HAKKERO, GAP, FLIP, STOPWATCH, COUNT }

private string getItemFilePath(ItemType itemType) {
	string filePath = null;
	switch(itemType) {
		case ItemType.POWER:
		filePath = "power";
		break;
		case ItemType.BOMB:
		filePath = "unfired_bomb";
		break;
		default:
		filePath = null;
		break;
	}

	return filePath;
}

class Item: Entity {
	private ItemType _itemType;
	private Vec2f _uncollectedScale;

	@property {
		int itemType() const { return _itemType; }
	}

	this(Vec2i gridPosition, ItemType itemType, Vec2f uncollectedScale) {
		super(gridPosition, getItemFilePath(itemType));
		_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
		type = Type.Item;
		_itemType = itemType;
		_uncollectedScale = uncollectedScale;
	}

	override void update(float deltaTime) {
		if(!collected && isRealInstance(type) && (currentGrid.playerPosition == _gridPosition)) {	
			removeFromGrid();
			collected = true;
		}

		updateGridState();
	}

	override void draw(bool fromWidget) {
		if(collected && fromWidget) {
			scale = Vec2f.one;
			super.draw();
		}

		if(!collected && !fromWidget) {
			scale = _uncollectedScale;
			super.draw();
		}
	}
}