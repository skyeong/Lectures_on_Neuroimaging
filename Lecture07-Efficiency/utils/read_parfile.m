function [evt, nulldist] = read_parfile(fn)

if nargin<1,
    fn = 'ex2-001.par';
end

% Read .par file
fid = fopen(fn);
C = textscan(fid, '\t%f\t%d\t%f\t%f\t%s\n');
fclose(fid);

% Create Table
evt = table();
evt.onset    = C{1};
evt.type     = C{2};
evt.duration = C{3};
evt.name     = C{5};

% Extract null distribution
nulldist = evt(strcmpi(evt.name,'NULL'),:).duration;