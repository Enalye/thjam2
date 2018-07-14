module th.epoch;

import grimoire;

private {
    static const float TIMEOUT = 1.5f;
    Timer _timeoutTimer, _lockTimer;
    bool hasPlayerPlayed;
}

float percentageElapsed() {
    //writeln(_lockTimer.time);
    return 1f - _timeoutTimer.time;
}

void startEpoch() {
    _lockTimer.start(.1f);
    _timeoutTimer.start(TIMEOUT);
    hasPlayerPlayed = false;
}

void updateEpoch(float deltaTime) {
    if(isEpochTimedout()) {
        startEpoch();
    }

    _lockTimer.update(deltaTime);
    _timeoutTimer.update(deltaTime);
}

bool canActEpoch() {
    return (!_lockTimer.isRunning && _timeoutTimer.isRunning) && !hasPlayerPlayed;
}

bool isEpochTimedout() {
    return (!_timeoutTimer.isRunning) || hasPlayerPlayed;
}

void registerPlayerActionOnEpoch() {
    hasPlayerPlayed = true;
}