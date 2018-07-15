module th.obstacle;

import grimoire;
import th.entity;
import th.grid;

enum ObstacleType { TREE, WALL, LAMP, TOMB }

class Obstacle: Entity {
	const Vec2f treeAnchor = Vec2f(0.5f, 0.8f);
	const string treePath = "cherryTree";

	this(Vec2i gridPosition, ObstacleType obstacleType) {
		super(gridPosition);
		string filePath;
		Vec2f anchor;

		final switch(obstacleType) {
			case ObstacleType.TREE:
				filePath = treePath;
				anchor = treeAnchor;
				break;
			case ObstacleType.WALL:
				filePath = treePath;
				anchor = treeAnchor;
				break;
			case ObstacleType.LAMP:
				filePath = treePath;
				anchor = treeAnchor;
				break;
			case ObstacleType.TOMB:
				filePath = treePath;
				anchor = treeAnchor;
				break;
		}

		type = Type.Obstacle;
		_sprite = fetch!Sprite(filePath);
		_sprite.anchor = anchor;
		scale = Vec2f.one;
	}
}