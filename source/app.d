import std.stdio;

import grimoire;
import th.entity;

import th.menu;

void main() {
    try {
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
    catch(Exception e) {
        writeln(e.msg);
    }
}

void onStage1() {
	Stage stage1 = new Stage(Vec2u(5, 7));
	stage1.addEnemyData(Vec2u(0, 5));
}