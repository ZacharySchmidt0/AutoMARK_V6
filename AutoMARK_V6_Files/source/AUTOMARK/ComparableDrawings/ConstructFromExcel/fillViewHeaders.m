function state = fillViewHeaders(state)
% Does the same as fillSheetHeaders but for Views instead!

% Build a new view
state.currentview = comparableView();
% Link em up boys
state.currentsheet.addView(state.currentview);


debugprint("Filling out a View header", 2);

% Start at the first column
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
        case "view name"
            state.currentview.name = state.excel{state.linenumber+1,col};
        case "view_xmin"
            state.currentview.xmin = state.excel{state.linenumber+1,col};
        case "view_ymin"
            state.currentview.ymin = state.excel{state.linenumber+1,col};
        case "view_xmax"
            state.currentview.xmax = state.excel{state.linenumber+1,col};
        case "view_ymax"
            state.currentview.ymax = state.excel{state.linenumber+1,col};
        case "view_x"
            state.currentview.x = state.excel{state.linenumber+1,col};
        case "view_y"
            state.currentview.y = state.excel{state.linenumber+1,col};
        case "view type"
            state.currentview.viewtype = state.excel{state.linenumber+1,col};
        case "scale_1"
            state.currentview.scale1 = state.excel{state.linenumber+1,col};
        case "scale_2"
            state.currentview.scale2 = state.excel{state.linenumber+1,col};
        case "orientation"
            state.currentview.orientation = state.excel{state.linenumber+1,col};
        case "base view"
            state.currentview.baseview = state.excel{state.linenumber+1,col};
        case "dependent views"
            state.currentview.numdependentviews = state.excel{state.linenumber+1,col};
        case "display style"
            state.currentview.displaystyle = state.excel{state.linenumber+1,col};
        case "tangent lines"
            state.currentview.tangentlines = state.excel{state.linenumber+1,col};
        case "alignment"
            state.currentview.alignment = state.excel{state.linenumber+1,col};
        case "wasmirrored"
            state.currentview.wasmirrored = state.excel{state.linenumber+1,col};
        case "sectionlabel"
            state.currentview.sectionlabel = state.excel{state.linenumber+1,col};
        case "num_dim"
            state.currentview.numdims = state.excel{state.linenumber+1,col};
        case "num_cl"
            state.currentview.numcenterlines = state.excel{state.linenumber+1,col};
        case "num_cm"
            state.currentview.numcentermarks = state.excel{state.linenumber+1,col};
        case "num_dat"
            state.currentview.numdatums = state.excel{state.linenumber+1,col};
        case "num_b"
            state.currentview.numballoons = state.excel{state.linenumber+1,col};
        case "dependent"
            state.currentview.dependents = [state.currentview.dependents, string(state.excel{state.linenumber+1,col})];
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% Now just move the line number two forward!
state.linenumber = state.linenumber + 2;
end
