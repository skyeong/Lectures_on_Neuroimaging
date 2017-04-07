function [RT, response, timePtr] = get_keyboard_response(timePtr_prev, duration)

% Show image on screen
endtime = KbWait([], 2, timePtr_prev + duration );
[isKeyDown, t, keyCode] = KbCheck;

if isKeyDown,
    RT = (endtime-timePtr_prev)*1000; % in ms unit
    response = KbName(keyCode);
    WaitSecs('UntilTime', timePtr_prev + duration);
else
    RT = nan;
    response = nan;
end

% Update time stamp
timePtr = timePtr_prev + duration;