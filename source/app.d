import std.stdio;

import grimoire;

import th.menu;
import th.sound;

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

        //Font
        setTextStandardFont(new FontCache(fetch!Font("VeraMono")));
        setTextItalicFont(new FontCache(fetch!Font("VeraMoIt")));
        setTextBoldFont(new FontCache(fetch!Font("VeraMoBd")));
        setTextItalicBoldFont(new FontCache(fetch!Font("VeraMoBI")));
        initializeSound();

        onMainMenu();
        runApplication();
    }
    catch(Exception e) {
        writeln(e.msg);
    }
}