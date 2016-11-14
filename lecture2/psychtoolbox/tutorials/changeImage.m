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


% Image path
imagePath = '/Volumes/JetDrive/workshops/Matlab/lecture2/psychtoolbox/tutorials/images';



% Text for instructuon screen
Screen(windowPtr,'TextSize',20);
DrawFormattedText(windowPtr,'Example for changing images.\n\n Press any key to continue.','center','center',black);
Screen('Flip',windowPtr);
KbWait([], 2);


% Show a loading screen while creating graphics
DrawFormattedText(windowPtr,'Press [f] for Face and [h] for House image.\n\n Press any key to start.','center','center',black);
Screen('Flip',windowPtr);
KbWait([], 2);


% Run until a key is pressed
cnt = 1;
ListenChar(2);
keypressed = cell(0);
list_RT = [];

% Show a loading screen while creating graphics
DrawFormattedText(windowPtr,'Start!','center','center',black);
t0=Screen('Flip',windowPtr);
Screen(windowPtr,'TextSize',40);
while cnt<10
    
    if cnt==1, t1 = t0; end
    
    %----------------------------------------------------------------------
    % Show cue image
    %----------------------------------------------------------------------
    % Showing crosshairs
    id = randperm(2,1);
    if id==1,
        DrawFormattedText(windowPtr,'#','center','center',black);
        imgname = 'face';
    else
        DrawFormattedText(windowPtr,'&','center','center',black);
        imgname = 'house';
    end
    Screen('Flip',windowPtr);
    WaitSecs('UntilTime',t1 + 1);
    t1 = t1 + 1;  % Update time stamp
    
    
    %----------------------------------------------------------------------
    % Get keyboard responses
    %----------------------------------------------------------------------
    % Showing crosshairs
    DrawFormattedText(windowPtr,'Face vs. House?\n\n(f)           (h)  ','center','center',black);
    Screen('Flip',windowPtr);
    
    % Check the keyboard to see if a button has been pressed
    keyresponse_time = 2;
    endtime = KbWait([], 2, t1 + keyresponse_time );
    [isKeyDown, t, keyCode] = KbCheck;
    
    if isKeyDown,
        RT = (endtime-t1);     % in ms unit
        response = KbName(keyCode); % convert to keyboard layout
        WaitSecs('UntilTime', t1 + keyresponse_time-RT);
    else
        RT = nan;
        response = nan;
    end
    
    % Save keyboard responses
    keypressed{cnt} = response;
    list_RT(cnt) = RT*1000;
    t1 = t1 + keyresponse_time;  % Update time stamp
    
    
    %----------------------------------------------------------------------
    % Show Image
    %----------------------------------------------------------------------
    % Load image
    imgNo = randperm(4,1);
    fn_image = fullfile(imagePath,sprintf('%s-%02d.jpg',imgname,imgNo));
    imageData = imread(fn_image);
    
    % Make the image into a texture
    imageTexture = Screen('MakeTexture', windowPtr, imageData);
    
    % Draw image into buffer
    Screen('DrawTexture', windowPtr, imageTexture, [], [], 0);
    
    % Show image on screen
    Screen('Flip', windowPtr);
    WaitSecs('UntilTime',t1 + 1);
    t1 = t1 + 1;  % Update time stamp
    
    
    %----------------------------------------------------------------------
    % ITI
    %----------------------------------------------------------------------
    % Showing crosshairs
    DrawFormattedText(windowPtr,'+','center','center',black);
    
    Screen('Flip',windowPtr);
    ITI = rand(1,1)*2+1;   % uniform ITI
    WaitSecs('UntilTime',t1 + ITI);
    t1 = t1 + ITI;         % Update time stamp
    
    cnt = cnt+1;
end
ListenChar(0);
sca % Closes Screen (or sca)
