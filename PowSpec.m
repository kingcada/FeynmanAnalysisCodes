% This function is to be used for LabView output files .lvm from Feynman.
% The output of this function will be the calculated power spectrum density
% and plotted individually. 

%King Cada, December 2019

function out = PowSpec(inpf, inOpts)

if nargin < 1
    [file, path] = uigetfile('*.lvm');
else
    [path, f, e] = fileparts(inpf);
    file = [f e];
end

if ~path
    return
end

%Default options
opts.ra = 1500/2; %Bead radius, nm
opts.colors = {[.2039 .5961 .8588] [.1608 .5020 .7255]};
opts.Fmin = 1;
opts.Fmax = 5e3;
opts.lortype = 2;
opts.wV = 9.5e-10;

%Use File Exchange LVM viewer: https://www.mathworks.com/matlabcentral/fileexchange/19913-lvm-file-import
rawdat = lvm_import([path file], 0);

if nargin > 1
    opts = handleOpts(opts, inOpts);
end

colors = opts.colors;

%This loads a struct where the data is in dat.Segment1.data
%This is a nx5 array, with columns {Time Q1 Q2 Q3 Q4}; Q1  Q2
%                         Where the QPD quadrants are: Q3  Q4
dat = rawdat.Segment1.data;

%Fs = diff(time);
opts.Fs = 1/median(diff(dat(:,1)));
%X = Q1+Q3-Q2-Q4
AX = dat(:,2)+dat(:,4)-dat(:,3)-dat(:,5);
%Y = Q1+Q2-Q3-Q4
AY = dat(:,2)+dat(:,3)-dat(:,4)-dat(:,5);
%S = Q1+Q2+Q3+Q4
AS = dat(:,2)+dat(:,3)+dat(:,4)+dat(:,5);

opts.nBin = round(length(AS)/200/2); %Closest divisor for 200 bins
opts.Sum = mean(AS);

figure('Name', sprintf('PowSpec %s', file));

opts.ax = subplot(2,1,1);
opts.color = colors{1};
out.AX = Calibrate(AX./AS, opts);

xlabel('Frequency(Hz)');
ylabel('X-PSD (V^2/Hz)');

opts.color = colors{2};
opts.ax = subplot(2,1,2);
out.AY = Calibrate(AY./AS, opts);

xlabel('Frequency(Hz)');
ylabel('Y-PSD (V^2/Hz)');

end



