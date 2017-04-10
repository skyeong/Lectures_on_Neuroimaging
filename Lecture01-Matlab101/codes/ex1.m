DATApath = '/Volumes/JetDrive/workshops/Matlab/lecture1/data';

% Load Realignment Parameters
fn_motion = fullfile(DATApath,'rp_rest.txt');
MOTION = dlmread(fn_motion);
size(MOTION);   % Check size of variable
scans = 1:150;

% Split translation and rotation part
TRANS = MOTION(:,1:3);      % translation in x,y,z
ROT = 50*MOTION(:,4:end);   % l=r*theta (r=5cm)


% Plot Head Motion - translation part
figure; 
plot(scans,TRANS(scans,:));  
xlabel('Scan number');
ylabel('Translation, mm'); 
legend('x','y','z');



% Plot Head Motion - rotation part
figure; 
plot(scans,ROT(scans,:)); 
xlabel('Scan number');
ylabel('Rotation, mm'); 
legend('pitch','roll','yaw');


% Plot Head Motion - translation part
figure; 
subplot(211); plot(scans,TRANS(scans,:));  
xlabel('Scan number');
ylabel('Translation, mm'); 
legend('x','y','z');

% Plot Head Motion - rotation part
subplot(212); plot(scans,ROT(scans,:)); 
xlabel('Scan number');
ylabel('Rotation, mm'); 
legend('pitch','roll','yaw');



