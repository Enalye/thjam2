import std.stdio;

import grimoire;

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