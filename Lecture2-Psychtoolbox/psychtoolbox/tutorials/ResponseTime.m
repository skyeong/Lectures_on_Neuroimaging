% addpath
lecturepath = '/Volumes/JetDrive/workshops/Matlab/lecture2/psychtoolbox/';
addpath(fullfile(lecturepath,'utils'));
addpath(fullfile(lecturepath,'init'));

% Clear the workspace and the screen
sca;
close all;
clearvars;


% Initialize and default setting
screenSize = [800,600];    % Set screen size
load_standard_colors;      % Load standard colors
PsychDefaultSetup(2);      % default settings for Psychtoolbox
init_screen_setting;       % Set screen setting
init_keyresponse_setting;  % Set keyresponse setting



% Text for instructuon screen
Screen(windowPtr,'TextSize',20);
DrawFormattedText(windowPtr,'Example for getting keyboard response time.\n\n Press Enter key to continue.','center','center',black);
Screen('Flip',windowPtr);
KbWait([], 2);

% Show a loading screen while creating graphics
DrawFormattedText(windowPtr,'Start!','center','center',black);
Screen('Flip',windowPtr);


% Run until a key is pressed
cnt = 1;
color = [1 1 1];

RT_list = nan(10,1);
key_list = '';
ListenChar(2);
while cnt<11
    
    % Jitters
    WaitSecs(rand*2 +2);  % jitters pre-stim interval between .5 and 1.5 seconds
    
    % Check the keyboard to see if a button has been pressed
    rndImg      = rand(200,200,3)*255; % creates random colored image
    rndImagePtr = Screen('MakeTexture', windowPtr, rndImg); % makes texture
    Screen('DrawTexture', windowPtr, rndImagePtr, []);   % draws to backbuffer
    
    % Calculate response time
    starttime = Screen('Flip',windowPtr);      % swaps backbuffer to frontbuffer
    endtime = KbWait([], 2);
    [isKeyDown, t, keyCode] = KbCheck;
    RT_list(cnt)   = (endtime-starttime)*1000; % in ms unit
    key_list{cnt}  = KbName(keyCode);
    
    % makes feedback string
    RTtext = sprintf('Response Time = %1.2f msecs',(endtime-starttime)*1000);
    DrawFormattedText(windowPtr,RTtext, 'center' ,'center', [255 0 255]); % shows RT
    vbl = Screen('Flip',windowPtr); % swaps backbuffer to frontbuffer
    Screen('Flip',windowPtr,vbl+1); % erases feedback after 1 second
    cnt = cnt+1;
end
ListenChar(0);
sca;   % Closes Screen 





