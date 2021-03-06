function linkedTogether = executeMarking(keyTemplate, studentReport, colours, viewLeeway)
% This function marks an individual student submission.

% This declares the variables used for making the score table.
% if colours.tablePosition == 1 : print table in top left
% if colours.tablePosition == 2 : print table in top mid/right
% if colours.tablePosition == 3 : print table in top right
% if colours.tablePosition == 4 : print table in bottom left
% if colours.tablePosition == 5 : print table in bottom middle
% if colours.tablePosition == 6 : print table in mid/bottom right
% POSSIBLE ANCHORPOINTS: 'LeftTop', 'LeftCenter', 'LeftBottom', 
%                        'RightTop', 'RightCenter', 'RightBottom',
%                        'CenterTop', 'CenterCenter', 'Center',
%                        'CenterBottom'
tableString = '';
switch (colours.tablePosition)
    case 1
        tablePositionX = 0.018;
        tablePositionY = 0.268;
        tableAnchor = 'LeftTop';
    case 2
        tablePositionX = 0.254;
        tablePositionY = 0.268;
        tableAnchor = 'LeftTop';
    case 3
        tablePositionX = 0.360;
        tablePositionY = 0.268;
        tableAnchor = 'LeftTop';
    case 4
        tablePositionX = 0.018;
        tablePositionY = 0.012;
        tableAnchor = 'LeftBottom';
    case 5
        tablePositionX = 0.175;
        tablePositionY = 0.012;
        tableAnchor = 'LeftBottom';
    case 6
        tablePositionX = 0.360;
        tablePositionY = 0.070;
        tableAnchor = 'LeftBottom';
    otherwise
        tablePositionX = 0.018;
        tablePositionY = 0.268;
        tableAnchor = 'LeftTop';
end

% some variable assignments... idk
keyDrawing = keyTemplate.roottemplatecell.onFeature;
studentDrawing = studentReport.studentdrawing;

% Linking happens when executing marking!
linkedTogether = drawingLinker(keyDrawing, studentDrawing);

% Marks the student report and draws the table
studentReport.sreportcells = markCells(keyTemplate.roottemplatecell, []);

% Some comment for a text file
studentReport.addComment(''); % Last Line
studentReport.addComment(sprintf('Overall Mark %g / %g', studentReport.sreportcells.getScore(), studentReport.sreportcells.weight)); % Write the score

% Update
studentReport.updateDisplay()

    % Recursively marks things!
    function resultingCell = markCells(keyTemplateCell, crsheethandler)
        resultingCell = reportCell();
        resultingCell.weight = keyTemplateCell.weight;
        keyFeature = keyTemplateCell.onFeature;
        
        studentFeature = linkedTogether.returnPair(keyFeature);
        
        % Debug, just highlight everything!
        %criterionMissing.evaluateOn(linkedTogether, keyFeature, studentReport, crsheethandler, true);
        
        if isempty(studentFeature)
            % Lose full weight of feature for being empty
            resultingCell.addDeduction("criterionMissing", keyTemplateCell.weight);
            criterionMissing.evaluateOn(linkedTogether, keyFeature, studentReport, crsheethandler, true, colours);
            return;
        end
        
        studentReport.addComment(""); % New Line
        % Missing features bug
        if(~ismissing(string(studentFeature.name)) && ~ismissing(string(studentFeature.commonTypeName)))
            studentReport.addComment(sprintf("Marking ""%s"" of type %s", studentFeature.name, studentFeature.commonTypeName));
        elseif(~ismissing(string(studentFeature.name)))
            studentFeature.commonTypeName = "Missing";
            studentReport.addComment(sprintf("Marking ""%s"" of type missing", studentFeature.name));
        elseif(~ismissing(string(studentFeature.commonTypeName)))
            studentFeature.name = "Name Missing";
            studentReport.addComment(sprintf("Marking Missing Name of type %s", studentFeature.commonTypeName));
        end
        studentReport.addComment("TAB-OUT"); % Tab in for marking and children
        
        % Sheets swap the crsheethandler
        if class(keyFeature) == "comparableSheet"
            % Currently relevant sheet handler
            crsheethandler = studentReport.sheetToHandler(studentFeature);
        end
        
        % Mark all the criterion on this
        for i = 1:numel(keyTemplateCell.criterions)
            % Mark each criterion, add its deductions           
            crit = keyTemplateCell.criterions{i};

            % If the criterion has 0 weight, it still annotates.
            % If the criterion is disabled, it does nothing!
            
            if ~keyTemplateCell.criteriondisabled(i)
                multiplier = crit.evaluateOn(linkedTogether, keyFeature, studentReport, crsheethandler, true, colours);
                resultingCell.addDeduction(string(class(crit)), keyTemplateCell.criterionweights(i) * multiplier);
            end
%             if ~keyTemplateCell.criteriondisabled(i)
%                 try
%                     multiplier = crit.evaluateOn(linkedTogether, keyFeature, studentReport, crsheethandler, true, colours);
%                     if strcmp(class(crit), 'criterionAlwaysWrong') && strcmp(studentFeature.commonTypeName, "View")
%                         if round(resultingCell.getScore() * viewLeeway/100) > keyTemplateCell.criterionweights(i)
%                             resultingCell.addDeduction(string(class(crit)), resultingCell.getScore() * viewLeeway/100 * multiplier);
%                         else
%                             resultingCell.addDeduction(string(class(crit)), keyTemplateCell.criterionweights(i) * multiplier);
%                         end
%                     else
%                         resultingCell.addDeduction(string(class(crit)), keyTemplateCell.criterionweights(i) * multiplier);
%                     end
%                     
%                 catch 
%                 end 
%             end
        end
    
        % Mark all the children
        for i = 1:numel(keyTemplateCell.children)
            nextChild = keyTemplateCell.children(i);
            resultingCell.addChild(markCells(nextChild, crsheethandler));
        end
        
        studentReport.addComment("TAB-IN");
        studentReport.addComment(sprintf("Done Marking ""%s"" of type %s", studentFeature.name, studentFeature.commonTypeName));
        studentReport.addComment(sprintf("Deduction %g/%g", resultingCell.weight - resultingCell.getScore(), resultingCell.weight));
        % plot the view score in different corners based on where view is
        if((resultingCell.weight - resultingCell.getScore()) == 0) && ~all(keyTemplateCell.criteriondisabled)
            if ~strcmp(studentFeature.commonTypeName, "Drawing")
                mPlotText(crsheethandler, colours.correct, hprincipleLocation(studentFeature),...
                                char(hex2dec('2713')), colours.fontSize, 'Center',colours.fontName);
            end
        end
        
        % This makes the score table string and gives the handler back.
        % This IF statement runs once for every drawing of every student.
        if strcmp(studentFeature.commonTypeName, "View")
            tableString = strcat(tableString, sprintf(studentFeature.name + ": %g/%g\n", resultingCell.getScore(), resultingCell.weight));
            mPlotText(crsheethandler, [255 0 0], [studentFeature.x, studentFeature.y], studentFeature.name, colours.fontSize, 'Center', colours.fontName);
        end
        
        % This makes the score table string and gives the handler back.
        % This IF statement runs once for every BOM of every student.
        if strcmp(studentFeature.commonTypeName, "Bill of Materials Table")
            tableString = strcat(tableString, sprintf(studentFeature.name + ": %g/%g\n", resultingCell.getScore(), resultingCell.weight));
            mPlotText(crsheethandler, [255 0 0], [studentFeature.xmin + (studentFeature.xmax - studentFeature.xmin)/2, studentFeature.ymin + (studentFeature.ymax - studentFeature.ymin)/2], studentFeature.name, colours.fontSize, 'Center', colours.fontName);
        end
        
        % This makes the score table string and gives the handler back.
        % This IF statement runs once for every sheet of every student.
        if strcmp(studentFeature.commonTypeName, "Sheet")
            tableString = strcat(tableString, sprintf("SHEET TOTAL: %g/%g", resultingCell.recentScore, resultingCell.weight));
            mPlotText(crsheethandler, [255 0 0], [tablePositionX, tablePositionY], tableString, colours.fontSize, tableAnchor, colours.fontName);
            tableString = '';
        end
    end
end

