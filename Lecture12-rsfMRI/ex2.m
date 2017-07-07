%% Simulated timeseries for linear regression
[X,time1] = createBOLDsignal(120, 2, 'block');


% Plot the distribution
figure;
plot(time1,X,'ko-'); hold on;


%% Add random noise to the model
y1 = addRandomNoise(X,0.5);
y2 = addRandomNoise(X,1.5);


% Plot the distribution
figure;
plot(time1,y1,'ko-'); hold on;
plot(time1,y2,'ro-'); hold on;


% Block Design Model
X = [ones(size(X)), X];


% Solving GLM in matrix form
betas1 = pinv(X'*X)*X'*y1;
betas2 = pinv(X'*X)*X'*y2;


% compute y-hat using estimated betas
y1hat = X*betas1;
y2hat = X*betas2;


% Plot the distribution
figure;
plot(time1,y1,'ko-'); hold on;
plot(time1,y1hat,'ro-'); hold on;


% Plot the distribution
figure;
plot(time1,y2,'ko-'); hold on;
plot(time1,y2hat,'ro-'); hold on;



