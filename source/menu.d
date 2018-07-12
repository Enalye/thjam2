module th.menu;

import grimoire;

import th.game;

void onMainMenu() {
    removeWidgets();

    addWidget(new MainMenu);
}

final private class MainMenu: WidgetGroup {
    private {
        Label _titleLabel;
        VContainer _buttonsContainer;
    }

    this() {
        _position = centerScreen;
        _size = screenSize;
        _titleLabel = new Label("Touhou Jam 2");
        _titleLabel.anchor = Vec2f(.5f, 0f);
        _titleLabel.position = Vec2f(centerScreen.x, 50f);


        _buttonsContainer = new VContainer;
        _buttonsContainer.anchor = Vec2f(0f, .5f);
        _buttonsContainer.position = Vec2f(50f, centerScreen.y);
        auto startGame = new TextButton("Start Game");
        startGame.setCallback("start", this);
        _buttonsContainer.addChild(startGame);
        addChild(_titleLabel);
        addChild(_buttonsContainer);
    }

    override void onEvent(Event event) {
        super.onEvent(event);
        switch(event.type) with(EventType) {
        case Callback:
            if(event.id == "start") {
                startGame();
            }
            break;
        default:
            break;
        }
    }
}