module th.epoch;

import grimoire;

private {
    static const float TIMEOUT = 0.5f;
    static const float TRANSITION = 0.1f;
    Timer _timeoutTimer, _lockTimer;
    bool _hasPlayerPlayed;
}

float percentageElapsed() {
    //writeln(_lockTimer.time);
    return 1f - _timeoutTimer.time;
}

float transitionTime() {
    if(!_lockTimer.isRunning)
        return 1f;
    return _lockTimer.time;
}

void startEpoch() {
    _timeoutTimer.start(TIMEOUT);
    _lockTimer.start(TRANSITION);
    _hasPlayerPlayed = false;
}

void updateEpoch(float deltaTime) {
    if(isEpochTimedout()) {
        startEpoch();
    } else if(isTransitionTimedOut()) {
        
    }

    _lockTimer.update(deltaTime);
    _timeoutTimer.update(deltaTime);
}

bool lockTimerRunning() {
    return _lockTimer.isRunning;
}

bool canActEpoch() {
    return (!_lockTimer.isRunning && _timeoutTimer.isRunning) && !_hasPlayerPlayed;
}

bool isEpochTimedout() {
    return (!_timeoutTimer.isRunning) || _hasPlayerPlayed;
}

bool isTransitionTimedOut() {
    return !_lockTimer.isRunning;
}

void registerPlayerActionOnEpoch() {
    _hasPlayerPlayed = true;
}