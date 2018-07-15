module th.obstacle;

import grimoire;
import th.entity;
import th.grid;

enum ObstacleType { TREE, WALL, LAMP, TOMB }

class Obstacle: Entity {
	private {
		const Vec2f defaultAnchor = Vec2f(0.5f, 0.5f);
		const Vec2f lowAnchor = Vec2f(0.5f, 0.8f);
		
		const string treePath = "cherryTree";
		const string wallPath = "wall";
		const string lampPath = "lamp";
		const string tombPath = "tomb";
		
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
				anchor = lowAnchor;
				break;
			case ObstacleType.WALL:
				filePath = wallPath;
				anchor = defaultAnchor;
				break;
			case ObstacleType.LAMP:
				filePath = lampPath;
				anchor = defaultAnchor;
				break;
			case ObstacleType.TOMB:
				filePath = tombPath;
				anchor = defaultAnchor;
				break;
		}

		type = Type.Obstacle;
		_sprite = fetch!Sprite(filePath);
		_sprite.anchor = anchor;

		if(_obstacleType != ObstacleType.TREE) {
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
		Type behindType = currentGrid.at(gridPosition - Vec2i(0, 1));
		if(isRealInstance(behindType) && behindType != Type.Obstacle) {
			_sprite.color.a = 0.5f;
		} else {
			_sprite.color.a = 1f;
		}

		super.draw(inhibitDraw);
	}
}