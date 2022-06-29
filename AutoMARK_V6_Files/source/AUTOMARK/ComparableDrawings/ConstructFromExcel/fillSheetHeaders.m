function state = fillSheetHeaders(state)    % State contains everything we need to know
% This function actually does a bit more than just "filling a header", that
% name is just there for historic reasons. It actually is responsible for
% the complete building of a sheet.

% Build a new sheet!
state.currentsheet = comparableSheet();
state.currentview = state.currentsheet; % The current view is also the current sheet for balloons (notes)
state.currentdrawing.addSheet(state.currentsheet);

debugprint("Filling out a sheet header", 2);

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
        case "sheet name"
            state.currentsheet.name = state.excel{state.linenumber+1,col};
        case "view_xmin"
            state.currentsheet.xmin = state.excel{state.linenumber+1,col};
        case "view_ymin"
            state.currentsheet.ymin = state.excel{state.linenumber+1,col};
        case "view_xmax"
            state.currentsheet.xmax = state.excel{state.linenumber+1,col};
        case "view_ymax"
            state.currentsheet.ymax = state.excel{state.linenumber+1,col};
        case "view_x"
            state.currentsheet.x = state.excel{state.linenumber+1,col};
        case "view_y"
            state.currentsheet.y = state.excel{state.linenumber+1,col};
        case "viewtype"
            state.currentsheet.viewtype = state.excel{state.linenumber+1,col};
        case "papersize"
            state.currentsheet.papersize = state.excel{state.linenumber+1,col};
        case "templatein"
            state.currentsheet.templatein = state.excel{state.linenumber+1,col};
        case "scale_1"
            state.currentsheet.scale1 = state.excel{state.linenumber+1,col};
        case "scale_2"
            state.currentsheet.scale2 = state.excel{state.linenumber+1,col};
        case "proj_angle"
            state.currentsheet.projangle = state.excel{state.linenumber+1,col};
        case "width"
            state.currentsheet.width = state.excel{state.linenumber+1,col};
        case "height"   
            state.currentsheet.height = state.excel{state.linenumber+1,col};
        case "numviews"   
            state.currentsheet.numviews = state.excel{state.linenumber+1,col};
        case "numballoons"   
            state.currentsheet.numballoons = state.excel{state.linenumber+1,col};
        case "nums_dim"   
            state.currentsheet.numtotaldims = state.excel{state.linenumber+1,col};
        case "nums_cl"   
            state.currentsheet.numtotalcenterlines = state.excel{state.linenumber+1,col};
        case "nums_cm"   
            state.currentsheet.numtotalcentermarks = state.excel{state.linenumber+1,col};
        case "nums_dat"   
            state.currentsheet.numtotaldatums = state.excel{state.linenumber+1,col};
        case "nums_b"   
            state.currentsheet.numtotalballoons = state.excel{state.linenumber+1,col};
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1; 
end
% Jump over sheet
state.linenumber = state.linenumber + 2;
end
