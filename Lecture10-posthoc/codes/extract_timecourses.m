% Start marsbar to make sure spm_get works
marsbar('on'); 
warning('off','all');

% You might want to define the path for your project
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fn_xls    = fullfile(proj_path,'subjlist.xlsx');

T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);


%--------------------------------------------------------------------------
% Create ROI using marsbar script
%--------------------------------------------------------------------------
% MNIcenters: center coordinates of ROI
% RADIUS: radius of ROI
% roi_dir: output directory to save ROI image
% fn_mask(optional): file path of mask image (to define image space)

RADIUS = 6;
clear MNIcenters;
MNIcenters{1} = [-52 30 0];
MNIcenters{2} = [52 30 0];

fn_mask = fullfile(proj_path,'Analysis','SecondLevel','Flexible','mask.nii');
roi_dir = fullfile(proj_path,'Analysis','rois'); mkdir(roi_dir);
roi_files = create_ROI(MNIcenters,RADIUS,roi_dir,fn_mask);




%--------------------------------------------------------------------------
% MarsBaR estimation to extract beta values in each ROI
%--------------------------------------------------------------------------
nroi = length(roi_files);
ncond = 4;
event_duration = 0;  % default SPM event duration

TimeCourses = zeros(nsubj,ncond,nroi,bin_no);
for c = 1:nsubj
    subjname = subjlist{c};
    spm_name = fullfile(proj_path,'Analysis','FirstLevel',subjname,'SPM.mat');
    % change_SPMfile_path(spm_name,swa_path);

    % Make marsbar design object
    D = mardo(spm_name);
    
    for r=1:length(roi_files),
        % Make marsbar ROI object
        R = maroi(roi_files{r});
        
        % Fetch data into marsbar data object
        Y = get_marsy(R,D,'mean');
        
        % Get contrasts from original design
        xCon = get_contrasts(D);
        
        % Estimate design on ROI data
        E = estimate(D,Y);
        
        % Get definitions of all events in model
        [e_specs, e_names] = event_specs(E);
        n_events = size(e_specs,2);
        
        % Bin size in seconds for FIR (finite infinite response) model
        bin_size = tr(E);
        
        % Length of FIR in seconds
        fir_length = 24;
        
        % Number of FIR time bins to cover length of FIR
        bin_no = fir_length / bin_size;
        
        % Options - here 'single FIR model, return estimated
        opts = struct('single',1,'percent',1);
        fir_tc = zeros(bin_no,n_events);
        for e_s=1:n_events
            fir_tc(:,e_s) = event_fitted_fir(E, e_specs(:,e_s), bin_size, bin_no, opts);
        end
        
        % Compute average timecourse over sessions
        for cond_i=1:length(xCon),
            TimeCourses(c,cond_i,r,:) = mean(fir_tc(:,e_specs(2,:)==cond_i),2);  % average over sessions
        end
    end
end

time = [0:bin_size:fir_length-bin_size];
dlmwrite('~/Desktop/TimeCourses_con1.csv',TimeCourses(:,1,1,:));  % Save for Cond1&ROI1
dlmwrite('~/Desktop/TimeCourses_con2.csv',TimeCourses(:,2,1,:));  % Save for Cond2&ROI1
dlmwrite('~/Desktop/TimeCourses_con3.csv',TimeCourses(:,3,1,:));  % Save for Cond3&ROI1
dlmwrite('~/Desktop/TimeCourses_con4.csv',TimeCourses(:,4,1,:));  % Save for Cond4&ROI1