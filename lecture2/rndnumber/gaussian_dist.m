N = 10000;

% Gaussian distribution N(mu=0,SD=1)
dist1 = randn(N,1);
mu = mean(dist1);
SD = std(dist1);
fprintf('mean=%.1f, SD=%.2f\n',mu,SD);
figure;
hist(dist1,20);


% Gaussian distribution N(-5,2)
dist2 = 2*dist1-5;
mu = mean(dist2);
SD = std(dist2);
fprintf('mean=%.1f, SD=%.2f\n',mu,SD);
figure;
hist(dist2,20);
