function createdDrawing = makeComparableDrawing(filename)
%makeComparableDrawingExcel Creates a comparable drawing from excel
% Takes in a filename (as a string) as the input and creates a comparable
% drawing object from it!
% This is THE function which hooks up Solidworks files to Automark!
% This version is based on a statemachine instead of being rgid. Hopefully
% making development go easier!


% If we don't get a filename passed in, We just request for it.
% This is for debugging, Functional calls should pass in the filename
if nargin < 1
    [filename, path] = uigetfile("*.xlsx", "Please select the output excel file");
    filename = fullfile(path, filename);
end


% This is the state
% It contains various members that get passed into the parsing functions
state.run = true;
state.linenumber = 1;
state.excel = [];               % The corresponding cell array
state.currentdrawing = [];      % The most recent drawing (static)
state.currentsheet = [];        % The most recent sheet
state.currentview = [];         % The most recent view


debugprint(sprintf("Making a new drawing from %s", filename), 1);
% Read in the Excel Sheet into a Cell Array and Construct a new Comparable
% Drawing for the data
state.excel = readcell(filename);


% Because there only exists one drawing per excel file, Instead of being
% done in the state machine, the drawing headers are filled out ahead of
% time.

% New: This is Invariant to being in the state machine

state = fillDrawingHeaders(state);
createdDrawing = state.currentdrawing;          % Return value

[path, ~, ~] = fileparts(filename);
createdDrawing.studentReportFolder = fullfile(path, filesep);   % Where the excel was found

% Both the run variable and validity of the line number are checked, The
% various fillheader functions are not responsible for line number bounds.

% Run validity is unused as of now
while (state.run) && (state.linenumber <= size(state.excel, 1))
    
    % If its not a char then you cannot put it through the state machine!
    % THIS SHOULD NOT HAPPEN in a properly created excel file
    if class(state.excel{state.linenumber, 1}) ~= "char"
        state.linenumber = state.linenumber + 1;
        debugprint(sprintf("Failed parsing line: %d Something is probably wrong", state.linenumber), 1);
        continue
    end
    
    % State machine implementation is self aligning and has many benifits.
    % The first column of the excel files now are fixed though and cannot
    % be modified without breaking the parsing.
    switch lower(state.excel{state.linenumber,1}) % Switch the first column
        
        % For each sheet ...
        case "sheet name"
            state = fillSheetHeaders(state);
        % For each BOM ...
        case "tablename"
            state = fillBOMHeaders(state);
            
        % For each view ... (comes with a solid model)
        case "view name"
            state = fillViewHeaders(state);
            
        % For each solid model (view must come first)
        case "view sm name"
            state = fillSolidModelHeaders(state);
            
        % For each dimension ...
        case "dimname"
            state = fillDimensionHeaders(state);
            
        % For each Centerline ...
        case "clinename"
            state = fillCenterlineHeaders(state);
        
        % For each Centermark ...
        case "cmarkname"
            state = fillCentermarkHeaders(state);
        
        % For each Datam ..
        case "datname"
            state = fillDatamHeaders(state);
            
        % For each Balloon ...
        case "balloonname"
            state = fillBalloonHeaders(state);
            
        otherwise
            disp('Something is Wrong!, Will try to continue but this Excel file is almost definitely malformed');
            debugprint("Line did not parse correctly, something is likely wrong", 1);
            state.linenumber = state.linenumber + 1;
    end
end

% Link views together at end, DEPRECATED
%linkViews(createdDrawing);

end

