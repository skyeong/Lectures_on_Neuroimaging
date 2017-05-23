function [HR,HRVidx,RMSSD,LFHF]=calc_HRV_window(time1,X1,Fs,st,ed)

% Analysis Criteria
NN_range = [40, 120];

idx = time1>=st & time1<ed;
X = X1(idx);

% Smoothing the PPG data to remove high frequency noise
PPG = smooth_kernel(X,1);


% Peak Detection
[pks, locs] = findpeaks(PPG,'minpeakheight',mean(PPG),'minpeakdistance',Fs*0.5);


% Compute Peak-to-Peak interval
Beats = locs(:)/Fs;
RR = Beats(2:end) - Beats(1:end-1);


% Compute Time Domain TINN
TIME = calcTimeHRV(RR, NN_range);


% Equidistantly Resampling RR data for Frequency Analysis
Fs_RR = 4;           % 4 Hz resampling [1]
ts = 2:1./Fs_RR:300;  % 4 Hz resampling
RR2 = interp1(Beats(2:end),RR,ts,'cubic');


% Compute Frequency Domain TINN
FREQ = calcFreqHRV(RR2, Fs_RR);

% Output
LFHF = FREQ.LF./FREQ.HF;
HR = TIME.AVHR;
HRVidx = TIME.HRVidx;
RMSSD = TIME.RMSSD;
