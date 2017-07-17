function STAT = calcTimeHRV(RR, NN_range)

if nargin<2,
    NN_range = [60,100];
end

% Normal Heart Rate, in bpm
HR_up = max(NN_range);   % upper bound for normal heartbeat
HR_dn = min(NN_range);   % lower bound for normal heartbeat

STAT=struct();



% indices which are out-range of NN
idx_NN = (RR<60/HR_up | RR>60/HR_dn);
NN = RR;

% Compute HRV
bin_size = 1.0/128;   % Reference for Binsize [1]
t = 60/HR_up:bin_size:60/HR_dn; t = t(:);
t2 = [t(1)-0.1; t; t(end)+0.1];
pt = hist(RR(idx_NN==0),t2);
HRVidx = sum(pt(2:end-1))/max(pt);  % in second


% differences of RR intervals
NN(idx_NN) = 100000;   % for detecting abnormal heart beat
diff_NN = abs(NN(2:end)-NN(1:end-1))*1000;   % [ms]


% to remove RR intervals which are in the out-range of NN
diff_NN(diff_NN>1000)=[];   %
diff_NN(diff_NN==0)=[];


% pNNx variables
pNNx = zeros(10,1);
for i=1:10,
    x = (i*10);   % if i=1, x=10ms
    pNNx(i) = 100*sum(diff_NN>=x)/length(diff_NN);
end



% HRV measures in Time domain
STAT(1).HRVidx = HRVidx;  % HRV (triangular) index
STAT(1).pNNx = pNNx;
STAT(1).RMSSD = sqrt(mean(diff_NN.^2));


% for the Normal Heart Beat, compute average and standard deviation
STAT(1).AVNN = mean(NN(NN<10000)*1000);   % [ms]
STAT(1).SDNN = std(NN(NN<10000)*1000);    % [ms]
STAT(1).AVHR = mean(60./NN(NN<10000));   % [ms]
STAT(1).SDHR = std(60./NN(NN<10000));   % [ms]



% [1] G. D. Clifford's Ph.D. Thesis (Citeseer, 2002)
%     Signal processing methods for heart rate variability
