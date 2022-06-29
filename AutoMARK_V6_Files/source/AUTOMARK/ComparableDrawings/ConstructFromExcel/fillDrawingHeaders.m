function state = fillDrawingHeaders(state)
% Simple Switch statement that goes along and if it finds one of the
% associated properties, adds it to the created drawing!

% Build the drawing, We are responsible for this.
state.currentdrawing = comparableDrawing();
debugprint("Filling out the drawing headers", 2)

% Starts at column one and goes along, It stops when we see a <missing>!
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
    
    % Switch on the column name, telling us what to fill out in the
    % drawing!
    switch lower(state.excel{state.linenumber,col}) % Lowercase to make things case insensitive
        case "drw_name"
            state.currentdrawing.name = state.excel{state.linenumber+1,col};
        case "drw author"
            state.currentdrawing.author = state.excel{state.linenumber+1,col};
        case "cdate" % The Conversion Here is done automatically by the new reader
            state.currentdrawing.cdate = state.excel{state.linenumber+1,col};
        case "lsdate"
            state.currentdrawing.lsdate = state.excel{state.linenumber+1,col};
        case "ls_by"
            state.currentdrawing.lsby = state.excel{state.linenumber+1,col};
        case "#sheets" % The way ints and doubles work in ranges is identical
            state.currentdrawing.numsheets = state.excel{state.linenumber+1,col};
        case "custom properties" % Fancy column
            % For all the (number of custom properties columns following)
            for i = 1:state.excel{state.linenumber+1,col}
                col = col + 1;
                % The property name is the column header, the property
                % itself is underneath
                state.currentdrawing.customproperties(state.excel{state.linenumber,col}) = state.excel{state.linenumber+1,col};
            end
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% Move over two
state.linenumber = state.linenumber + 2;

end
