addpath('utils/');


plotmode=0;

% Load Study Infomation
proj_path = '/Users/skyeong/Desktop/Data/';
fn_xls = '/Users/skyeong/Desktop/Data/subjlist.xlsx';
T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);

% Analysis Criteria
Fs = 50;
BW = [0, 10];  % for banspass filtering PPG raw signal
NN_range = [40, 120];

stimType = {'ATT1','ATT2'};

% Output file path
%-------------------------------------------------
fid = fopen('~/Desktop/a.csv','w+');


% fprintf(fid,'subjname,stimName,HRV,pNN20,pNN50,RMSSD,AVNN,SDNN,nuMF,nuGF,nuLF,nuHF,LFHF,TOT\n');
fprintf(fid,'subjname,stimName,HRV,AVHR,AVNN,SDNN,RMSSD,nuMF,nuLF,nuHF,LF,HF,LFHF,TOT\n');
for c=1:nsubj,
    subjname = subjlist{c};
    fprintf('   %s, HRV computing ... \n',subjname);
    for s=1:length(stimType),
        stimName = stimType{s};
        
        % Load PPG raw data
        fn_PPG = fullfile(proj_path,'PPG',[subjname '_' stimName '.csv']);
        if ~exist(fn_PPG,'file'),  continue;  end
        
        
        PPG = dlmread(fn_PPG);
        time = PPG(:,1)-PPG(1,1); t_max = time(end);
        X = PPG(:,2);
        
        
        % Smoothing the PPG data to remove high frequency noise
        PPG = smooth_kernel(X,1);
        
        
        % Peak Detection
        [pks, locs] = findpeaks(PPG,'minpeakheight',mean(PPG),'minpeakdistance',Fs*0.5);
        
        
        if plotmode,
            figure; plot(PPG(1:5000))
            hold on; plot(locs(1:100),pks(1:100),'ko');
        end
        
        
        % Compute Peak-to-Peak interval
        Beats = locs(:)/Fs;
        RR = Beats(2:end) - Beats(1:end-1);
        
        % Compute Time Domain HRV
        TIME = calcTimeHRV(RR, NN_range);
        
        
        % Equidistantly Resampling RR data for Frequency Analysis
        Fs_RR = 4;           % 4 Hz resampling [1]
        ts = 2:1./Fs_RR:300;  % 4 Hz resampling
        RR2 = interp1(Beats(2:end),RR,ts,'cubic');
        
        
        % Compute Frequency Domain HRV
        FREQ = calcFreqHRV(RR2, Fs_RR);
        LFHF = FREQ.LF./FREQ.HF;
        
        HR = 60./RR2;
        
        %fprintf(fid,'%s,%s,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subjname,stimName,TIME.HRV,TIME.pNNx(2), TIME.pNNx(5),TIME.RMSSD,TIME.AVNN,TIME.SDNN,FREQ.nuMF,FREQ.nuGF,FREQ.nuLF,FREQ.nuHF,LFHF,FREQ.TOT);
        fprintf(fid,'%s,%s,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subjname,stimName,TIME.HRVidx,mean(HR),TIME.AVNN,TIME.SDNN,TIME.RMSSD,FREQ.nuMF,FREQ.nuLF,FREQ.nuHF,FREQ.LF,FREQ.HF,LFHF,FREQ.TOT);
        
    end
end

fclose(fid);
% [1] G. D. Clifford's Ph.D. Thesis (Citeseer, 2002)
%     Signal processing methods for heart rate variability
