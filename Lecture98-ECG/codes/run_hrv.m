addpath('utils/');
plotmode=0;

% Project Directory
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture98-ECG';


% Analysis Criteria
%--------------------------------------------------------------------------
Fs = 1024;
NN_range = [40, 120];


% Load ECG raw data
%--------------------------------------------------------------------------
fprintf('   HRV computing ... \n');
fn_ECG = fullfile(proj_path,'data','ecg_data.csv');
ECG = dlmread(fn_ECG);
t_max = length(ECG)/Fs;


% Peak Detection
%--------------------------------------------------------------------------
[pks, locs] = findpeaks(ECG,'minpeakheight',mean(ECG),'minpeakdistance',Fs*0.5);

if plotmode,
    figure; plot(ECG(1:10000))
    hold on; plot(locs(1:12),pks(1:12),'ko');
end


% Compute Peak-to-Peak interval
%--------------------------------------------------------------------------
Beats = locs(:)/Fs;
RR = Beats(2:end) - Beats(1:end-1);


% Compute Time Domain HRV
%--------------------------------------------------------------------------
TIME = calcTimeHRV(RR, NN_range);


% Equidistantly Resampling RR data for Frequency Analysis
%--------------------------------------------------------------------------
Fs_RR = 4;              % 4 Hz resampling [1]
ts = 0:1./Fs_RR:t_max;  % 4 Hz resampling
RR2 = interp1(Beats(2:end),RR,ts,'pchip');


% Compute Frequency Domain HRV
%--------------------------------------------------------------------------
FREQ = calcFreqHRV(RR2, Fs_RR);
FREQ.LFHF = FREQ.LF./FREQ.HF;
