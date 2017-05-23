function y = PhLEM_normpdf(x,mu,sigma)

% Y = PHLEM_NORMPDF(X,MU,SIGMA). A function to supplement the normpd routine in
% the statistics toolbox.  Does the same thing without the catches and
% checks for dependencies.
%
% Returns the PDF of the normal distribution with a mean (MU) and standard ...
%     deviation (SIGMA) evaluated at X. Defaults to MU=0 & SIGMA = 1;
%
% Written by T. Verstynen (6/26/2009);

% Manage inputs
if nargin < 1
    error('Need inputs to evaluate');
end;

if nargin < 2
    mu = 0;
end

if nargin < 3
    sigma = 1;
end;

% Check to see if sigmas are out of range
sigma(sigma <= 0) = NaN;

% Evaluate the PDF
y = exp(-0.5 * ((x-mu)./sigma).^2)./(sqrt(2*pi).*sigma);
