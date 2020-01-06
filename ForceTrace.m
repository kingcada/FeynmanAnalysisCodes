%Force plot for Feynman with .lvm extension files. Not a standalone program
%since need alpha*kappa value from PowSpec to plot correct values.

% King Cada, December 2019


function out = ForceTrace(inpf,cal)

if nargin < 1
    [file, path] = uigetfile('*.lvm');
else
    [path, f, e] = fileparts(inpf);
    file = [f e];
end

if ~path
    return
end

%Uses File Exchange LVM viewer: https://www.mathworks.com/matlabcentral/fileexchange/19913-lvm-file-import
rawdat = lvm_import([path file], 0);

%This loads a struct where the data is in dat.Segment1.data
%This is a nx9 array, with columns {Time, X-force, Y-force, X-normalized, Y-normalized, Q1, Q2, Q3, Q4) }

dat = rawdat.Segment1.data;

%Time, currenty sampling at 200 Hz; there's a 20Hz delay because of the
%labview code and this will be matched later by downsampling.
T = dat(:,1);
%X values = Q1+Q3-Q2-Q4
AX = dat(:,6)+dat(:,8)-dat(:,7)-dat(:,9);
%QPD sum = Q1+Q2+Q3+Q4
AS = dat(:,6)+dat(:,7)+dat(:,8)+dat(:,9);
%Normalized_X
NX = (AX./AS);

%Baseline corrected (assumes you started at zero force)
NX1 = NX - mean(NX); 

% X- alpha*kappa
AK = (cal.AX.a*cal.AX.k);

%calculated X-Force (pN)
XF = ((NX1.*AK)*-1);

figure('Name', sprintf('ForceTrace %s', file));

%low-pass filtered to 20 Hz 
dsd = movmean(XF, 100);
tds = movmean(T, 100);
out.AX = plot(tds,dsd, 'Color', [0.0941, 0.3843, 0.8078]);

xlabel('time (sec)');
ylabel('X-Force (pN)');
set(gca,'FontSize',10);


%saves output files to folder named AnalyzedData in the same directory as
%Feynman_AnalysisCodes
[~,name]=fileparts(file);
save(['AnalyzedData/ForceTraceAnalyzed_', name, '.mat'],'cal', 'dat', 'NX1', 'XF', 'T','AS');
end
