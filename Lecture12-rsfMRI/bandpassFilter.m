function TS_filtered = bandpassFilter(TS, BW, TR)

% Create frequencies for a length of ndim
ndim = size(TS,1);
f=(0:ndim-1);f=min(f,ndim-f);
f=f/(TR*ndim);


% Find indices within [f_min, f_max]
f_min = min(BW);
f_max = max(BW);
idx = find(f<f_min|f>f_max);


% FFT and zero padding for out-range of f_min and f_max
XF = fft(TS,[],1);
XF(idx,:)=0;


% inverse FFT and take real part
TS_filtered=real(ifft(XF,[],1));