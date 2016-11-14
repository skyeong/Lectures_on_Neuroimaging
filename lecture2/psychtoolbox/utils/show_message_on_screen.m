function timePtr = show_message_on_screen(str_messages, windowRect, windowPtr, timePtr_prev, duration, txtcolor, bkgcolor)
%SHOW_IMAGE_ON_SCREEN is a function to show image on a screen
%  str_messages  : text message stored in char variable
%  windowPtr     : pointer of window
%  windowRect    : window rectangular
%  timePtr_prev  : pointer of time stamp 
%  duration      : duration of presentation
%  bkgcolor      : background color
%  
%  Example)
%    fn_image = '/Users/skyeong/fix.png';
%    [windowPtr, windowRect] = PsychImaging('OpenWindow', 0, gray);
%    duration = 3;  % to show image for 3 second
%    SHOW_IMAGE_ON_SCREEN(fn_image, windowPtr, [], duration);
%    
%    This function works with two input arguments without duration.
%    SHOW_IMAGE_ON_SCREEN(fn_image, windowPtr);


% Read image file
if nargin<4, timePtr_prev = GetSecs; end;
if isempty(timePtr_prev), timePtr_prev=GetSecs; end;
if nargin<5, duration = []; end;
if nargin<6, txtcolor = [0 0 0]; end
if nargin<7, bkgcolor = [0.5 0.5 0.5]; end


% Create empty rectangular window
Screen('FillRect',windowPtr, bkgcolor, windowRect);

% Draw image into buffer
DrawFormattedText(windowPtr, str_messages, 'center','center', txtcolor);

% Show image on screen
Screen('Flip', windowPtr);


% Duration of visual stimulation
if ~isempty(duration),
    WaitSecs('UntilTime',timePtr_prev + duration);
end

% Update time stamp
timePtr = timePtr_prev + duration;
