% Preference of global setting
Screen('Preference', 'VisualDebugLevel', 0);
Screen('Preference', 'SuppressAllWarnings', 0);
Screen('Preference', 'SkipSyncTests', 0);


% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');


% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% Open an on screen window.
if strcmp(screenSize,'full'),
    [windowPtr, windowRect] = PsychImaging('OpenWindow',screenNumber, gray);
else
    if isempty(screenSize),
        screenSize = [800,600];
    end
    [windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, gray,[0 0 screenSize]);
end

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', windowPtr);

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', windowPtr);


% Retreive the maximum priority number and set max priority
topPriorityLevel = MaxPriority(windowPtr);
Priority(topPriorityLevel);


% Here we use to a waitframes number greater then 1 to flip at a rate not
% equal to the monitors refreash rate. For this example, once per second,
% to the nearest frame
flipSecs = 1;
waitframes = round(flipSecs / ifi);


% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


% Flip outside of the loop to get a time stamp
vbl = Screen('Flip', windowPtr);
