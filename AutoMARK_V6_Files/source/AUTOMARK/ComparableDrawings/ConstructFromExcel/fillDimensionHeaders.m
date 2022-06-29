function state = fillDimensionHeaders(state)
% Does the same as fillSheetHeaders but for Dimensions instead!
% Much bigger than the rest :(

% There are multiple ways to determine exactly how many dimensions we should
% expect to be below the current row. I go with the simplistic approach
% here in that we just use the number in the current view!

% Build a bunch of Dimensions, Matlab is actually fairly clever about handle
% objects, this doesn't stupidly copy a bunch of pointers.

% Firstly if there aren't any then we are gone!
if state.currentview.numdims < 1
    state.linenumber = state.linenumber + 1;
    return
end
createdDimension(state.currentview.numdims) = comparableDimension();
state.currentview.addDimension(createdDimension);

debugprint("Filling out a Dimension header", 2);

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
        case "dimname"
            % Deals them out
            [createdDimension.name] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "isdangling"
            [createdDimension.isdangling] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "ann_x"
            [createdDimension.annx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "ann_y"
            [createdDimension.anny] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "type"
            [createdDimension.type] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "arrowside"
            [createdDimension.arrowside] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "arrowstyle"
            [createdDimension.arrowstyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "isholecallout"
            [createdDimension.isholecallout] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "primaryprecision"
            [createdDimension.primaryprecision] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "tolprecision"
            [createdDimension.primarytoleranceprecision] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "altprecision"
            [createdDimension.alternateprecision] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "alttolprecision"
            [createdDimension.alternatetoleranceprecision] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "chamfertextstyle"
            [createdDimension.chamfertextstyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textprefix"
            [createdDimension.textprefix] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textprefixdef"
            [createdDimension.textprefixdef] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textsuffix"
            [createdDimension.textsuffix] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textsuffixdef"
            [createdDimension.textsuffixdef] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textcallabove"
            [createdDimension.textcalloutabove] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textcallabovedef"
            [createdDimension.textcalloutabovedef] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textcallbelow"
            [createdDimension.textcalloutbelow] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "textcallbelowdef"
            [createdDimension.textcalloutbelowdef] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1value"
            [createdDimension.dimension1value] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1type"
            [createdDimension.dimension1type] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1driven"
            [createdDimension.dimension1driven] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1readonly"
            [createdDimension.dimension1readonly] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1toltype"
            [createdDimension.dimension1tolerancetype] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1tolparenthesis"
            [createdDimension.dimension1toleranceparenthesis] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1tolfittype"
            [createdDimension.dimension1tolerancefittype] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1tolstyle"
            [createdDimension.dimension1tolerancefitstyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1tolmax"
            [createdDimension.dimension1tolerancemax] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim1tolmin"
            [createdDimension.dimension1tolerancemin] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2value"
            [createdDimension.dimension2value] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2type"
            [createdDimension.dimension2type] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2driven"
            [createdDimension.dimension2driven] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2readonly"
            [createdDimension.dimension2readonly] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2toltype"
            [createdDimension.dimension2tolerancetype] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2tolparenthesis"
            [createdDimension.dimension2toleranceparenthesis] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2tolfittype"
            [createdDimension.dimension2tolerancefittype] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2tolstyle"
            [createdDimension.dimension2tolerancefitstyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2tolmax"
            [createdDimension.dimension2tolerancemax] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "dim2tolmin"
            [createdDimension.dimension2tolerancemin] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "arrow1_x"
            [createdDimension.arrow1x] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "arrow1_y"
            [createdDimension.arrow1y] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "arrow2_x"
            [createdDimension.arrow2x] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        case "arrow2_y"
            [createdDimension.arrow2y] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numdims), col};
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% One past the end!
state.linenumber = state.linenumber + state.currentview.numdims + 1;
end
