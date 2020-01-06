function out = processData(pfdata, pfcal)

% This function is to be used for LabView output files .lvm from Feynman.
% The user needs to input two data sets (1) trap calibration file and (2)
% measured force trace.

%King Cada, December 2019

% this gets raw calibration file
if nargin < 2
    [file, path] = uigetfile('*.lvm');
    pfcal = [path filesep file];
end

%this gets raw forcetrace file
if nargin < 1
    [file, path] = uigetfile('*.lvm');
    pfdata = [path filesep file];
end

% calculate and plot power spectrum from calibration file
cal = PowSpec(pfcal);

% plot ForceTrace from raw trace file
trace = ForceTrace(pfdata, cal);
end


