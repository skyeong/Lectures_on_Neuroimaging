function TS = addRandomNoise(model,noiseRatio)


% Add random noise
dataLen = length(model);
RN = randn(dataLen,1);
RN = RN/max(abs(RN));

TS = model + noiseRatio*RN;