function comparescore = compareBalloon(keyBalloon, studentBalloon)
%COMPARE Compares two balloons and assigns a score for similarity
% Balloons cannot cross link

comparescore = 100;

% Marks Lost Per / Marks Lost total
%
%   If KeyBallon xor StudentBalloon is a BOM
%   -110 and its done
%
%   If it IS a BOM Balloon
%
%   text is the title of the part (sw Title)
%  
%   If it isn't a BOM Balloon
%
%   text Matching score = 2 * levenstein / sum of lengths , * 100
%   You can't tell where they are exactly since we have no parents.

if xor(keyBalloon.isbomballoon, studentBalloon.isbomballoon)
    % One or the other
    comparescore = -10;
    
elseif keyBalloon.isbomballoon
    % Both are bom balloons -> key has a bom balloon
    % keys don't have bom ballons dangling
    % the keyview and the studentview are linked
    % therefore the student balloon must have a parent
    
    try
    keyTitle = getPartTitle(keyBalloon);
    studentTitle = getPartTitle(studentBalloon);
    
    textLoss = 100 * levenshtein(keyTitle, studentTitle) / max([1, strlength(keyTitle), strlength(studentTitle)]);
    
    comparescore = comparescore - textLoss;
    catch
       % Something went wrong, clearly these which should have had a parent, didn't!
       debugprint("Something went wrong comparing balloons, Does the key have dangling balloons on it?");
       comparescore = -10;
    end
else
    % Neither are bom balloons
    % they probably don't actually have parents, which leads to problems
    % So if this stops working, come here for problems
    
    if class(keyBalloon.text) == "missing"
        % Missing is dumb
        keyBalloon.text = "";
    end
    
    if class(studentBalloon.text) == "missing" 
        % Missing is dumb
        studentBalloon.text = "";
    end
    
    textLoss = 100 * levenshtein(string(keyBalloon.text), string(studentBalloon.text)) / max([1, strlength(string(keyBalloon.text)), strlength(string(studentBalloon.text))]);
    
    % Short Notes are pointless to link
    %if min(strlength(string(keyBalloon.text)), strlength(string(studentBalloon.text))) <= 2
    %    textLoss = 110;
    %end
    
    comparescore = comparescore - textLoss;
end

% Renormalize
comparescore = normalizeScore(comparescore);

    % Complicated function to get the title of a part from the bom table
    function partTitle = getPartTitle(bomballoon)
        bview = bomballoon.parent;
        bsheet = bview.parent;
        
        bom = [];
        for i = 1:length(bsheet.childboms)
            if bsheet.childboms(i).tabletype == 2
                bom = bsheet.childboms(i);
                break
            end
        end
        
        % Long complicated title, wont ever match
         partTitle = "THISPARTISMISSINGATITLETHISISREALLYBAD!~~~~~~~~~~";
        bomnumber = str2double(bomballoon.textupper);
        
        % Can't get the part titles
        if isempty(bom) || isnan(bomnumber)
            return
        end
        
        % Item row will be the upper text in the balloons, plus one for
        % the title
        itemNumber = bomnumber;
        itemRow = itemNumber + 1; % Even if there isn't an item row table
        
        for i = 1:length(bom.coltypes)
            if bom.coltypes(i) == 202 % This is item number column
                for j = 2:bom.numrows
                    if bom.table{j, i} == itemNumber
                        itemRow = j;
                        break
                    end
                end
            end
        end
        
        for i = 1:length(bom.coltypes)
            % Look for a 'Title Column'
            if bom.coltypes(i) == 204
                % Look for the words title
                if contains(lower(bom.table{1, i}), "title")
                    partTitle = bom.table{itemRow, i};
                    return
                end
            end
            
            % Look for a 'Part Number' Column
            if bom.coltypes(i) == 201
                partTitle = bom.table{itemRow, i};
                return
            end
        end
    end
end