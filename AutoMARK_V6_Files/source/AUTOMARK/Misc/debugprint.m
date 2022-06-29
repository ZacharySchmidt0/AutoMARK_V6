    function debugprint(debugStatement, levelRequired)
% This is the logging function used throughout the script!
% essentially you can change a global variable called debug level and it
% will determine whether or not console output gets logged everywhere.

global DEBUGLEVEL

% By default you need a level of 1
if nargin < 2
    levelRequired = 1;
end

% For now the code is simple, but additional things will be added later.
if DEBUGLEVEL >= levelRequired
    disp(debugStatement);
end
end
