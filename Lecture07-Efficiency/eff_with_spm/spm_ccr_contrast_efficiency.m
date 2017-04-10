function [eff_all, eff_comp, spectloss] = spm_ccr_contrast_efficiency(SPM,n)
global m
% e.g. load SPM;
% [eff_all, eff_comp, spectloss] = spm_ccr_contrast_efficiency(SPM,1);
% evaluates the efficiency of a given contrast, for a given design
% plots the contrast, its frequency characteristics relative to the high-
% and lowpass-filter inherent in the design, and its efficiency
% Sess(s).U(c)  -  see spm_fMRI_design for session s, contrast of
% conditions c.
% based on spm_fMRI_design_show.m
% christian ruff, october 2005

% ensure correct format of contrast
if strcmp('F',SPM.xCon(n).STAT)
    disp('Sorry - this function only works for T-contrasts!');
    return
end

c = SPM.xCon(n).c;
cname = SPM.xCon(n).name;

% make sure contrast is in right format
if size(c,1) < size(c,2), c = c'; end
if length(c) < size(SPM.xX.X,2), c = [c; zeros(size(SPM.xX.X,2) - length(c),1)]; end

% scale T-contrast to L2-norm, to make contrasts comparable
c = c * 2 / sum(abs(c));

%-Graphics...
%=======================================================================

%-Get Graphics window
%-----------------------------------------------------------------------
Fgraph = spm_figure('GetWin','Graphics');
spm_results_ui('Clear',Fgraph,0)


% plot contrast in time domain
%-----------------------------------------------------------------------
sX    = SPM.xX.X;
rX    = sX*c;
subplot(3,1,1)
plot(rX);
xlabel('scan');
ylabel('regressor[s]');
cs = cellstr(num2str(c))';
cst=[];
for i=1:length(cs)
    cst = [cst cs{i} ' '];
end

title({'Time domain',['regressors for contrast ' cname],[cst]});
grid on;
axis tight;

% Trial-specific regressors - frequency domain
%-----------------------------------------------------------------------
subplot(3,1,2); hold on;
gX    = abs(fft(rX)).^2;
gX    = gX*diag(1./sum(gX));
q     = size(gX,1);
Hz    = [0:(q - 1)]/(q*SPM.xY.RT);
q     = 2:fix(q/2);
if SPM.xX.K(1).HParam ~= Inf
    spectloss = sum(gX(Hz<1/SPM.xX.K(1).HParam));
    patch([0 1 1 0]/SPM.xX.K(1).HParam,[0 0 1.2 1.2]*max(max(gX)),[1 1 1]*.9)
else
    spectloss = 0;
end
plot(Hz(q),gX(q,:));
title({['Frequency domain, High-pass filter: ' num2str(SPM.xX.K(1).HParam) ' seconds, Spectral signal loss: ' num2str(spectloss)]})
xlabel('Frequency (Hz)')
ylabel('relative spectral density')
grid on; box on;
axis tight

% Contrast efficiency
%-----------------------------------------------------------------------

subplot(3,1,3)
%%% eff_all = trace(c'*inv(SPM.xX.X'*SPM.xX.X)*c)^-1;
eff_all = trace(c'*inv(SPM.xX.xKXs.X'*SPM.xX.xKXs.X)*c)^-1;


% calculate efficiency of single components
eff_comp = [];
for i = 1:length(c)
    comp = zeros(size(c)); comp(i)=c(i);
    eff_comp(i) = 0;
    if nnz(comp) ~= 0
        % scale contrast to L2-norm, to make contrasts comparable
        comp = comp * 2 / sum(abs(comp));
        %%%    eff_comp(i) = trace(comp'*inv(SPM.xX.X'*SPM.xX.X)*comp)^-1;
        eff_comp(i) = trace(comp'*inv(SPM.xX.xKXs.X'*SPM.xX.xKXs.X)*comp)^-1;
    end
end

bar([eff_all eff_comp]);
axis tight;
ylim([0 1.1*max([eff_all max(eff_comp)])])
pts = get(gca,'XTick');
pts = unique([1 pts]);
ptlabs = get(gca,'XTicklabel');
xtl = {'contrast'};
for i = 2:length(pts)
    xtl{i} = sprintf('comp %s',char(ptlabs(i-1,:)));
end
set(gca,'XTick',pts,'XTickLabel',xtl);

title({'Efficiency of L2-norm contrast and its components'})
xlabel('contrast (bar 1) and contrast components (bar 2:end)')
ylabel('efficiency measure')
grid on

%-Pop up Graphics figure window
%-----------------------------------------------------------------------

figure(Fgraph);
% saveas (Fgraph, ['D:\Users\fmeyer\Documents\MATLAB\loss_aversion_optimisation\simulations\stats\' num2str(m) '\eff_' num2str(c')], 'fig');
