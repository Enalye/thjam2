module th.menu;

import grimoire;

import th.game;
import th.sound;
import derelict.sdl2.sdl;

void onMainMenu() {
    removeWidgets();
    addWidget(new MainMenu);
}

final private class MainMenu: Widget {
    private {
        Sprite _titleSprite, _backgroundSprite, _pressSprite, _reimuSprite;
        Timer _timer, _startTimer;
        bool _isStarting;
    }

    this() {
        _position = centerScreen;
        _size = screenSize;

        _titleSprite = fetch!Sprite("title");
        _backgroundSprite = fetch!Sprite("title_background");
        _pressSprite = fetch!Sprite("title_press");
        _reimuSprite = fetch!Sprite("title_reimu");

        bindKey("start", SDL_SCANCODE_SPACE);
        _timer.start(1.5f, TimeMode.Loop);
    }

    override void onEvent(Event event) {

    }

    override void update(float deltaTime) {
        if(getKeyDown("start")) {
            _isStarting = true;
            _startTimer.start(1.5f);
            playSound(SoundType.Start);
        }
        _startTimer.update(deltaTime);
        
        if(_isStarting && !_startTimer.isRunning) {
            startGame();
        }
        else if(_isStarting) {
            _timer.update(deltaTime * 5f);
        }

        _timer.update(deltaTime);
    }

    override void draw() {
        if(_timer.time < .5f) {
            float t = _timer.time * 2f;
            _pressSprite.color = lerp(Color.white, Color(1f, 1f, 1f, .25f), 1f - easeOutSine(t));
        }
        else {
            float t = (_timer.time - .5f) * 2f;
            _pressSprite.color = lerp(Color.white, Color(1f, 1f, 1f, .25f), easeInSine(t));
        }

        _backgroundSprite.draw(centerScreen);
        _reimuSprite.draw(centerScreen);
        _pressSprite.draw(centerScreen);
        _titleSprite.draw(centerScreen);
    }
}