%
%   MAIN ENTRY POINT FOR PROGRAM
%
% This is just a script, it populates your path with the source folder and
% then launches the Marking GUI

% Change path to HERE (not nessesary any longer!)
% if(~isdeployed())
%   cd(fileparts(which(mfilename)));
% end

% Add everything in source to path
addpath(genpath(fullfile('.', 'source')));
% Launch the marking GUI
MarkingGUI