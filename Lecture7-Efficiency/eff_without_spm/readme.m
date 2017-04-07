% Matlab function to calculate efficiency for fMRI GLMs.
%                     rik.henson@mrc-cbu.cam.ac.uk, 2005
%
% See for example:
%
% Henson, R.N. (2006). Efficient experimental design for fMRI. In K. Friston, J. Ashburner, S. Kiebel, T. Nichols, and W. Penny (Eds), Statistical Parametric Mapping: The analysis of functional brain images. Elsevier, London, 2006. pp. 193-210.
% http://www.mrc-cbu.cam.ac.uk/personal/rik.henson/personal/Henson_SPM_06_preprint.pdf
%
% http://imaging.mrc-cbu.cam.ac.uk/imaging/DesignEfficiency
%
% ...and used for figures in Henson (in press) "Design Efficiency". Brain Mapping: A
% comprehensive reference.
%
% Needs SPM5+ on path
% Written for ease of exposition, not speed!
%
% Function take one of:
%
%  1. cell array of stimulus onset times (SOTS), eg from SPM
%  2. vector of stimulus codes (ie order of events) (if onset times not calculated)
%  3. a transition matrix in order to generate 1+2 (if no onsets or stimulus train available)
%
% Inputs (fields of structure S):
%
%    S.Ns = Number of scans (REQUIRED)
%    S.CM = Cell array of T or F contrast matrices (NOTE THAT THE L1 NORM OF CONTRASTS SHOULD
%           MATCH IN ORDER TO COMPARE THEIR EFFICIENCIES, EG CM{1}=[1 -1 1 -1]/2 CAN BE
%           COMPARED WITH CM{2}=[1 -1 0 0] BECAUSE NORM(Cm{i},1)==2 IN BOTH CASES
%
%    S.sots    = cell array of onset times for each event-type in units of scans (OPTIONAL; SEE ABOVE)
%    S.stim    = vector of events (OPTIONAL; SEE ABOVE)
%    S.TM.prev = Np x Nh transition matrix history of Np possible sequences of the previous Nh events (OPTIONAL; SEE ABOVE)
%    S.TM.next = Np x Nj transition matrix of probabilities of each of next Nj event-types for each of Np possible histories (OPTIONAL; SEE ABOVE)
%    S.SOAmin  = minimal SOA (REQUIRED IF STIMULUS TRAIN OR TRANSITION MATRIX PROVIDED)
%    S.Ni      = Number of stimuli (events) (REQUIRED IF ONLY TRANSITION MATRIX PROVIDED)
%    S.bf = type of HRF basis function (based on spm_get_bf.m) (DEFAULTS TO CANONICAL HRF)
%    S.HC = highpass filter cut-off (s) (DEFAULTS TO 120)
%    S.TR = inter-scan interval (s) (DEFAULTS TO 2)
%    S.t0 = initial transient (s) to ignore (DEFAULTS TO 30)
%
% Outputs:
%
%    e    = efficiency for each contrast in S.CM
%    sots = stimulus onset times (in scans), eg for input into SPM
%    stim = vector of stimulus codes (event-types), just for interest!
%    X    = GLM design matrix
%    df   = degrees of freedom left given model and filter
