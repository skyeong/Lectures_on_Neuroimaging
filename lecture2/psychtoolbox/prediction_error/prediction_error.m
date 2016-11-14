%--------------------------------------------------------------------------
% Clear the workspace and the screen
%--------------------------------------------------------------------------
sca;
close all;
clearvars;


%--------------------------------------------------------------------------
% Create experimental meta data
%--------------------------------------------------------------------------
subj = struct();
subj.name = input('Enter subject''s ID: ','s');
if isempty(subj.name)
    subj.name = 'test';
end



%--------------------------------------------------------------------------
% Set Path
%--------------------------------------------------------------------------
lecturepath = '/Volumes/JetDrive/workshops/Matlab/lecture2/psychtoolbox/';
PEpath      = fullfile(lecturepath,'prediction_error');
addpath(fullfile(lecturepath,'utils'));
addpath(fullfile(lecturepath,'init'));



%--------------------------------------------------------------------------
% Initialize and default setting
%--------------------------------------------------------------------------
% screenSize = 'full';
screenSize = [1024,768];   % Set screen size
load_standard_colors;      % Load standard colors
PsychDefaultSetup(2);      % default settings for Psychtoolbox
init_screen_setting;       % Set screen setting
init_keyresponse_setting;  % Set keyresponse setting



%--------------------------------------------------------------------------
% Create directories to save resulting files
%--------------------------------------------------------------------------
RESPpath = fullfile(PEpath,'RESP'); mkdir(RESPpath);



%--------------------------------------------------------------------------
% Load sequence information
%--------------------------------------------------------------------------
fn_sequence = fullfile(PEpath,'sequence1.mat');  % location of sequence1.mat
load(fn_sequence);
nBlocks = length(block);

stimulusDuration = 0.5;
outcomeDuration  = 1.0;
maxResponseTime  = 2.0;


%--------------------------------------------------------------------------
% Show instruction
%--------------------------------------------------------------------------
str_messages = 'Are you Ready? \n\nPress any key to start!';
show_message_on_screen(str_messages, windowRect, windowPtr, [], [], black, gray);
KbWait([], 2);


%--------------------------------------------------------------------------
% Show a loading screen while waiting a Trigger signal from MRI
%--------------------------------------------------------------------------
show_message_on_screen('Initializing...', windowRect, windowPtr, [], 2, black, gray);


%--------------------------------------------------------------------------
% Additional setting before showing eventInfos
%--------------------------------------------------------------------------
Priority(topPriorityLevel);
ListenChar(2);



%--------------------------------------------------------------------------
% Run #1 (1-3 blocks)
%--------------------------------------------------------------------------
ST = clock;  % Get time stamp
Screen(windowPtr,'TextSize',60);
show_message_on_screen('+', windowRect, windowPtr, [], 2, black, gray);
% Variable initialize
eventInfo = struct();
cnt = 1;
tic;
timePtr = GetSecs;
for i=1:3,
    
    % Get sequence for each block
    prob         = block(i).prob;
    ntrials      = block(i).ntrials;
    stimOrder    = block(i).stimOrder;
    outcomeOrder = block(i).outcomeOrder;
    imageOrder   = block(i).imageOrder;
    ITI          = block(i).ITI;
    
    for j=1:ntrials,
        
        % Stimulus (duration = 0.5 sec)
        imgName = sprintf('A%02d-%s.png',imageOrder(j),stimOrder{j});
        fn_stim = fullfile(PEpath,'images',imgName);
        eventInfo(cnt).trial = cnt;
        eventInfo(cnt).prob = prob;
        eventInfo(cnt).blockid = i;
        eventInfo(cnt).ntrials = ntrials;
        eventInfo(cnt).stimOnset = toc;
        eventInfo(cnt).stimType = stimOrder{j};
        timePtr = show_image_on_screen(fn_stim, windowPtr, timePtr, stimulusDuration, gray);
        
        
        % Prediction (duration = 2 sec)
        eventInfo(cnt).prediction = toc;
        Screen(windowPtr,'TextSize',30);
        show_message_on_screen('(R)eal or (U)nreal ?', windowRect, windowPtr, [], [], black, gray);
        [rtime, resp, timePtr] = get_keyboard_response(timePtr, maxResponseTime);
        eventInfo(cnt).respTime = rtime;
        eventInfo(cnt).keyPressed = resp;
        
        
        % Outcome (duration = 1 sec)
        imgName = sprintf('A%02d-%s.png',imageOrder(j),outcomeOrder{j});
        fn_stim = fullfile(PEpath,'images',imgName);
        eventInfo(cnt).outcomeOnset = toc;
        eventInfo(cnt).outcomeType = outcomeOrder{j};
        timePtr = show_image_on_screen(fn_stim, windowPtr, timePtr, outcomeDuration, gray);
        
        
        % Inter-trial interval (duration ~ 2 sec)
        eventInfo(cnt).ITI = toc;
        Screen(windowPtr,'TextSize',60);
        timePtr = show_message_on_screen('+',windowRect, windowPtr, timePtr, ITI(j), black, gray);
        
        % Count the number of trials
        cnt = cnt+1;
    end
end

% Write eventInfo and Responses
subj.time = sprintf('%04d-%02d-%02d %02dj%02dm%02ds',fix(clock));
fn_experiment = fullfile(RESPpath,sprintf('%s-run1-%s.csv', subj.name, subj.time));
write_to_csvfile(fn_experiment,eventInfo);



%--------------------------------------------------------------------------
% Inter-session interval
%--------------------------------------------------------------------------
Screen(windowPtr,'TextSize',30);
str_messages = '-End of Run #1-';
show_message_on_screen(str_messages, windowRect, windowPtr, [], 2, black, gray);
str_messages = 'You did a good job! \n\nPress any key to proceed the second round';
show_message_on_screen(str_messages, windowRect, windowPtr, [], [], black, gray);
KbWait([], 2);



%--------------------------------------------------------------------------
% Run #2 (4-6 blocks)
%--------------------------------------------------------------------------
Screen(windowPtr,'TextSize',60);
show_message_on_screen('+', windowRect, windowPtr, [], 2, black, gray);
% Variable initialize
eventInfo = struct();
RESP = struct();
cnt = 1;
tic;
timePtr = GetSecs;
for i=4:6,
    
    % Get sequence for each block
    prob         = block(i).prob;
    ntrials      = block(i).ntrials;
    stimOrder    = block(i).stimOrder;
    outcomeOrder = block(i).outcomeOrder;
    imageOrder   = block(i).imageOrder;
    ITI          = block(i).ITI;
    
    
    for j=1:ntrials,
        
        % Stimulus (duration = 0.5 sec)
        imgName = sprintf('A%02d-%s.png',imageOrder(j),stimOrder{j});
        fn_stim = fullfile(PEpath,'images',imgName);
        eventInfo(cnt).trial = cnt;
        eventInfo(cnt).prob = prob;
        eventInfo(cnt).blockid = i;
        eventInfo(cnt).ntrials = ntrials;
        eventInfo(cnt).stimOnset = toc;
        eventInfo(cnt).stimType = stimOrder{j};
        timePtr = show_image_on_screen(fn_stim, windowPtr, timePtr, stimulusDuration, gray);
        
        
        % Prediction (duration = 2 sec)
        eventInfo(cnt).prediction = toc;
        Screen(windowPtr,'TextSize',30);
        show_message_on_screen('(R)eal or (U)nreal ?', windowRect, windowPtr, [], [], black, gray);
        [rtime, resp, timePtr] = get_keyboard_response(timePtr, maxResponseTime);
        eventInfo(cnt).respTime = rtime;
        eventInfo(cnt).keyPressed = resp;
        
        
        % Outcome (duration = 1 sec)
        imgName = sprintf('A%02d-%s.png',imageOrder(j),outcomeOrder{j});
        fn_stim = fullfile(PEpath,'images',imgName);
        eventInfo(cnt).outcomeOnset = toc;
        eventInfo(cnt).outcomeType = outcomeOrder{j};
        timePtr = show_image_on_screen(fn_stim, windowPtr, timePtr, outcomeDuration, gray);
        
        
        % Inter-trial interval (duration ~ 2 sec)
        eventInfo(cnt).ITI = toc;
        Screen(windowPtr,'TextSize',60);
        timePtr = show_message_on_screen('+',windowRect, windowPtr, timePtr, ITI(j), black, gray);
        
        % Count the number of trials
        cnt = cnt+1;
    end
end

%--------------------------------------------------------------------------
%  Write eventInfo and Responses
%--------------------------------------------------------------------------
fn_experiment = fullfile(RESPpath,sprintf('%s-run2-%s.csv', subj.name, subj.time));
write_to_csvfile(fn_experiment,eventInfo);



%--------------------------------------------------------------------------
% End-of-experiment
%--------------------------------------------------------------------------
str_messages = '-End of Run #2-';
show_message_on_screen(str_messages, windowRect, windowPtr, [], 2, black, gray);
str_messages = 'Thank you for your participantion^^';
Screen(windowPtr,'TextSize',30);
show_message_on_screen(str_messages, windowRect, windowPtr, [], 2, black, gray);


Priority(0);
ListenChar(0);

% Clear the screen
sca;


elapsedtime = toc;
ET = clock;
fprintf('=======================================================================\n');
fprintf('    Started Time : %g-%g-%g  %g:%g:%d \n', round(ST));
fprintf('        End Time : %g-%g-%g  %g:%g:%d \n', round(ET));
fprintf('    Elapsed Time : %g min. (%g sec.)\n',elapsedtime/60, elapsedtime);
fprintf('=======================================================================\n\n');

