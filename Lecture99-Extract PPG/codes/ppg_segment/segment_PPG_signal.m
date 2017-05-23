addpath('~/matlabwork/spm8');
warning('off','all');

proj_path = '/Users/skyeong/Desktop/Data/';
out_path  = fullfile(proj_path,'PPG'); mkdir(out_path);

subjname  = 'subj01';


% Load PPG raw signal
Fs = 50;
TR = 2;
fn_puls = fullfile(proj_path,'Pulse',[subjname,'.puls']);
[PPG,time,ScanStartTime] = siemens_PPOload(fn_puls,'TR',TR,'Hz',Fs);


fMRIs = {'ATT1','ATT2'};
PPGs = struct();
a=[];
for i=1:length(fMRIs),
    fmriName = fMRIs{i};
    fns = spm_select('FPList',fullfile(proj_path,'dicom',subjname,fmriName),'^*\.IMA');
    fn_dicom = fns(1,:);
    
    hdr = spm_dicom_headers(fn_dicom);
    AcquisitionTime = getfield(hdr{1},'AcquisitionTime')*1000;
    timeDiff = AcquisitionTime - ScanStartTime + 4*1000;  % 4s offset to exclude dummy scans
    
    st = floor(timeDiff/1000)*Fs;
    ed = st + 5*60*Fs - 1;          % during 5 minutes
    
    % slice_times = getfield(hdr{1},'Private_0019_1029');
    PPGs(i).name = fmriName;
    PPGs(i).data = PPG(st:ed);
    PPGs(i).time = time(st:ed);
    
    fn_out = sprintf('%s_%s.csv',subjname,fmriName);
    fn_out = fullfile(out_path,fn_out);
    dlmwrite(fn_out,[time(st:ed), PPG(st:ed)]);
end


figure; plot(PPGs(1).time,PPGs(1).data,'k-');
hold on; plot(PPGs(2).time, PPGs(2).data,'r-');







% fid = fopen(fn_dicom,'r');
% tline = fgetl(fid);

%
% ISO_IR 10 CS$
% ORIGINAL\PRIMARY\FMRI\NONE\ND\MOSAI  D 2014121  TM 203849.921000 
% UI 1.2.840.10008.5.1.4.1.1.4 
% UI4 1.3.12.2.1107.5.2.36.40795.201412112037581884200066
% D 2014121 !
% D 2014121 "
% D 2014121 #
% D 2014121
% 0 TM 203607.984000
% 1 TM 203849.921000
% 2 TM 203756.985000   % (008,0032) Acquisition Time
% 3 TM 203849.921000
% P SH  ` CS M p L SIEMENS  LO St. Peter's Hospital / 3.0T  ST$ Street StreetNo,City,District,KR,ZI  P = S MRC4079 0LO head^St. Peter's hosp >LO ep2d_bold_Uni_1 @LO



% ECG  Freq Per: 0 0
% PULS Freq Per: 24 2481
% RESP Freq Per: 0 0
% EXT  Freq Per: 0 0
% ECG  Min Max Avg StdDiff: 0 0 0 0
% PULS Min Max Avg StdDiff: 591 3701 1871 109
% RESP Min Max Avg StdDiff: 0 0 0 0
% EXT  Min Max Avg StdDiff: 0 0 0 0
% NrTrig NrMP NrArr AcqWin: 0 0 0 0
% LogStartMDHTime:  74132555
% LogStopMDHTime:   74968650
% LogStartMPCUTime: 74131145
% LogStopMPCUTime:  74967855

% first rest-EPI 20.54.56.140625
%                203608.140000
% dicomImageTime  = 102907.165000

% MPCU time format
%
% The time stamps in the MPCU log-file are in terms of msecs since midnight. An example time stamp is:
%
% MPCU log time = 37747165
% Conversion of time formats
%
% The two example time formats can be shown to be equivalent:
%
% 37747165 = (10 hours * 60 mins/hour * 60 secs/min * 1000 msecs/sec) +
%            (29 mins  * 60 * 1000) +
%            (07 secs  * 1000) +
%            (1650 ticks / 10 ticks/msec)


