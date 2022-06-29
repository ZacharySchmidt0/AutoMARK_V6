function state = fillSolidModelHeaders(state)
% Does the same as fillSheetHeaders but for SolidModels instead!

% Build a new solid model
createdsm = comparableViewModel();

% Link em up boys
state.currentview.addSolidModel(createdsm);

debugprint("Filling out a SM header", 2);

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
        case "view sm name"
            createdsm.name = state.excel{state.linenumber+1,col};
        case "pathname"
            createdsm.path = state.excel{state.linenumber+1,col};
        case "sm title"
            createdsm.title = state.excel{state.linenumber+1,col};
        case "sm subject"
            createdsm.subject = state.excel{state.linenumber+1,col};
        case "sm author"
            createdsm.author = state.excel{state.linenumber+1,col};
        case "sm keywords"
            createdsm.keywords = state.excel{state.linenumber+1,col};
        case "sm comment"
            createdsm.comment = state.excel{state.linenumber+1,col};  
        case "sm savedby"
            createdsm.savedby = state.excel{state.linenumber+1,col};
        case "smcreatedate"
            createdsm.cmodel = state.excel{state.linenumber+1,col};
        case "sm savedate"
            createdsm.lsmodel = state.excel{state.linenumber+1,col};
        case "sm x"
            createdsm.x = state.excel{state.linenumber+1,col};
        case "sm y"
            createdsm.y = state.excel{state.linenumber+1,col};
        case "sm z"
            createdsm.z = state.excel{state.linenumber+1,col};
        case "sm volume"
            createdsm.volume = state.excel{state.linenumber+1,col};
        case "sm surfacearea"
            createdsm.surfacearea = state.excel{state.linenumber+1,col};
        case "sm mass"
            createdsm.mass = state.excel{state.linenumber+1,col};
        case "sm density"
            createdsm.density = state.excel{state.linenumber+1,col};
        case "sm lxx"
            createdsm.LXX = state.excel{state.linenumber+1,col};
        case "sm lyy"
            createdsm.LYY = state.excel{state.linenumber+1,col};
        case "sm lzz"
            createdsm.LZZ = state.excel{state.linenumber+1,col};
        case "sm lxy"
            createdsm.LXY = state.excel{state.linenumber+1,col};
        case "sm lzx"
            createdsm.LZX = state.excel{state.linenumber+1,col};
        case "sm lyz"
            createdsm.LYZ = state.excel{state.linenumber+1,col};
        case "custom properties" % Fancy column
            % For all the (number of custom properties columns following)
            for i = 1:state.excel{state.linenumber+1,col}
                col = col + 1;
                % The property name is the column header, the property
                % itself is underneath
                createdsm.customproperties(state.excel{state.linenumber,col}) = state.excel{state.linenumber+1,col};
            end
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% Now just move the line number two forward!
state.linenumber = state.linenumber + 2;
end
