% Load PPI files
v2noatt = load('../PPI_mat/PPI_V2xNoAttention.mat');
v2att = load('../PPI_mat/PPI_V2xAttention.mat');
v5noatt = load('../PPI_mat/PPI_V5xNoAttention.mat');
v5att = load('../PPI_mat/PPI_V5xAttention.mat');


% Plot the PPI datapoints with the following commands at the Matlab
figure;
plot(v2noatt.PPI.ppi, v5noatt.PPI.ppi,'k.');
hold on
plot(v2att.PPI.ppi, v5att.PPI.ppi,'r.');


% Plot the best fit lines for NoAttention
x = v2noatt.PPI.ppi(:);
x = [x, ones(size(x))];
y = v5noatt.PPI.ppi(:);
B = pinv(x)*y;
y1 = B(1)*x(:,1)+B(2);
plot(x(:,1), y1, 'k-');


% Plot the best fit lines for Attention
x = v2att.PPI.ppi(:);
x = [x, ones(size(x))];
y = v5att.PPI.ppi(:);
B = pinv(x)*y;
y1 = B(1)*x(:,1)+B(2);
plot(x(:,1), y1, 'r-');

legend('No Attention', 'Attention');
xlabel('V2 activity');
ylabel('V5 response');
title('Psychophysiolotic Interaction');
