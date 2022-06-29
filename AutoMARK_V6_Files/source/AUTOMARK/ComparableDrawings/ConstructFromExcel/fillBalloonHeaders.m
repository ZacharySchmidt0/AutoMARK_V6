function state = fillBalloonHeaders(state)
% Does the same as fillDatamHeaders but for Balloons instead!
% This is special, balloons are weird!


% Build a bunch of Balloons, Matlab is actually fairly clever about handle
% objects, this doesn't stupidly copy a bunch of pointers.

% Firstly if there aren't any then we are gone!
% Note that Sheets also have the numbballoons property
if state.currentview.numballoons < 1
    state.linenumber = state.linenumber + 1;
    return
end

% Create n balloons
createdBalloons(state.currentview.numballoons) = comparableBalloon();
state.currentview.addBalloon(createdBalloons);

debugprint("Filling out a Balloon header", 2)

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
        case "balloonname"
            % Deals them out
            [createdBalloons.name] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "isdangling"
            [createdBalloons.isdangling] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "text"
            [createdBalloons.text] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "textupper"
            [createdBalloons.textupper] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "textlower"
            [createdBalloons.textlower] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "isbomballoon"
            [createdBalloons.isbomballoon] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "isstackedballoon"
            [createdBalloons.isstackedballoon] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "center_x"
            [createdBalloons.centerx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "center_y"
            [createdBalloons.centery] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "attach_x"
            [createdBalloons.attachx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "attach_y"
            [createdBalloons.attachy] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "ann_x"
            [createdBalloons.annx] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "ann_y"
            [createdBalloons.anny] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "leaderpoints"
            [createdBalloons.leaderpoints] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "point1_x"
            [createdBalloons.point1x] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "point1_y"
            [createdBalloons.point1y] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "point2_x"
            [createdBalloons.point2x] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "point2_y"
            [createdBalloons.point2y] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "point3_x"
            [createdBalloons.point3x] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "point3_y"
            [createdBalloons.point3y] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "arrow length"
            [createdBalloons.arrowlength] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "head length"
            [createdBalloons.arrowheadlength] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "head width"
            [createdBalloons.arrowheadwidth] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        case "head style"
            [createdBalloons.arrowheadstyle] = state.excel{(state.linenumber + 1):(state.linenumber + state.currentview.numballoons), col};
        otherwise
            debugprint("This column is not handled? Has the VBA changed?", 1);
    end
    col = col + 1;
end

% Fix all the missing stuff
for i = 1:numel(createdBalloons)
    if class(createdBalloons(i).text) == "missing"
        createdBalloons(i).text = "";
    else
        createdBalloons(i).text = string(createdBalloons(i).text);
    end
    
    if class(createdBalloons(i).textupper) == "missing"
        createdBalloons(i).textupper = "";
    else
        createdBalloons(i).textupper = string(createdBalloons(i).textupper);
    end
    
    if class(createdBalloons(i).textlower) == "missing"
        createdBalloons(i).textlower = "";
    else
        createdBalloons(i).textlower = string(createdBalloons(i).textlower);
    end
end

% One past the end!
state.linenumber = state.linenumber + state.currentview.numballoons + 1;
end
