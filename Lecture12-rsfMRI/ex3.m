%% Functional Connectivity
nROIs = 100;    % number of ROIs
nTS = 300;      % length of time series
TR = 2;

% Generate time series;
TS = zeros(nTS,nROIs);
for i=1:nROIs,
    [temp,ts1]=createBOLDsignal(nTS, TR, 'sine');
    TS1 = addRandomNoise(ts1,7);
    
    TS(:,i) = TS1;
end


%% Compute correlation coefficients
[R,P] = corrcoef(TS);
figure; hist(R(:));


% Fisher's r-to-z transformation
Z = 0.5 * ( log(1+R) - log(1-R+eps) );




