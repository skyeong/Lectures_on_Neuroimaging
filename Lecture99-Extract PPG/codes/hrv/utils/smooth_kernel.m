function y=smooth_kernel(y,sigma)

% Y = smooth_kernel(Y,SIGMA);
%  Runs a gaussian smoothing kernel over the input data Y, with a FWHM
%  (i.e, variance) defined by SIGMA.
%
% Written by J. Diedrichsen (circa 2001)

N=round(sigma*5)*2;
x=[1:N];
v=PhLEM_normpdf(x,(N+1)/2,sigma);
pb(1:length(v)-1)=y(1);
pe(1:length(v)-1)=y(end);
y=[pb(:);y(:);pe(:)];
y=conv(y,v);
cut=round(1.5*N);
y=y(cut-1:end-cut+1);