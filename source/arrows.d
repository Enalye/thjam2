module th.arrows;

import th.input;
import th.player;
import grimoire;

public final class Arrows: Widget {
	private {
		Player _player;
        Sprite[4] _arrows;
        Vec2f[4] _positions;
	}

	this(Player player) {
		_player = player;
        _arrows = new Sprite[4];
        _positions = new Vec2f[4];

        _arrows[0] = fetch!Sprite("arrow_up");
        _arrows[1] = fetch!Sprite("arrow_down");
        _arrows[2] = fetch!Sprite("arrow_left");
        _arrows[3] = fetch!Sprite("arrow_right");

        _positions[0] = Vec2f(1126, 112);
        _positions[1] = Vec2f(1126, 150);
        _positions[2] = Vec2f(1088, 150);
        _positions[3] = Vec2f(1164, 150);
	}

	override void onEvent(Event event) {}

	override void update(float deltaTime) {}

	override void draw() {
		int indexToGreyOut = _player.arrowIndexFromLastDirection();

		int index = 0;
		foreach(Sprite _arrow; _arrows) {
			if(index == indexToGreyOut) {
				_arrow.color = Color(1f, 1f, 1f, 0.25f);
			} else {
				_arrow.color = Color.white;
			}

			_arrow.draw(_positions[index]);
			++index;
		}
	}
}