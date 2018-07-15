module th.obstacle;

import grimoire;
import th.entity;
import th.grid;

enum ObstacleType { TREE, WALL, LAMP, TOMB }

class Obstacle: Entity {
	private {
		const Vec2f treeAnchor = Vec2f(0.5f, 0.8f);
		const string treePath = "cherryTree";

		const Vec2f wallAnchor = Vec2f(0.5f, 0.5f);
		const string wallPath = "wall";
		
		ObstacleType _obstacleType;
	}

	this(Vec2i gridPosition, ObstacleType obstacleType) {
		super(gridPosition);
		_obstacleType = obstacleType;

		string filePath;
		Vec2f anchor;

		final switch(_obstacleType) {
			case ObstacleType.TREE:
				filePath = treePath;
				anchor = treeAnchor;
				break;
			case ObstacleType.WALL:
				filePath = wallPath;
				anchor = wallAnchor;
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

		if(_obstacleType == ObstacleType.WALL) {
			_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
		}

		scale = Vec2f.one;
	}

	override void receiveDamage(int damage = 1) {
		if(_obstacleType != ObstacleType.TREE) {
			_life = 0;
		}
	}

	override void draw(bool inhibitDraw = false) {
		if(isRealInstance(currentGrid.at(gridPosition - Vec2i(0, 1)))) {
			_sprite.color.a = 0.5f;
		} else {
			_sprite.color.a = 1f;
		}

		super.draw(inhibitDraw);
	}
}