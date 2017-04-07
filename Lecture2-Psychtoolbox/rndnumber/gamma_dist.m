N = 10000;

% Gamma distribution (short-tail)
mu = 1;
truncate_at = 0.5;
dist1 = gamrnd(mu-truncate_at*1.5,2, [N, 1])+truncate_at;
mu = mean(dist1);
SD = std(dist1);
fprintf('mean=%.1f, SD=%.2f\n',mu,SD);
figure;
k=0:0.5:20;
hist(dist1,k);


% Gamma distribution (long-tail)
mu = 2;
truncate_at = 0.5;
dist2 = gamrnd(mu-truncate_at*2.5, 2, [N, 1])+truncate_at;
mu = mean(dist2);
SD = std(dist2);
fprintf('mean=%.1f, SD=%.2f\n',mu,SD);
figure;
hist(dist2,k);
