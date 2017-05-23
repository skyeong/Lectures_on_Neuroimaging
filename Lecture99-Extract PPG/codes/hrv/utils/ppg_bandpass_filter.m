function [Y]=ppg_bandpass_filter(X,Fs,BW,keepdc)
if nargin<4, keepdc=1; end;

ndim = size(X,1);
XF=fft(X,[],1);

f=(0:ndim-1);f=min(f,ndim-f);
f=Fs*f/ndim;

idx=find(f<BW(1)|f>BW(2));
if keepdc, idx=idx(idx>1);end;
XF(idx,:)=0;
Y=real(ifft(XF,[],1));
