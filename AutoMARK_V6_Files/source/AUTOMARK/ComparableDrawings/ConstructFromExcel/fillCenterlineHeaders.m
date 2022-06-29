function state = fillCenterlineHeaders(state)
% Does the same as fillSheetHeaders but for Centerlines instead!


% There are multiple ways to determine exactly how many Centerlines we should
% expect to be below the current row. I go with the simplistic approach
% here in that we just use the number in the current view!

% Build a bunch of Centerlines, Matlab is actually fairly clever about handle
% objects, this doesn't stupidly copy a bunch of pointers.

% Firstly if there aren't any then we are gone!
col = 8;
cellArray  = {state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col}};
count = 1;
while strcmp(class(cellArray{count}), 'double')
    count = count + 1;
    if count > length(cellArray)
        break;
    end
end
state.currentview.numcenterlines = count - 1;
if state.currentview.numcenterlines < 1
    state.linenumber = state.linenumber + 1;
    return
end
createdCenterlines(state.currentview.numcenterlines) = comparableCenterline();
state.currentview.addCenterline(createdCenterlines);

debugprint("Filling out a Centerline header", 2)

% Starts at column one and goes along, It stops when we see a missing!
col = 1;
flag = false;
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
        case "clinename"
            % Deals them out
            
            [createdCenterlines.name] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "isdangling"
            [createdCenterlines.isdangling] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "colorref"
            [createdCenterlines.colorref] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "linetype"
            [createdCenterlines.linetype] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "linestyle"
            [createdCenterlines.linestyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "lineweight"
            [createdCenterlines.lineweight] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "st_x"
            [createdCenterlines.startx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "st_y"
            
            [createdCenterlines.starty] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "en_x"
            [createdCenterlines.endx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
        case "en_y"
            [createdCenterlines.endy] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col};
            temp = {state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcenterlines), col}};
            if ~strcmp(class(temp{end}), 'double')
                flag = true;
                [createdCenterlines] = createdCenterlines(1:end-1);
                break;
            end
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end
if flag
    state.linenumber = state.linenumber + state.currentview.numcenterlines;
else
    state.linenumber = state.linenumber + state.currentview.numcenterlines + 1;
end
% One past the end!

end
