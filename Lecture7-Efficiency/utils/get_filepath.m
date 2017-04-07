function f_mri = get_filepath(fname, nscan)
[fmripath,f,e] = fileparts(fname);
fmriname = [f e];

f_mri=cell(0);

if isempty(fname),
    error('Cannot find fake fmri data.\n');
    return;
else,
    v=1;
    while (v<nscan)
        fn = fullfile(fmripath, fmriname);
        vs = spm_vol(fn);
        if length(vs)>1,
            for j=1:length(vs),
                f_mri{v} = [fullfile(fmripath, fmriname) ',' num2str(j)];
                if v==nscan, break; end
                v = v+1;
            end
        else,
            f_mri{v} = fullfile(fmripath, fmriname);
            v = v+1;
        end
    end
end

f_mri = [f_mri'];
