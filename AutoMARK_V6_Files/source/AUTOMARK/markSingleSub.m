function markSingleSub(stuFolder, keyTemplate, markingGUI)
    tic(); % Start timer

    criterionColours = criterionColoursClass();
    sheetScores = zeros(1, 1);

    % creates a text file in submissionFolder called "Marking Log <date>"
    logFileName = fullfile(stuFolder, sprintf('Marking Log %s.txt', datestr(now,'yyyy-mm-dd-hh-MM-ss')));
    logFile = fopen(logFileName, 'wt+');
    fprintf(logFile, 'Log Start\n\n');

    % puts data from DefaultReportSettings.txt into settingsArray
    fid = fopen('DefaultReportSettings.txt');
    lineNum = 1;
    tline = fgetl(fid);
    while ischar(tline)
        settingsArray(lineNum) = string(tline);
        lineNum = lineNum + 1;
        tline = fgetl(fid);
    end
    fclose(fid);
    
    % Mark a single student drawing folder
    markingGUI.logOutput(sprintf('Checking folder "%s"', stuFolder), 0);
    fprintf(logFile, 'Marking "%s" --\t\t\t-- ', stuFolder);
    % Look for the Excell Extract file
    drwfile = fullfile(stuFolder, 'ExcelExtract.xlsx');
    
    
    if ~exist(drwfile, 'file')
        fprintf(logFile, 'EMPTY\n');
        markingGUI.logOutput('Folder had no Excel File, Student either did not hand in a drawing or VBA failed', 1);
        return % No Excel File
    end
    
    markingGUI.logOutput('Found Excel File, attempting to mark', 0);
    % Everything beyond here is considered "Dangerous"
    
    success = true;
    
    % Variable save location, created if it doesn't exist
    variableSaveLoc = fullfile(stuFolder, 'MatlabVariables');
    if ~exist(variableSaveLoc,'dir')
        mkdir(stuFolder, 'MatlabVariables');
    end
    
    try
        % Make a comparable drawing from the excel file
        crashed_on = 'Making a drawing using the excel file';
        studentDrawing = makeComparableDrawing(drwfile);
        
        crashed_on = 'Making the marking report';
        % Make a report for them
        studentReport = markingReport2(studentDrawing);
        crashed_on = 'Executing Marking';
        % Execute marking on them
       
        studentLinker = executeMarking(keyTemplate, studentReport, criterionColours, 0);
        % files to show up in spread sheet
        titleBlockMessage = checkTitleBlock(dir(fullfile(stuFolder, 'Sheets')), studentDrawing, studentReport);
        crashed_on = 'Exporting Marked Images';
        % Export the Images and Annotations
        studentReport.exportReportImages();
        studentReport.exportMarkingDeductions();
        dims = size(sheetScores);
        flag = false;
        % check if scores have been set yet else resize
        for w = 1:dims(1)
            for h = 1:dims(2)
                if(sheetScores(w, h) ~= 0)
                    flag = true;
                    break;
                end
            end
            if flag
                break;
            end
        end
        if~(flag)
            sheetScores = zeros(numel(studentReport.sreportcells.children), length(sheetScores));
        end
        for k = 1:numel(studentReport.sreportcells.children)
            sheetScores(k,1) = 100*((studentReport.sreportcells.children(k).recentScore)/studentReport.sreportcells.children(k).weight);
        end
        
        crashed_on = 'Exporting the marks as a PDF';
        % Export a pdf for the student to look at using latex
        grade = createStudentPDF(stuFolder, studentReport, studentLinker, settingsArray, criterionColours);
        
        crashed_on = 'Copying Student .PDFs to the Eclass Export';
        % Just try this, it might not find any
        try
            copyfile(fullfile(stuFolder, 'Student', '*.pdf'), fullfile(stuFolder, 'EclassExport', filesep), 'f');
        catch
            disp('Student hand in any pdf files, This is okay');
        end
        
        % Save Variables
        % Includes a copy of the figure and a copy of the key drawing
        % and a copy of the template it got marked with
        crashed_on = 'Saving the student variables';
        save(fullfile(variableSaveLoc, sprintf('Student Variables %s.mat', datestr(now,'yyyy-mm-dd-hh-MM-ss'))), 'studentDrawing', 'studentReport', 'studentLinker', 'keyTemplate');
        
        % Delete the figure and continue
        crashed_on = 'Closing the figure';
        close(studentReport.sfigure); % Mabye not necessary
        
        crashed_on = 'Getting the student''s score';
        score = studentReport.sreportcells.getScore();
        crashed_on = 'Finished Succesfully';
    catch crashstack
        % Terrible error handling
        % Save full workspace
        save(fullfile(variableSaveLoc, sprintf('CRASH VARIABLES %s.mat', datestr(now,'yyyy-mm-dd-hh-MM-ss'))));
        close(gcf);
        success = false;
        %rethrow(me);
    end
    if size(dir([stuFolder '/Student/*.slddrw' ]),1) > 1
        markingGUI.logOutput(sprintf(['%s has %d drawing files only one of the'...
        ' files was extracted. Create multiple sheets in one drawing '...
        'file to mark all drawings'], stuFolder, size(dir([stuFolder '/Student/*.slddrw' ]),1)), 1)
        success = 'Needs Manual review';
        crashed_on = ['Multiple drawing files in student submission, only one drawing file'...
            ' was marked. Possible unmarked files'];
    end    
    if success
        fprintf(logFile, 'SUCCESS\n');
        markingGUI.logOutput('Successfully marked student!', 2);
    else
        fprintf(logFile, sprintf('FAILED! Reason: %s\n', crashed_on));
        % print file name
        fprintf(logFile, sprintf('Crashed in file: %s\n', crashstack.stack(1).name));
        % print file line
        fprintf(logFile, sprintf('On line: %d\n', crashstack.stack(1).line));
        markingGUI.logOutput(sprintf('Crashed while marking student, Reason: %s\n Check crash variables in the folder', crashed_on), 1);
        if strcmp(crashstack.stack(1).name(1:5),'mPlot')
            markingGUI.logOutput(sprintf('Possible reason for error: MATLAB computer vision toolbox is not installed\n'), 0);
            fprintf(logFile, sprintf('Possible reason for error: MATLAB computer vision toolbox is not installed\n'));
        end
    end

    % closes the Marking Log
    fprintf(logFile, '\nLog End\n');
    fclose(logFile);


    function message = checkTitleBlock(studentDIR, studentDrawing, studentReport)
        % add java classes to read pdf
        javaaddpath(fullfile(cd, 'source', 'REPORTTOOLS', 'PDFRead', 'iText-4.2.0-com.itextpdf.jar'));
        % read name block
        for l = 3:numel(studentDIR)
            try
                image = imread(fullfile(studentDIR(l).folder, strcat(studentDrawing.childsheets(l -2).name, '.png')));
                nameBox = ocr(image, [2817 2075 418 168]);
                dateBox = ocr(image, [2816, 2441, 408, 56]);
                % get text
                nameTextDrawing = split(nameBox.Text, char(10));
                nameTextDrawing = strcat(nameTextDrawing{3}, " ", nameTextDrawing{4});
                dateTextDrawing = split(dateBox.Text, char(10));
                % solid model name and dates
                modelName = studentDrawing.author;
                message = "";        
                index = strfind(studentDIR(l).folder, '\');
                pdfDIR = dir(fullfile(studentDIR(l).folder(1:(index(end)-1)), 'Student', '*.pdf'));
                if numel(pdfDIR) > 0
                    text = pdfRead(fullfile(pdfDIR(1).folder, pdfDIR(1).name));
                else 
                    return;
                end
                % find a piece of text that will always be there

                newText = split(text{l-2}, char(10));
                for k = 1:numel(newText)
                    if strcmp(newText(k), 'FILE NAME:')
                        break;
                    end
                end
                % find name and dates relative to file name
                name = newText{k-1};
                pdfDate1 = newText{k-4};
                pdfDate2 = newText{k-5};
                if ~(isdate(pdfDate1) && isdate(pdfDate2))
                    if isdate(pdfDate1)
                        if isdate(newText{k - 3})
                            pdfDate1 = newText{k-3};
                            pdfDate2 = newText{k-4};
                        end
                    elseif isdate(pdfDate2)
                        if isdate(newText{k - 6})
                            pdfDate1 = newText{k-5};
                            pdfDate2 = newText{k-6};
                        end
                    else 
                        while(~isdate(pdfDate1) && k > 1)
                            pdfDate1 = newText{k};
                            pdfDate2 = newText{k-1};
                            k = k -1;
                        end
                    end
                end
                relevantSheetHandler = studentReport.sheetToHandler(studentDrawing.childsheets(l-2));
                x = studentDrawing.childsheets(l -2).xmax - 0.2;
                y = studentDrawing.childsheets(l -2).ymin + 0.025;
                % print messages
                if isempty(strfind(studentDrawing.childsheets(l-2).childviews(1).childsolidmodel.cmodel, pdfDate2)) ...
                        || isempty(strfind(dateTextDrawing{2}, pdfDate2))
                    
                    mPlotText(relevantSheetHandler, criterionColours.misc, [x, y], 'Creation Date of model is not the same in all docs',...
                        criterionColours.fontSize, 'RightBottom',criterionColours.fontName);
                end
                if isempty(strfind(studentDrawing.childsheets(l-2).childviews(1).childsolidmodel.lsmodel, pdfDate1)) ...
                        || isempty(strfind(dateTextDrawing{1}, pdfDate1))
                    mPlotText(relevantSheetHandler, criterionColours.misc, [x, y + 0.005], 'Last saved Date of model is not the same in all docs',...
                        criterionColours.fontSize, 'RightBottom',criterionColours.fontName);
                end
                if isempty(strfind(nameTextDrawing, name))
                    mPlotText(relevantSheetHandler, criterionColours.misc, [x, y + 0.01], 'Student Name is not the same in all docs',...
                        criterionColours.fontSize, 'RightBottom',criterionColours.fontName);
                elseif strcmp(studentDrawing.author, 'Edit in DRW')
                    mPlotText(relevantSheetHandler, criterionColours.misc, [x, y + 0.01], 'Student Name is unchanged in properties',...
                        criterionColours.fontSize, 'RightBottom',criterionColours.fontName);
                elseif isempty(strfind(studentDrawing.author, name)) || isempty(strfind(nameTextDrawing, name))
                    mPlotText(relevantSheetHandler, criterionColours.misc, [x, y + 0.01], 'Student Name is not the same in all docs',...
                        criterionColours.fontSize, 'RightBottom',criterionColours.fontName);
                end
                message = "";
            catch
            end
        end
    end
end