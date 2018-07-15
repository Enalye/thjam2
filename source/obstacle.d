module th.obstacle;

import grimoire;
import th.entity;
import th.grid;
import th.shot;

enum ObstacleType { TREE, WALL, LAMP, TOMB, BAMBOO, RIVER }

class Obstacle: Entity {
	private {
		const Vec2f defaultAnchor = Vec2f(0.5f, 0.5f);
		const Vec2f lowAnchor = Vec2f(0.5f, 0.8f);
		
		const string treePath = "cherryTree";
		const string wallPath = "wall";
		const string destroyedWallPath = "destroyedWall";
		const string lampPath = "lamp";
		const string tombPath = "tomb";
		const string bambooPath = "bamboo";
		const string riverPath = "river_down";
		
		ObstacleType _obstacleType;
		Timer _destructionTimer;
		bool _destructionStarted = false;
		bool _tall = false;
	}

	this(Vec2i gridPosition, ObstacleType obstacleType, int id = 0) {
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
				anchor = lowAnchor;
				_tall = true;
				break;
			case ObstacleType.TOMB:
				filePath = tombPath;
				anchor = defaultAnchor;
				break;
			case ObstacleType.BAMBOO:
				filePath = bambooPath;
				anchor = defaultAnchor;
				break;
			case ObstacleType.RIVER:
				filePath = riverPath;
				anchor = defaultAnchor;
				break;
		}

		type = Type.Obstacle;

		if(_obstacleType != ObstacleType.RIVER) {
			chargeSprite(filePath, anchor);
		} else {
			chargeSprite(filePath, anchor, id);
		}

		if(!_tall) {
			_sprite.fit(Vec2f(GRID_RATIO, GRID_RATIO));
		}

		scale = Vec2f.one;
	}

	void chargeSprite(string filePath, Vec2f anchor) {
		_sprite = fetch!Sprite(filePath);
		_sprite.anchor = anchor;
	}

	void chargeSprite(string filePath, Vec2f anchor, int id) {
		Tileset tileset = fetch!Tileset(filePath);
		_sprite = tileset.asSprites()[id];
	}

	override void handleCollision(Shot shot) { }

	override void update(float deltaTime) {
		_destructionTimer.update(deltaTime);

		if(_destructionStarted && !_destructionTimer.isRunning()) {
			_life = 0;
		}

		super.update(deltaTime);
	}

	override void receiveDamage(int damage = 1) {
		if(_obstacleType == ObstacleType.WALL) {
			chargeSprite(destroyedWallPath, defaultAnchor);
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