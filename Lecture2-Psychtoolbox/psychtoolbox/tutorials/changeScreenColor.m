% addpath
lecturepath = '/Volumes/JetDrive/workshops/Matlab/lecture2/psychtoolbox/';
addpath(fullfile(lecturepath,'utils'));
addpath(fullfile(lecturepath,'init'));

% Clear the workspace and the screen
sca;      % Screen clear all
close all;
clearvars;


% Initialize and default setting
screenSize = [800,600];    % Set screen size
load_standard_colors;      % Load standard colors
PsychDefaultSetup(2);      % default settings for Psychtoolbox
init_screen_setting;       % Set screen setting
init_keyresponse_setting;  % Set keyresponse setting


% Text for instructuon screen
% ListenChar(2);
Screen(windowPtr,'TextSize',20);
DrawFormattedText(windowPtr,'Example for changing screen color.\n\n Press any key to continue.','center','center',black);
Screen('Flip',windowPtr);
KbWait([], 2);


% Show a loading screen while creating graphics
DrawFormattedText(windowPtr,'Press r, g, or b to change screen color','center','center',black);
vbl =  Screen('Flip',windowPtr);


% Run until a key is pressed
cnt = 1;
color = [1 1 1];
keypressed = '';
while cnt<10
    
    % Check the keyboard to see if a button has been pressed
    KbWait([], 2);
    [isKeyDown, secs, keyCode] = KbCheck;
    if strcmp(KbName(keyCode),'ESCAPE')
        break;
    elseif strcmp(KbName(keyCode),'r'),
        color = red;
    elseif strcmp(KbName(keyCode),'g')
        color = green;
    elseif strcmp(KbName(keyCode),'b')
        color = blue;
    else
        continue
    end
    
    % Color the screen a specific color
    keypressed{cnt} = KbName(keyCode);
    Screen('FillRect', windowPtr, color);
    
    % Flip to the screen
    Screen('Flip', windowPtr);
    cnt = cnt+1;
end
% ListenChar(0);
sca % Closes Screen (or sca)
