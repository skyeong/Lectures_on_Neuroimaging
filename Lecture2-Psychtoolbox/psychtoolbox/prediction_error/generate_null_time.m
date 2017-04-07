addpath('/Volumes/JetDrive/workshops/Matlab/lecture2/optseq2');

% Setting for null time
muNull  = 2;
nNull   = 30;
Nkeep   = 2;
psdwin  = [0.5 6];
outflag = 'null-n30';
generate_null(muNull,nNull,Nkeep,psdwin,outflag);


% Setting for null time
muNull  = 2;
nNull   = 40;
Nkeep   = 2;
psdwin  = [0.5 6];
outflag = 'null-n40';
generate_null(muNull,nNull,Nkeep,psdwin,outflag);


% Setting for null time
muNull  = 2;
nNull   = 50;
Nkeep   = 2;
psdwin  = [0.5 6];
outflag = 'null-n50';
generate_null(muNull,nNull,Nkeep,psdwin,outflag);