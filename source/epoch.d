module th.epoch;

import grimoire;

private {
    Timer _timeoutTimer, _lockTimer;
    bool hasPlayerPlayed;
}

void startEpoch() {
    _lockTimer.start(.1f);
    _timeoutTimer.start(1f);
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