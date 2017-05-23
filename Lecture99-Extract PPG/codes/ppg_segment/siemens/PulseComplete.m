function  PulseComplete(name,type,TRi,HRrate,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pulse Covariate generator
%
% Inputs:
%         type - Either 'single', 'multi', or 'both'
%             This term specifies whether a single concatenated output or
%             multiple outputs are desired
%         TR - the TR interval used in for the scan
%       HRrate - 0 for high average heartrate (>100), 1 for low average HR rate (<100)
%       varargin - series of file names of the format 'xxxx.ref'
%           Note: if a file is missing, a place holder of ' ' MUST BE USED
%
% Derived from heavily modified PhLEM toolbox code
% Written by Omar H Butt Aug 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if HRrate == 0
    HRrate = 'high';
elseif HRrate == 1
    HRrate = 'low';
end
HRrate = lower(HRrate);

% if mod(n,20)~=0;
%     disp ('ERROR: Selected shift must be divisible by 20ms');
% else

n = 0; % Hard coded shift desired. Note, must be in multiples of 20ms.
spacer = n / 20;
CO = [];
gotone=0;
namer = 1;
totallength=0;


for i = 2:2:length(varargin)
    totallength = totallength + varargin{i};
end


HRs =[];
LRs =[];
COS =[];
baseset =[];
numb = 1;

switch lower(type)
    
    case 'single'
        for i = 1:2:(length(varargin)-1)
            isempty = strcmp(varargin{i},' ');
            if isempty == 1
                currentoutput = zeros(8,varargin{i+1});
            else
                if gotone == 0
                    namer = i;
                    gotone = 1;
                end
                currentfile = varargin{i};
                TR =  varargin{i+1};
                [ currentoutput HR LR ] = PulseSplitCore(currentfile,TR,spacer,TRi,HRrate);
                HRs = [HRs HR];
                LRs = [LRs LR];
            end
            COS = [COS currentoutput];
        end
        COS = COS';
        fname = name;
        HRF = mean(HRs);
        LRF = mean(LRs);
        writeme(COS,n,fname,HRF,LRF);
        disp('Complete!')
        
    case 'multi'
        
        HRx = 0;
        LRx = 0;
        for i = 1:2:(length(varargin)-1)
            
            isempty = strcmp(varargin{i},' ');
            if isempty == 1
                currentoutput = zeros(8,varargin{i+1});
            else
                if gotone == 0
                    namer = i;
                    gotone = 1;
                end
                currentfile = varargin{i};
                TR =  varargin{i+1};
                [ currentoutput HRx LRx ] = PulseSplitCore(currentfile,TR,spacer,TRi,HRrate);
            end
            
            if i == 1
                desiredout = currentoutput;
            else
                desiredout = [baseset currentoutput];
            end
            
            desiredout(1,end+1:totallength)=0;
            fname = [sprintf('Scan%u-',numb) name];
            writeme(desiredout',n,fname,HRx,LRx);
            baseset = [baseset zeros(8,varargin{i+1})];
            numb = numb+1;
        end
        disp('Complete!')
        
    case 'both'
        baseset = [];
        HRx = 0;
        LRx = 0;
        for i = 1:2:(length(varargin)-1)
            
            
            isempty = strcmp(varargin{i},' ');
            if isempty == 1
                currentoutput = zeros(8,varargin{i+1});
            else
                if gotone == 0
                    namer = i;
                    gotone = 1;
                end
                currentfile = varargin{i};
                TR =  varargin{i+1};
                [ currentoutput HRx LRx ] = PulseSplitCore(currentfile,TR,spacer,TRi,HRrate);
            end
            
            if i == 1
                desiredout = currentoutput;
            else
                desiredout = [baseset currentoutput];
            end
            desiredout(1,end+1:totallength)=0;
            fname = [sprintf('Scan%u-',numb) name];
            writeme(desiredout',n,fname,HRx,LRx);
            baseset = [baseset zeros(8,varargin{i+1})];
            COS = [COS currentoutput];
            numb = numb+1;
        end
        
        COS = COS';
        fname = name;
        HRF = mean(HRs);
        LRF = mean(LRs);
        writeme(COS,n,fname,HRF,LRF);
        disp('Complete!')
        
    otherwise
        disp('Unknown desired output parameters.')
end

% end

function writeme (CO,n,fname,HRF,LRF)

Hstring = [ ';VB98'; ';REF1'; ';    '; ];
ORs = sprintf('; Cardiac Rate: %f',HRF);
Ms = sprintf('; File length: %u',length(CO));
writetotext(CO(:,1),[sprintf('H-Sin1-(%u)-',n) fname],Hstring,ORs,Ms)
writetotext(CO(:,2),[sprintf('H-Cos1-(%u)-',n) fname],Hstring,ORs,Ms)
writetotext(CO(:,3),[sprintf('H-Sin2-(%u)-',n) fname],Hstring,ORs,Ms)
writetotext(CO(:,4),[sprintf('H-Cos2-(%u)-',n) fname],Hstring,ORs,Ms)
ORs = sprintf('; Resp Rate: %f',LRF);
writetotext(CO(:,5),[sprintf('L-Sin1-(%u)-',n) fname],Hstring,ORs,Ms)
writetotext(CO(:,6),[sprintf('L-Cos1-(%u)-',n) fname],Hstring,ORs,Ms)
writetotext(CO(:,7),[sprintf('L-Sin2-(%u)-',n) fname],Hstring,ORs,Ms)
writetotext(CO(:,8),[sprintf('L-Cos2-(%u)-',n) fname],Hstring,ORs,Ms)

function [ genoutput Highrate Lowrate ] = PulseSplitCore(fname,TRtotal,spacer,TR,HRrate)

Hz = 50;
TR = TR*1000;

%%%Text Analysis Portion below. Adapted for .ref file manipulation

fclose('all');fid=fopen(fname);

linestoignore = 9;
ignore=textscan(fid,'%s',linestoignore,'delimiter','\n'); %Ignore first 2 rows.

[ data ]  = textscan(fid,'%n'); %Read data until end of data.

signal = data{1};

fclose(fid);

signal=signal';

% Find Proper length of total pulse array, and interpolate it down to the
% new shorter size to accomodate for the slightly longer TR interval

sampR=1000/Hz;
arraylength=TRtotal*TR/sampR;

PSig = sizecorrection(signal,arraylength);
signal = PSig;

Time = (1:length(signal))./Hz;

%%%Apply smoothing/filtering to the signal

[HIGHsignal Hevents] = PhLEM_H(signal,Hz,HRrate);

[LOWsignal Levents] =  PhLEM_L(signal,Hz,HRrate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Highes = PulseRegress(Hevents,Time,TR,spacer);
Lowes = PulseRegress(Levents,Time,TR,spacer);

Highrate = length(find(Hevents)) / Time(end) * 60;
disp([fname sprintf(' Cardiac Rate: %f',Highrate)])
Lowrate = length(find(Levents)) / Time(end) * 60;
disp([fname sprintf(' Resp Rate: %f',Lowrate)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Output

genoutput = [Highes Lowes];
genoutput=genoutput';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Resize function to make correct length based on TR multiple
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputsignal] = sizecorrection(signal,newlength)

x = 1:length(signal);
shifter = length(signal)/newlength;

outputsignal = zeros (1,newlength);

currentspot = 1;
for cc=1:newlength
    
    if currentspot > length(signal)
        currentspot = length(signal);
    else
        outputsignal(1,cc) = interp1(x,signal,currentspot,'linear');
        currentspot = currentspot + shifter;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    delta          = search rate for looking for signal peaks
%    peak_rise     = amplitude threshold for looking for peaks
%    filter        = finter or smoothing type ('butter' or 'gaussian')
%    Wn            = filter/smoothing kernel.  If bandpass filter,
%                    normalized frequencies.  If gaussian smoothing,
%                    then kernel fwhm.
%    Hz            = Frequency of the sampled data signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Filter and smoothing function for HIGH frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x events] = PhLEM_H(TS,Hz, HRrate)


if strcmp(HRrate,'low')
    delta = Hz/3.5;
    Wn = [1 10]/Hz;
else
    
    delta = Hz/6; % Default from Hz/6;
    Wn = [1 14]/Hz; % Defauly [ 1 12]; a range from 9 to 12 works for second number
end
peak_rise = 0.1;


%Transform via ABS

x = abs(TS);
x = x - mean(x);

% Use butter filter
if ~isempty(Wn)
    [b a] = butter(1,Wn);
    xbutter = filter(b,a,x);
end;


% $$$ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $$$ % -- Schlerf (Jul 24, 2008)
% $$$ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Take a first pass at peak detection:
mxtb  = peakdet(x,1e-14);

% set the threshold based on the 20th highest rather than the highest:
sorted_peaks = sort(mxtb(:,2));
if length(sorted_peaks) > 20
    peak_resp=sorted_peaks(end-20);
else
    if length(sorted_peaks) > 15
        peak_resp=sorted_peaks(end-15);
    else
        if length(sorted_peaks) > 10
            peak_resp=sorted_peaks(end-10);
        else
            if length(sorted_peaks) > 5
                peak_resp=sorted_peaks(end-5);
            else
                peak_resp = sorted_peaks(1);
            end
        end
    end
end

% And now do a second pass, more robustly filtered, to get the actual peaks:
mxtb  = peakdet(x,peak_rise*peak_resp);

events = zeros(size(TS));

peaks = mxtb(:,1);
dpeaks = diff(peaks);
kppeaks = find(dpeaks > delta);
newpeaks = peaks([1 kppeaks'+1]);

events(newpeaks) = 1;

% DEBUG CATCH:
if length(newpeaks) < 5;
    
    warning('Program Crash: High Freq peaks hard to detect; try different HRrate field?')
    
    keyboard;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Filter and smoothing function for LOW frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x events] = PhLEM_L(TS,Hz,HRrate)

if strcmp(HRrate,'low')
    delta = Hz*1.5;
    Wn = Hz*0.3;
else
    delta = Hz*1.5; %Default is Hz*1.5
    Wn = Hz*0.35; %Default is Hz*0.4
end
peak_rise = 0.5;

% Transform via ABS
x = abs(TS);
x = x - mean(x);

% Use Gaussian Filter
x = smooth_kernel(x(:),Wn);
x = x';

% $$$ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $$$ % -- Schlerf (Jul 24, 2008)
% $$$ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Take a first pass at peak detection:
[mxtb mntb] = peakdet(x,1e-14);

% set the threshold based on the 20th highest rather than the highest:
sorted_peaks = sort(mxtb(:,2));
if length(sorted_peaks) > 20
    peak_resp=sorted_peaks(end-20);
else
    if length(sorted_peaks) > 15
        peak_resp=sorted_peaks(end-15);
    else
        if length(sorted_peaks) > 10
            peak_resp=sorted_peaks(end-10);
        else
            if length(sorted_peaks) > 5
                peak_resp=sorted_peaks(end-5);
            else
                peak_resp = sorted_peaks(1);
            end
        end
    end
end

% And now do a second pass, more robustly filtered, to get the actual peaks:
[mxtb mntb] = peakdet(x,peak_rise*peak_resp);

events = zeros(size(TS));

peaks = mxtb(:,1);
dpeaks = diff(peaks);
kppeaks = find(dpeaks > delta);
newpeaks = peaks([1 kppeaks'+1]);

events(newpeaks) = 1;

% DEBUG CATCH:
if length(newpeaks) < 5;
    delta = Hz*1.275;
    [mxtb mntb] = peakdet(x,1e-14);
    
    % set the threshold based on the 20th highest rather than the highest:
    sorted_peaks = sort(mxtb(:,2));
    if length(sorted_peaks) > 20
        peak_resp=sorted_peaks(end-20);
    else
        if length(sorted_peaks) > 15
            peak_resp=sorted_peaks(end-15);
        else
            if length(sorted_peaks) > 10
                peak_resp=sorted_peaks(end-10);
            else
                if length(sorted_peaks) > 5
                    peak_resp=sorted_peaks(end-5);
                else
                    peak_resp = sorted_peaks(1);
                end
            end
        end
    end
    
    % And now do a second pass, more robustly filtered, to get the actual peaks:
    [mxtb mntb] = peakdet(x,peak_rise*peak_resp);
    events = zeros(size(TS));
    peaks = mxtb(:,1);
    dpeaks = diff(peaks);
    kppeaks = find(dpeaks > delta);
    newpeaks = peaks([1 kppeaks'+1]);
    events(newpeaks) = 1;
    
    disp('Low Freq peaks hard to detect, switching delta')
    
    if length(newpeaks) < 5;
        warning('Program Crash: Low Freq peaks still hard to detect; Bad Data?')
    end
    
    %   keyboard;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%To run a gaussian smoothing kernel over the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=smooth_kernel(y,sigma)

N=round(sigma*5)*2;
x=[1:N];
v=normpdf(x,(N+1)/2,sigma);
pb(1:length(v)-1)=y(1);
pe(1:length(v)-1)=y(end);
y=[pb';y;pe'];
y=conv(y,v);
cut=round(1.5*N);
y=y(cut-1:end-cut+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Write to text file function
%matx = matrix to output
%N = number of sectors/rows
%file = file name to output to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function writetotext(M,file,Hstring,ORs,l)


matx = (M);
fid = fopen(file, 'wt'); % Open for writing


for i=1:size(Hstring,1)
    fprintf(fid, '%s ', Hstring(i,:));
    fprintf(fid, '\n');
end
fprintf(fid, '%s ', ORs);
fprintf(fid, '\n');
fprintf(fid, '%s ', l);
fprintf(fid, '\n');
for n=1:5
    fprintf(fid, ';'); fprintf(fid, '\n');
end

for i=1:size(matx,1)
    fprintf(fid, '%d ', matx(i,:));
    fprintf(fid, '\n');
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [maxtab, mintab]=peakdet(v, delta)
%PEAKDET Detect peaks in a vector
%        [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
%        maxima and minima ("peaks") in the vector V.
%        A point is considered a maximum peak if it has the maximal
%        value, and was preceded (to the left) by a value lower by
%        DELTA. MAXTAB and MINTAB consists of two columns. Column 1
%        contains indices in V, and column 2 the found values.

% Eli Billauer, 3.4.05 (Explicitly not copyrighted).
% This function is released to the public domain; Any use is allowed.

maxtab = [];
mintab = [];

v = v(:); % Just in case this wasn't a proper vector

if (length(delta(:)))>1
    error('Input argument DELTA must be a scalar');
end

if delta <= 0
    error('Input argument DELTA must be positive');
end

mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;

lookformax = 1;

for i=1:length(v)
    this = v(i);
    if this > mx, mx = this; mxpos = i; end
    if this < mn, mn = this; mnpos = i; end
    
    if lookformax
        if this < mx-delta
            maxtab = [maxtab ; mxpos mx];
            mn = this; mnpos = i;
            lookformax = 0;
        end
    else
        if this > mn+delta
            mintab = [mintab ; mnpos mn];
            mx = this; mxpos = i;
            lookformax = 1;
        end
    end
end


function phase = Ph_expand(event_series,time)

% function phase = PhLEM_phase_expand(event_series,time);
%
% Takes a series of events defined as 1's or 0's, and an index vector
% for real time (in seconds), and returns the unwarped phase between
% the events. Works by assuming that the distance between consecutive
% events is 2pi.
%
% Inputs:
%   event_series  = 1xN array of 1's (events) or 0's (non-events);
%   time          = 1xN array of timestamps in real time (seconds);
%
% Written by T. Verstynen (November 2007)
%
% Liscensed under the GPL public license (version 3.0)

% Time Stamps of Events
events = find(event_series);

% Phase Interpolation
uwp_phase = [0:length(events)-1];
uwp_phase = 2*pi.*uwp_phase;
phase = interp1(time(events),uwp_phase,time,'spline','extrap');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [C] = PulseRegress(events,Time,TR,spacer)

phase = [ 1 2 ];

for p = phase
    tmp_phase = Ph_expand(events,Time);
    eval(sprintf('dphase%d = %d*tmp_phase;',p,phase(p)));
end;

A = dphase1;
B = dphase2;

TR=TR/1000;

% Setup TR markers
bottom = mean(diff(Time));
ender= Time(end)-(TR/(2));
tr_timestamps = (0:TR:ender);
tr_timestamps = tr_timestamps./bottom;

%Analysis
if (spacer ~= 0) && (spacer > 0)
    
    fillerA = A(1,end-spacer+1:end);
    fillerB = B(1,end-spacer+1:end);
    phasev1 = [ fillerA A(1,1:end-spacer) ];
    phasev2 = [ fillerB B(1,1:end-spacer) ];
else if (spacer ~= 0) && (spacer < 0)
        fillerA = A(1,1:abs(spacer));
        fillerB = B(1,1:abs(spacer));
        phasev1 = [  A(1,1+abs(spacer):end) fillerA ];
        phasev2 = [  B(1,1+abs(spacer):end) fillerB ];
    else
        phasev1 = A;
        phasev2 = B;
    end
end

C = [];
for exp = phase
    zz= eval(sprintf('phasev%d', phase(exp)));
    nphs = interp1(zz,tr_timestamps,'linear','extrap');
    
    C = [C [sin(nphs)]'];
    C = [C [cos(nphs)]'];
end
