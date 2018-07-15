module th.sound;

import grimoire;

enum SoundType {
    Drop, Bounce, Clear, Clear2, Explosion, Kill, Heart, Hurt, Item, Powerup, Shot, Step,
    Max
}

private {
    Sound[SoundType.Max] _sounds;
    Music _music;
}

void initializeSound() {
	createSoundGroup(0, 3);
	createSoundGroup(1, 4);

    uint i;
    foreach(snd; [
        "drop",
        "bounce",
        "clear",
        "clear2",
        "explosion",
        "kill",
        "heart",
        "hurt",
        "item",
        "powerup",
        "shot",
        "step"
    ]) {
        auto sound = fetch!Sound(snd);
        sound.group = (i >= SoundType.Shot) ? 1 : 0;
        sound.volume = .5f;
        _sounds[i] = sound;
        i ++;
    }
}

void playSound(SoundType type) {
    if(type >= SoundType.Max)
        return;
    _sounds[type].play();
}

void playMusic(string name) {
    _music = fetch!Music(name);
    _music.volume = .6f;
    _music.play();   
}