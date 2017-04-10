% Generate random data
N1 = 20;
N2 = 15;
N  = N1 + N2;
dat1 = 1.5*randn(N1,1)+0.7;
dat2 = 1.5*randn(N2,1)-0.8;

% Plot
figure; 
k=-7:1:7;
subplot(211); hist(dat1,k);
subplot(212); hist(dat2,k);

% Two-sample T-test 
[h,p,ci,stat] = ttest2(dat1,dat2);
mu1 = mean(dat1);
mu2 = mean(dat2);
fprintf('mu1=%.1f, mu2=%.1f, T=%.1f, p=%.4f\n',mu1,mu2,stat.tstat,p);

% Create null-distribution
data = [dat1; dat2;];
Nperm = 10000;
null_dist = zeros(Nperm,1);
for i=1:Nperm,
    idx = randperm(N);
    d1 = data(idx(1:N1));
    d2 = data(idx(N1+1:end));
    null_dist(i) = mean(d1)-mean(d2);
end

% two-tailed testing
diff_data = mean(dat1)-mean(dat2);
if diff_data>0,
    id_cut = find(null_dist>diff_data);
    pvalue = 2*length(id_cut)/Nperm;
else
    id_cut = find(null_dist<diff_data);
    pvalue = 2*length(id_cut)/Nperm;
end
fprintf('mu1=%.1f, mu2=%.1f, p=%.4f\n',mu1,mu2,pvalue);