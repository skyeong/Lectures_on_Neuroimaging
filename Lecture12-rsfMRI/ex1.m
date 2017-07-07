%% index in Matlab
A = zeros(10,20);
A(4:7,9:12) = 1;

figure;
imagesc(A); grid on; axis image

% search index
idx = find(A>0);


% Convert to subscript
[I, J] = ind2sub(size(A), idx);
idx2 = sub2ind(size(A), I, J);



%% Create brain mask

% specify file path
fn_GM = fullfile(spm('dir'),'tpm','grey.nii');
fn_WM = fullfile(spm('dir'),'tpm','white.nii');
fn_CSF = fullfile(spm('dir'),'tpm','csf.nii');

% read volume header information
vo_GM = spm_vol(fn_GM);
vo_WM = spm_vol(fn_WM);
vo_CSF = spm_vol(fn_CSF);

% read 3d volume image
GM = spm_read_vols(vo_GM);
WM = spm_read_vols(vo_WM);
CSF = spm_read_vols(vo_CSF);

% find idmask
idmask = find(GM>0.5);
idmask = intersect(idmask,find(WM<0.5));
idmask = intersect(idmask,find(CSF<0.5));

% Fill ones for ROI
IMG = zeros(size(GM));
IMG(idmask) = 1;

% write 3d image
vout = vo_GM;
vout.fname='brainmask.nii';
spm_write_vol(vout,IMG);

