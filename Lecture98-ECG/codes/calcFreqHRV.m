function STAT = calcFreqHRV(RR, Fs)
% STAT = calcFreqHRVmw(RR, Fs)
% RR: equisampled RR interval in second
% Fs: in hertz

STAT=struct();


% Windowing RR data
segRR = (1000) * RR;   % in milisecond unit


% Fast Fourier Tsansformation
NFFT = length(segRR);
N = 2^(nextpow2(NFFT));
if N==NFFT,    % if the number of data points is in 2^N
    xRR = fft(segRR);                     % Fourior Transformation
    RR_fft = xRR.*conj(xRR)./(NFFT*Fs);   % definition of power spectrum density
    RR_fft = RR_fft(1:NFFT/2+1);          % unit of PSD is (ms)^2/Hz
else
    N = 2^(nextpow2(NFFT)-1);
    
    xRR1 = fft(segRR(end-N+1:end));         % Fourior Transformation
    RR1_fft = xRR1.*conj(xRR1)./(N*Fs);     % definition of power spectrum density
    RR1_fft = RR1_fft(1:N/2+1);
    
    xRR2 = fft(segRR(1:N));                 % Fourior Transformation
    RR2_fft = xRR2.*conj(xRR2)./(N*Fs);     % definition of power spectrum density
    RR2_fft = RR2_fft(1:N/2+1);             % unit of PSD is (ms)^2/Hz
    
    RR_fft = (RR1_fft+RR2_fft)/2;
    NFFT = N;
end


% Compute frequency ranges (Nyquist Criteria)
f = (Fs/2)*linspace(0, 1, NFFT/2+1);


% find idx for each frequency band
idx_VLF = f>=0.003 & f<0.04;
idx_LF  = f>=0.04  & f<0.15;
idx_HF  = f>=0.15  & f<0.40;
idx_TOT = f>=0.003 & f<0.40;


% Mean of Power Spectral Density
deltaFreq = f(2) - f(1);
S_TOT = sum(RR_fft(idx_TOT))*deltaFreq;   % areal power (ms)^2

S_VLF = sum(RR_fft(idx_VLF))*deltaFreq;  % areal power (ms)^2
S_LF  = sum(RR_fft(idx_LF ))*deltaFreq;    % areal power (ms)^2
S_HF  = sum(RR_fft(idx_HF ))*deltaFreq;    % areal power (ms)^2


% Save OUTPUT variables
STAT(1).nuLF   = 100*S_LF/(S_TOT-S_VLF);   % relative power
STAT(1).nuHF   = 100*S_HF/(S_TOT-S_VLF);   % relative power

STAT(1).VLF    = S_VLF;       % absolute power
STAT(1).LF     = S_LF;        % absolute power
STAT(1).HF     = S_HF;        % absolute power
STAT(1).TOT    = S_TOT;       % absolute power
