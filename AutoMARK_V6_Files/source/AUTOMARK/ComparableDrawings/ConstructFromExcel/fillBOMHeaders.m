function state = fillBOMHeaders(state)
% Does the same as fillSheetHeaders but for BOMS instead!

% Build a new BOM
createdBOM = comparableBOM(); % This is a temp handle
createdBOM.contents = containers.Map;
state.currentsheet.addBOM(createdBOM);

debugprint("Filling out a BOM header", 2)

% Virtual properties, Get computed to the real ones inside a table
startx = 0;
starty = 0;
anchortype = 0;

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
        case "tablename"
            createdBOM.name = state.excel{state.linenumber+1,col};
        case "tabletype"
            createdBOM.tabletype = state.excel{state.linenumber+1,col};
        case "num_rows"
            createdBOM.numrows = state.excel{state.linenumber+1,col};
        case "num_cols"
            createdBOM.numcolumns = state.excel{state.linenumber+1,col};
        case "st_x"
            startx = state.excel{state.linenumber+1,col};
        case "st_y"
            starty = state.excel{state.linenumber+1,col};
        case "anchortype"
            anchortype = state.excel{state.linenumber+1,col};
        case "table_width"
            createdBOM.width = state.excel{state.linenumber+1,col};
        case "table_height"
            createdBOM.height = state.excel{state.linenumber+1,col};
        case "table_font"
            createdBOM.fonttype =  state.excel{state.linenumber+1,col};
        case "font_size"
            createdBOM.fontSize = state.excel{state.linenumber+1,col};
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% Compute xmin xmax
if anchortype == 1 || anchortype == 3
    % Left hand side
    createdBOM.xmin = startx;
    createdBOM.xmax = startx + createdBOM.width;
else
    % Right hand side
    createdBOM.xmin = startx - createdBOM.width;
    createdBOM.xmax = startx;
end

% Compute ymin ymax
if anchortype == 3 || anchortype == 4
    % Bottom Side
    createdBOM.ymin = starty;
    createdBOM.ymax = starty + createdBOM.height;
else
    % Top side
    createdBOM.ymin = starty - createdBOM.height;
    createdBOM.ymax = starty;
end

% Grab a section of the cell array and dump it into the BOM
beginCol = 2;
beginRow = state.linenumber + 4;

endCol = beginCol + createdBOM.numcolumns - 1; % These had better be set!
endRow = beginRow + createdBOM.numrows - 1;

% Parenthesis indexing to maintain the cells instead of creating a
% Comma seperated list.
createdBOM.table = state.excel(beginRow:endRow, beginCol:endCol);

% Grab column types
createdBOM.coltypes = [state.excel{beginRow - 2, beginCol:endCol}];
% Grab column widths
createdBOM.colwidths = [state.excel{beginRow - 1, beginCol:endCol}];
% Grab Row heights
createdBOM.rowheights = [state.excel{beginRow:endRow, 1}];
createdBOM.colNames = state.excel(beginRow, beginCol:endCol);
% Point one past end
state.linenumber = endRow + 1;

beginRow = beginRow+1;
for i = beginCol:endCol
    for j = beginRow:endRow
        key = state.excel{j, i};
        if isa(key, 'double')
            key = num2str(key);
        end
        if ~isa(key, 'char')
            key = '';
        end
        if ~isKey(createdBOM.contents, key)
            try
                createdBOM.contents(key) = 1;
            catch
                createdBOM.contents('') = 1;
            end
        else
            createdBOM.contents(key) = createdBOM.contents(key)+ 1;
        end
    end
end
end
