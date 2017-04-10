function f_mri = get_filepath(fname)
[fmripath,f,e] = fileparts(fname);
fmriname = [f e];

f_mri=cell(0);

if isempty(fname),
    error('There are no functional MRI images.\n');
    return;
else,
    v=1;
    fn = fullfile(fmripath, fmriname);
    vs = spm_vol(fn);
    if length(vs)>1,
        for j=1:length(vs),
            f_mri{v} = [fullfile(fmripath, fmriname) ',' num2str(j)];
            v = v+1;
        end
    else,
        f_mri{v} = fullfile(fmripath, fmriname);
        v = v+1;
    end
end

f_mri = [f_mri'];
