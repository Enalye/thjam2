import std.stdio;

import grimoire;
import th.entity;

void main() {
	//Set data location
	setResourceFolder("data/");
	setResourceSubFolder!Texture("graphic");
	setResourceSubFolder!Font("font");
	setResourceSubFolder!Sprite("graphic");
	setResourceSubFolder!Tileset("graphic");
	setResourceSubFolder!Sound("sound");
	setResourceSubFolder!Music("music");
    
	//Initialization
	createApplication(Vec2u(1280, 720), "Touhou Jam 2");

    onMainMenu();
	runApplication();
}

void onMainMenu() {
    removeWidgets();
    auto label = new Label("Hello World !");
    label.position = centerScreen;
    addWidget(label);
}