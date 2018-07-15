module th.menu;

import grimoire;

import th.game;
import th.sound;
import derelict.sdl2.sdl;

void onMainMenu() {
    removeWidgets();
    addWidget(new MainMenu);
}

void onGameOver() {
    removeWidgets();
    addWidget(new GameOverScreen);
}

void onVictory() {
    removeWidgets();
    addWidget(new VictoryScreen);
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
        playMusic("menu");
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

final private class GameOverScreen: Widget {
    private {
        Sprite _gameOverSprite;
        Timer _timer, _startTimer;
        bool _isStarting;
    }

    this() {
        _position = centerScreen;
        _size = screenSize;

        _gameOverSprite = fetch!Sprite("title_game_over");

        _timer.start(1.5f, TimeMode.Loop);
        playMusic("menu");
    }

    override void onEvent(Event event) {

    }

    override void update(float deltaTime) {
        if(getKeyDown("start")) {
            _isStarting = true;
            _startTimer.start(1.5f);
        }
        _startTimer.update(deltaTime);
        
        if(_isStarting && !_startTimer.isRunning) {
            onMainMenu();
        }

        _timer.update(deltaTime);
    }

    override void draw() {
        if(_isStarting) {
            _gameOverSprite.color = lerp(Color.white, Color.black, easeInOutSine(_startTimer.time));
        }
        else {
            _gameOverSprite.color = Color.white;
        }

        _gameOverSprite.draw(centerScreen);
    }
}

final private class VictoryScreen: Widget {
    private {
        Sprite _victorySprite;
        Timer _timer, _startTimer;
        bool _isStarting;
    }

    this() {
        _position = centerScreen;
        _size = screenSize;

        _victorySprite = fetch!Sprite("title_victory");

        _timer.start(1.5f, TimeMode.Loop);
        playMusic("menu");
    }

    override void onEvent(Event event) {

    }

    override void update(float deltaTime) {
        if(getKeyDown("start")) {
            _isStarting = true;
            _startTimer.start(1.5f);
        }
        _startTimer.update(deltaTime);
        
        if(_isStarting && !_startTimer.isRunning) {
            onMainMenu();
        }

        _timer.update(deltaTime);
    }

    override void draw() {
        if(_isStarting) {
            _victorySprite.color = lerp(Color.white, Color.black, easeInOutSine(_startTimer.time));
        }
        else {
            _victorySprite.color = Color.white;
        }

        _victorySprite.draw(centerScreen);
    }
}