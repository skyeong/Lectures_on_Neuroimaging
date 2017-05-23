function [signal, time, channel_1, channel_AVF] = siemens_ECGload(fname,varargin)

% function [signal time c1 AVF] = siemens_ECGload(fname, optname, optval);
%
% A loader for the ECG data coming off of the Siemens Trio system.
%
%   INPUT:
%   fname       = name of text file with ECG information
%   opts        = options on extracting the ECG signal
%
%     a) 'OuputType': Flag for signal extraction
%        1) 'v1' -> Only the first electrical vector
%        2) 'v2' -> Only the second electrical vector
%        3) 'mean' -> Average of v1 & v2 (default)
%
%     b) 'Hz': Sampling Rate of the signal (400Hz default)
%
%     c) 'TR': Sampling rate of scans (2000ms default)
%
%     d) 'EndClip': Lag time to stop the physio recording (1040ms default)
%
%
%   OUTPUT
%
%   signal      = vector of data signal
%   time        = real time timestamps (in seconds)
%   c1          = the primary electrical vector channel
%   AVF         = the AVF channel
%
%
% Written by T. Verstynen (November 2007);
%
% Rewritten to optimize loading time taking heavily from code written by V.
% Deshpande and J. Grinstead, Siemens Medical Solutions (March 2009)
%
% Liscensed under the GPL public license (version 3.0)

if nargin < 1 | isempty(fname);
    [filename filepath] = uigetfile('*.ecg','Get ECG File');
    fname = fullfile(filepath,filename);
end

TR = 2000;   % Acquisition time (for working around dummy scans)
iPatOn = 1;  % If iPat is on, skip an extra TR
EndClip = 1000; % Always seems to take a second and change to finish
StartClip = 0; % Some systems have to have a pause between record onset and gradient onset
Hz = 400;   % Sampling Frequency
DOSAVE = 0; % Saving Flag
OutputType = 'mean';  % How to compress the output data

% Get optional input parameters to change any Globals
if nargin > 1 & ~isempty(varargin)
    for i = 1:2:length(varargin)
        optlabel = varargin{i};
        optvalue = varargin{i+1};
        
        if isnumeric(optvalue); optvalue = num2str(optvalue); end;
        eval(sprintf('%s = %s;',optlabel, optvalue));
        
    end;
end;

fclose('all');fid=fopen(fname);
ignore=textscan(fid,'%s',4); %Ignore first 4 values.

%Skip data before '6002' for ECG data.
index=1;IsHeader=1;
while IsHeader==1
    header(index)=textscan(fid,'%s',1);  %textscan() is faster than textread()
    if str2num(header{index}{1})==6002
        IsHeader=0;
    end
    index=index+1;
end

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
t_off = find(data{1} == 6000);  % System uses identifier 6000 as trigger OFF

% Filter the trigger markers from the ECG data
data_t=transpose(1:length(data{1}));
indx = setdiff(data_t(:),union(t_on,t_off)); %Note: depending on when the scan ends, the last size(t_off)~=size(t_on).
data_stream = data{1}(indx);

% Split a single stream of ECG data into channel 1 and channel 2.
channel_1 =   data_stream(1:2:max(size(data_stream))-1);
channel_AVF = data_stream(2:2:max(size(data_stream)));

% Make them the same length and get time estimates.
nsamples = min(length(channel_1),length(channel_AVF));
channel_1 = channel_1(1:nsamples);
channel_AVF= channel_AVF(1:nsamples);
time = (1:nsamples)./Hz;


switch OutputType
    case 'mean'
        signal = mean([channel_1(:) channel_AVF(:)],2);
        
    case 'v1'
        signal = channel_1;
        
    case 'v2'
        signal = channel_AVF;
end;

time = time(:)-time(1);

% Clip the time series to begin and end with the scan.
if iPatOn
    SkipTR = [1+floor(3000/TR)]+1; % extra reference scan included
else
    SkipTR = [1+floor(3000/TR)];
end

start = StartClip*(Hz/1000)+(TR*SkipTR)*(Hz/1000);

% For ECG and RESP there is about a 495ms lag to shut down the recording
% and close file.
stop = EndClip*(Hz/1000)+mod(length(signal(1:end)),Hz);

% Reset vectors;
signal = double(signal(start+1:end-stop));
time = time(start+1:end-stop);
time = time(:)-time(1);

if DOSAVE
    [fpath fname fext] = fileparts(fname);
    save(fullfile(fpath,[fname '.mat']),'signal','time');
end;