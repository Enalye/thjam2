module th.epoch;

import grimoire;

private {
    Timer _timeoutTimer, _lockTimer;
    bool hasPlayerPlayed;
}

void startEpoch() {
    _lockTimer.start(.25f);
    _timeoutTimer.start(3f);
    hasPlayerPlayed = false;
}

void updateEpoch(float deltaTime) {
    _lockTimer.update(deltaTime);
    _timeoutTimer.update(deltaTime);

    if(isEpochTimedout()) {
        startEpoch();
    }
}

bool canActEpoch() {
    return (!_lockTimer.isRunning && _timeoutTimer.isRunning) && !hasPlayerPlayed;
}

bool isEpochTimedout() {
    return !_timeoutTimer.isRunning || hasPlayerPlayed;
}

void registerPlayerActionOnEpoch() {
    hasPlayerPlayed = true;
}