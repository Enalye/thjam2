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
		const string destroyedWallPath = "destroyedWall";
		const string lampPath = "lamp";
		const string tombPath = "tomb";
		
		ObstacleType _obstacleType;
		Timer _destructionTimer;
		bool _destructionStarted = false;
		bool _tall = false;
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
				_tall = true;
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
		changeSprite(filePath, anchor);

		if(_obstacleType != ObstacleType.TREE) {
			_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
		}

		scale = Vec2f.one;
	}

	void changeSprite(string filePath, Vec2f anchor) {
		_sprite = fetch!Sprite(filePath);
		_sprite.anchor = anchor;
	}

	override void update(float deltaTime) {
		_destructionTimer.update(deltaTime);

		if(_destructionStarted && !_destructionTimer.isRunning()) {
			_life = 0;
		}

		super.update(deltaTime);
	}

	override void receiveDamage(int damage = 1) {
		if(_obstacleType == ObstacleType.WALL) {
			changeSprite(destroyedWallPath, defaultAnchor);
			_destructionTimer.start(0.2f);
			_destructionStarted = true;
		}
	}

	override void draw(bool inhibitDraw = false) {
		Type behindType = currentGrid.at(gridPosition - Vec2i(0, 1));
		if(_tall && isRealInstance(behindType) && behindType != Type.Obstacle) {
			_sprite.color.a = 0.5f;
		} else {
			_sprite.color.a = 1f;
		}

		super.draw(inhibitDraw);
	}
}