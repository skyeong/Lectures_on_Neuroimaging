function [signal, time, ScanStartTime] = siemens_PPOload(fname,varargin)

%
% A loader for the PulseOx data coming off of the Siemens Trio system.
%
%   INPUT:
%   fname = name of text file with respiration information
%   opts        = options on extracting the ECG signal
%
%     a) 'Hz': Sampling Rate of the signal (50Hz default)
%
%     b) 'TR': Sampling rate of scans (2000ms default)
%
%     c) 'iPatOn': whether or not parallel imaging is on (default true)
%
%     d) 'EndClip': Lag time to stop the physio recording (2040ms default)
%
%   OUTPUT
%   ppo   = vector of the pulse-ox waveform
%   time  = vector of timestamps (in seconds)
%
%
% Written by T. Verstynen (November 2007);
% Hacked a bit by J Schlerf (August 2008)
%
% Rewritten to optimize loading time taking heavily from code written by V.
% Deshpande and J. Grinstead, Siemens Medical Solutions (March 2009)
%
% Liscensed under the GPL public license (version 3.0)


% If no input given, then get the file
if nargin < 1 | isempty(fname);
    [filename filepath] = uigetfile('*.puls','Get PPO File');
    fname = fullfile(filepath,filename);
end

TR = 2000;   % Acquisition time (for working around dummy scans)
iPatOn = 0;  % If iPat is on, skip an extra TR
EndClip = 1000; % Always seems to take a second and change to finish
Hz = 50;   % Sampling Frequency
DOSAVE = 0; % Saving Flag

if nargin > 1 & ~isempty(varargin)
    for i = 1:2:length(varargin)
        optlabel = varargin{i};
        optvalue = varargin{i+1};
        
        if isnumeric(optvalue); optvalue = num2str(optvalue); end;
        eval(sprintf('%s = %s;',optlabel, optvalue));
        
    end;
end;


fprintf('%2.2f \n', TR);
fclose('all');fid=fopen(fname);
ignore = textscan(fid,'%s',4); %Ignore first 4 values.

data   = textscan(fid,'%u16'); %Read data until end of u16 data.
footer = textscan(fid,'%s');   %Read in remaining data (time stamps and statistics).

%Get time stamps from footer:
for n=1:size(footer{1},1)
    if strcmp(footer{1}(n),'LogStartMDHTime:')  %log start time
        LogStartTime=str2num(footer{1}{n+1});
    end
    if strcmp(footer{1}(n),'LogStopMDHTime:')   %log stop time
        LogStopTime=str2num(footer{1}{n+1});
    end
    if strcmp(footer{1}(n),'LogStartMPCUTime:') %scan start time
        ScanStartTime=str2num(footer{1}{n+1});
    end
    if strcmp(footer{1}(n),'LogStopMPCUTime:')  %scan stop time
        ScanStopTime=str2num(footer{1}{n+1});
    end
end

% Remove the systems own evaluation of triggers.
t_on  = find(data{1} == 5000);  % System uses identifier 5000 as trigger ON
t_off = find(data{1} == 5003);  % System uses identifier 5003 as trigger OFF

% Filter the trigger markers from the data
data_t=transpose(1:length(data{1}));
indx = setdiff(data_t(:),union(t_on,t_off)); %Note: depending on when the scan ends, the last size(t_off)~=size(t_on).
signal = data{1}(indx);
%signal=data{1};
time = (1:length(signal))./Hz;

% Now work around the Dummy Scans
if iPatOn
    SkipTR = [1+floor(3000/TR)]+1; % extra reference scan included
else
    SkipTR = [1+floor(3000/TR)];
end

% Clip the time series to begin and end with the scan.
if TR < 1000
    start = (TR*SkipTR)*(Hz/1000);
    stop  = length(signal) - Hz*floor([length(signal) - EndClip*(Hz/1000)]/Hz);
else
    start = Hz/2+(TR*SkipTR)*(Hz/1000);
    stop  = length(signal) - Hz*floor([length(signal) - EndClip*(Hz/1000)]/Hz) + Hz/2;
end;


% Reset as column vectors;
signal = double(signal(start+1:end-stop)');
signal = signal(:);

time = time(start+1:end-stop);
time = time(:)-time(1);
time = time(:);


% saving, then save
if DOSAVE
    [fpath fname fext] = fileparts(fname);
    save(fullfile(fpath,[fname '.mat']),'signal','time');
end;