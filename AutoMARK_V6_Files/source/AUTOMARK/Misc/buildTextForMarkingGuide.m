% this file creates the text for an assignment summary
function buildTextForMarkingGuide(studentReport)
    text = '';
    gradeTotal = inputdlg('What is the assignment total');
    folder = uigetdir(cd, 'Select the output folder of the summary');
    if folder == 0
        return;
    end
    gradeTotal = str2double(gradeTotal{1});
    totalScore = studentReport.roottemplatecell.weight - sum(studentReport.roottemplatecell.criterionweights);
    for i = 1:numel(studentReport.drawing.childsheets)
        sheetMarksArray(i) = studentReport.roottemplatecell.children(i).weight * gradeTotal/totalScore;
    end
    
    % make sure we dont round over
    while sum(round(sheetMarksArray)) > gradeTotal
        for i = 1:numel(sheetMarksArray)
            diff(i) = sheetMarksArray(i) - floor(sheetMarksArray(i));
        end
        [~, index] = min(diff);
        sheetMarksArray(index) = floor(sheetMarksArray(index));
    end
    % make sure we dont round under
    while sum(round(sheetMarksArray)) ~= gradeTotal
        for i = 1:numel(sheetMarksArray)
            diff(i) = sheetMarksArray(i) - floor(sheetMarksArray(i));
        end
        [~, index] = max(diff);
        sheetMarksArray(index) = ceil(sheetMarksArray(index));
    end
    % loop through sheets
    for i = 1:numel(studentReport.drawing.childsheets)
        billMarks = 0;
        dimMarks = 0;
        lineMarks = 0;
        markMarks = 0;
        datumMarks = 0;
        balloonMarks = 0;
        sheetMarks = sheetMarksArray(i);
        text =  strcat(text, 'A DRW of', " ", studentReport.drawing.childsheets(i).name, " (", int2str(sheetMarks), " Marks)\n");
        % bill of materials
        if numel(studentReport.drawing.childsheets(i).childboms) > 0
            j = 1;
            while(~strcmp(class(studentReport.roottemplatecell.children(i).children(j).onFeature), 'comparableBOM'))
                j = j + 1;
            end
            billMarks = studentReport.roottemplatecell.children(i).children(j).weight * gradeTotal/totalScore;
            if (round(billMarks) > 0)
                text = strcat(text, "    Correct Bill of Materials (", int2str(round(billMarks)), " Marks)\n");
            end
        end
        
        % dimensions
        if numel(studentReport.drawing.childsheets(i).childdims) > 0
            dimMarks = 0;
            for j = 1:numel(studentReport.roottemplatecell.children(i).children)
                for q = 1:numel(studentReport.roottemplatecell.children(i).children(j).children)
                    if strcmp(class(studentReport.roottemplatecell.children(i).children(j).children(q).onFeature), 'comparableDimension')
                        dimMarks = studentReport.roottemplatecell.children(i).children(j).children(q).weight + dimMarks;
                    end
                end
            end
            dimMarks = dimMarks * gradeTotal/totalScore;
            if (round(dimMarks) > 0)
                text = strcat(text, "    Correct Dimensions (", int2str(round(dimMarks)), " Marks)\n");
            end
        end
        if numel(studentReport.drawing.childsheets(i).childcenterlines) > 0
            lineMarks = 0;
            for j = 1:numel(studentReport.roottemplatecell.children(i).children)
                for q = 1:numel(studentReport.roottemplatecell.children(i).children(j).children)
                    if strcmp(class(studentReport.roottemplatecell.children(i).children(j).children(q).onFeature), 'comparableCenterline')
                        lineMarks = studentReport.roottemplatecell.children(i).children(j).children(q).weight + lineMarks;
                    end
                end
            end
            lineMarks = lineMarks * gradeTotal/totalScore;
            if (round(lineMarks) > 0)
                text = strcat(text, "    Correct Centerlines (", int2str(round(lineMarks)), " Marks)\n");
            end
        end
        if numel(studentReport.drawing.childsheets(i).childcentermarks) > 0
            markMarks = 0;
            for j = 1:numel(studentReport.roottemplatecell.children(i).children)
                for q = 1:numel(studentReport.roottemplatecell.children(i).children(j).children)
                    if strcmp(class(studentReport.roottemplatecell.children(i).children(j).children(q).onFeature), 'comparableCentermark')
                        markMarks = studentReport.roottemplatecell.children(i).children(j).children(q).weight + markMarks;
                    end
                end
            end
            markMarks = markMarks * gradeTotal/totalScore;
            if (round(markMarks) > 0)
                text = strcat(text, "    Correct Centermarks (", int2str(round(markMarks)), " Marks)\n");
            end
        end
        if numel(studentReport.drawing.childsheets(i).childdatums) > 0
            datumMarks = 0;
            for j = 1:numel(studentReport.roottemplatecell.children(i).children)
                for q = 1:numel(studentReport.roottemplatecell.children(i).children(j).children)
                    if strcmp(class(studentReport.roottemplatecell.children(i).children(j).children(q).onFeature), 'comparableDatum')
                        datumMarks = studentReport.roottemplatecell.children(i).children(j).children(q).weight + datumMarks;
                    end
                end
            end
            datumMarks = datumMarks * gradeTotal/totalScore;
            if (round(datumMarks) > 0)
                text = strcat(text, "    Correct Datums (", int2str(round(datumMarks)), " Marks)\n");
            end
        end
        if numel(studentReport.drawing.childsheets(i).childballoons) > 0
            balloonMarks = 0;
            for j = 1:numel(studentReport.roottemplatecell.children(i).children)
                for q = 1:numel(studentReport.roottemplatecell.children(i).children(j).children)
                    if strcmp(class(studentReport.roottemplatecell.children(i).children(j).children(q).onFeature), 'comparableBallon')
                        balloonMarks = studentReport.roottemplatecell.children(i).children(j).children(q).weight + balloonMarks;
                    end
                end
            end
            balloonMarks = balloonMarks * gradeTotal/totalScore;
            if (round(balloonMarks) > 0)
                text = strcat(text, "    Correct Ballons (", int2str(round(balloonMarks)), " Marks)\n");
            end
        end
        otherMarks = sheetMarks - round(markMarks) - round(balloonMarks) - round(billMarks)...
            - round(dimMarks) - round(lineMarks)- round(datumMarks);
        if otherMarks > 0
            text = strcat(text, "    Correctness of Sheet and View Properties (", int2str((otherMarks)), " Marks)\n");
        end
    end
    fid = fopen(fullfile(folder, 'MarkingSummary.txt'), 'w');
    fprintf(fid, text);
    fclose(fid);
end