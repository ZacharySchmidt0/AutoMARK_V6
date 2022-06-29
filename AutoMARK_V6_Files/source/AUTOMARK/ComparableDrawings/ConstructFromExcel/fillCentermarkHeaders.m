function state = fillCentermarkHeaders(state)
% Does the same as fillSheetHeaders but for Centermarks instead!

% Centermarks are a more complicated endevour as compared to simple
% features, because they come in groups and create problems!

% New in v6 VBA: No longer do they create problems, the grouping is all
% done magically

% Firstly if there aren't any then we are gone!
if state.currentview.numcentermarks < 1
    state.linenumber = state.linenumber + 1;
    return
end

% Create n centermarks
createdCentermarks(state.currentview.numcentermarks) = comparableCentermark();
state.currentview.addCentermark(createdCentermarks);

debugprint("Filling out a Centermark header", 2)

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
        case "cmarkname"
            % Deals them out
            [createdCentermarks.name] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "isdangling"
            [createdCentermarks.isdangling] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "group count"
            % Group creation is done at the end
            [createdCentermarks.groupcount] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "group index"
            [createdCentermarks.groupindex] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "cm_x"
            [createdCentermarks.cmx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "cm_y"
            [createdCentermarks.cmy] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "isdeleted"
            [createdCentermarks.isdeleted] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "isdetached"
            [createdCentermarks.isdetached] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "isgrouped"
            [createdCentermarks.isgrouped] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "extended_up"
            [createdCentermarks.extendedup] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "extended_left"
            [createdCentermarks.extendedleft] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "extended_down"
            [createdCentermarks.extendeddown] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "extended_right"
            [createdCentermarks.extendedright] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "gap"
            [createdCentermarks.gap] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "connection lines"
            [createdCentermarks.connectionlines] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "style"
            [createdCentermarks.style] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "show lines"
            [createdCentermarks.showlines] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "size"
            [createdCentermarks.size] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "rotation angle"
            [createdCentermarks.rotationangle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        case "doc settings"
            [createdCentermarks.docsettings] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numcentermarks), col};
        
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% Iterate down and construct all the groups.
grouptop = 1;
while grouptop <= state.currentview.numcentermarks
    groupend = grouptop + createdCentermarks(grouptop).groupcount - 1;
    % Give everyone in this group this group
    [createdCentermarks(grouptop:groupend).group] = deal(createdCentermarks(grouptop:groupend));
    grouptop = groupend + 1;
end

% One past the end!
state.linenumber = state.linenumber + state.currentview.numcentermarks + 1;
end
