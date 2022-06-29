function state = fillDatamHeaders(state)
% Does the same as fillSheetHeaders but for Datams instead!


% There are multiple ways to determine exactly how many datams we should
% expect to be below the current row. I go with the simplistic approach
% here in that we just use the number in the current view!

% Build a bunch of Datams, Matlab is actually fairly clever about handle
% objects, this doesn't stupidly copy a bunch of pointers.

% Firstly if there aren't any then we are gone!
if state.currentview.numdatums < 1
    state.linenumber = state.linenumber + 1;
    return
end
createdDatams(state.currentview.numdatums) = comparableDatum(); % Creates an n long vector
state.currentview.addDatum(createdDatams);

debugprint("Filling out a Datam header", 2)

% Starts at column one and goes along, It stops when we see a missing!
col = 1;
while true
    % This shouldn't happen, but will prevent us from crashing if we go
    % too far!
    if col > size(state.excel,2)
        debugprint(sprintf("Header Columns went too long? Is this a bug?"), 1);
        break
    end
    
    % This catch will stop when we hit a missing column
    if class(state.excel{state.linenumber,col}) == "missing"
        debugprint(sprintf("Done on %d columns", col), 2);
        break
    end
    
    debugprint(sprintf("Saw a %s on column %d", string(state.excel{state.linenumber,col}), col), 3);
    
    % If its not a char then you cannot put it through the switch!
    if class(state.excel{state.linenumber, col}) ~= "char"
        col = col + 1;
        continue
    end
    
    % Switch the column name, Telling us what to fill out in the sheet!
    switch lower(state.excel{state.linenumber,col}) % Lowercase to make things case insensitive
        case "datname"
            % Deals them out
            [createdDatams.name] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "isdangling"
            [createdDatams.isdangling] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "line style"
            [createdDatams.linestyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "st_x"
            [createdDatams.startx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "st_y"
            [createdDatams.starty] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "en_x"
            [createdDatams.endx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "en_y"
            [createdDatams.endy] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "display style"
            [createdDatams.displaystyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "filled triangle"
            [createdDatams.filledtriangle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        case "label"
            [createdDatams.label] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdatums), col};
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% One past the end!
state.linenumber = state.linenumber + state.currentview.numdatums + 1;
end
