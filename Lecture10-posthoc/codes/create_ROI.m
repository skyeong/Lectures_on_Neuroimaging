function fn_roi = create_ROI(MNIcenters,RADIUS,roi_dir,fn_mask)

if nargin<3,
    fprintf('Output directory is not defined.\nSubdirectory [rois] is automatically created in the current folder to save outputs.\n');
    roi_dir = fullfile(pwd,'rois'); 
end

space = [];
if nargin==4,
    vo_mask = spm_vol(fn_mask);
    space.dim = vo_mask.dim;
    space.mat = vo_mask.mat;
end


fn_roi = '';
nROI = length(MNIcenters);
for i=1:nROI,
    % Parameters for Sphere ROI
    params=[];
    params.centre = MNIcenters{i};
    params.radius = RADIUS;
    
    % Create Sphere ROI using [params]
    sphere_roi = maroi_sphere(params);
    
    % save ROI to MarsBaR ROI file, in current directory, just to show how
    fn_mat = sprintf('sphere_%dmm_%d_%d_%d.mat',RADIUS,MNIcenters{i});
    fn_roi{i} = fullfile(fullfile(roi_dir, fn_mat));
    saveroi(sphere_roi, fullfile(roi_dir, fn_mat));
    
    % Save as image
    fn_nii = sprintf('sphere_%dmm_%d_%d_%d.nii',RADIUS,MNIcenters{i});
    save_as_image(sphere_roi, fullfile(roi_dir, fn_nii),space);
end