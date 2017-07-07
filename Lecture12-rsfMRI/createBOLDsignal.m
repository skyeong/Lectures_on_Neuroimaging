function [model,time] = createBOLDsignal(dataLen, TR, mode)
% createBOLDsignal(dataLen, TR, noiseRatio, mode)
%  dataLen: length of data should be defined
%  TR: repetition time of fMRI
%  noiseRatio: inclusion ratio of noise component into data
%  mode: block or sine
%
%  Created by Sunghyon Kyeong

if nargin~=3,
    fprintf('createBOLDsignal(dataLen, TR, noiseRatio, mode)\n');
    return;
end


time = (linspace(0,1,dataLen)*dataLen*TR)';

if strcmpi(mode,'block')
    model = [zeros(10,1); ones(10,1)];
    model = repmat(model,dataLen/20,1);
    
    % Get HRF with a specific TR (repetition time)
    hrf = spm_hrf(TR);
    
    % Convolution between original time series and HRF
    model = conv(model,hrf);
    model = model(1:dataLen);
    
elseif strcmpi(mode,'sine'),
    freqs = [0.002:0.002:0.25];
    model = zeros(dataLen,1);
    for f = freqs,
        myphase = rand(1)*(2*pi) - pi;
        if f>0.01 && f<0.08,
            w=3;
        else
            w=1;
        end
        model = model + w*rand(1)*sin(2*pi*f*time+myphase);
    end
    model = model(1:dataLen);
end

