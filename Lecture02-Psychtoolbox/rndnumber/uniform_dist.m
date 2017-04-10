N = 10000;

% Uniform distribution (0,1)
dist1 = rand(N,1);
figure;
hist(dist1,20);


% Uniform distribution (2,5)
dist2 = 3*dist1+2;
figure;
hist(dist2,20);
