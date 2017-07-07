%% Simulated timeseries for bandpass filtering example
[TS,time] = createBOLDsignal(256, 2, 'sine');
TS = addRandomNoise(TS,7);

% Bandpass filtering
TS_filtered = bandpassFilter(TS,[0.001, 0.08], 2);


figure;
plot(time, TS,   'k-');  hold on;
plot(time, TS_filtered, 'r-');  xlim([0, 512]);

