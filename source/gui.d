module th.gui;

import th.epoch;
import th.input;
import th.player;
import grimoire;

public final class GUI: Widget {
	private {
		Player _player;
		Sprite _heart;
        Sprite[4] _arrows;
        Vec2f[4] _positions;
	}

	this(Player player) {
		_player = player;
        _arrows = new Sprite[4];
        _positions = new Vec2f[4];

        _heart = fetch!Sprite("heart");
        _heart.scale = Vec2f.one * 2;

        _arrows[0] = fetch!Sprite("arrow_up");
        _arrows[1] = fetch!Sprite("arrow_down");
        _arrows[2] = fetch!Sprite("arrow_left");
        _arrows[3] = fetch!Sprite("arrow_right");

        _positions[0] = Vec2f(1176, 50);
        _positions[1] = Vec2f(1176, 88);
        _positions[2] = Vec2f(1138, 88);
        _positions[3] = Vec2f(1214, 88);
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

		float timerBandHeight = 100 * percentageElapsed();
		drawFilledRect(Vec2f(1125, 125), Vec2f(timerBandHeight, 10), Color.white);

		for(int i =0; i < _player.life; ++i) {
			_heart.draw(Vec2f(50 + i * 40, 50));
		}
	}
}