function [excelFile, logFileName] = executeMarkingOnFolder(keyTemplate, submissionFolder, markingGUI)
% This function marks all the student submissions in submissionFolder.
% Parameter: keyTemplate {markingTemplate} template selected in MarkingGUI
% Parameter: submissionFolder {char[]} path to the "student folder"
% Parameter: markingGUI {MarkingGUI} the MarkingGUI app

% - make the comparableDrawing
% - make the markingReport2
% - executeMarking (which creates the linker)
% - exports report images
% - saves the "comparableDrawing", "Markingreport2", "linker", 
%   and a copy of the key Template in the Matlab Variables folder

poorPerformers = cell(0);
criterionColours = criterionColoursClass();

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

% creates a text file in submissionFolder called "Marking Log <date>"
logFileName = fullfile(submissionFolder, sprintf('Marking Log %s.txt', datestr(now,'yyyy-mm-dd-hh-MM-ss')));
logFile = fopen(logFileName, 'wt+');
fprintf(logFile, 'Log Start\n\n');

% excel stuff that will be used when creating the excel file
excelFile = fullfile(submissionFolder, sprintf('Marking Scores %s.xlsx', datestr(now,'yyyy-mm-dd-hh-MM-ss')));
excelCells = {'Student',                'Score',                     'Out of',                   'Grade',                    'Grade Out of', ...
              'Success',                'Reason unsuccessful',       'Time Taken (s)',           'Date Drawing was Created', 'Date Drawing was Last Saved', ...
              'Date Model Was Created', 'Date Model Was Last Saved', 'Num Drawing Files',        'Num Part Files',           'Num Assembly Files', ...
              'Num PDF Files',          'Solid Model Volume',        'Solid Model Surface Area', 'Solid Model Mass',         'Solid Model Density' ...
             };
          
% gets all the student submissions from submissionFolder
% removes the first two elements because they are the "." and ".." folders
submissionFolderContents = dir(submissionFolder);
studentFolders = submissionFolderContents([submissionFolderContents.isdir]);
studentFolders(1:2) = [];

% the actual marking process
sheetScores = zeros(1, numel(studentFolders));
studentCount = 1;
badCount = 1;
timeStart = tic;  % start stopwatch
for i = 1:numel(studentFolders)
    studentFolderStruct = studentFolders(i);
    fprintf("Attempting Folder ""%s""\n", studentFolderStruct.name); 
    markSingle(fullfile(studentFolderStruct.folder, studentFolderStruct.name));
    studentCount = studentCount + 1;
    markingGUI.TextArea.Value = sprintf("Processed %d out of %d", i, numel(studentFolders));

    % estimate time left to finish marking by finding average time to mark 
    % students already done and extrapolate to number of remaining students
    timeElapsed = toc(timeStart);
    timeLeft = (timeElapsed/i)*(numel(studentFolders)-i);
    hoursLeft = round(floor(timeLeft/3600));
    timeLeft = timeLeft - hoursLeft;
    minsLeft = round(floor(timeLeft/60));
    timeLeft = timeLeft - minsLeft;
    secsLeft = round(timeLeft);

    markingGUI.logOutput(sprintf("Estimated Time Remaining: %d hours, %d mins, %d secs", hoursLeft, minsLeft, secsLeft), 3);
end

% creates arrays that indicate if submissions are unique
unique = repmat({true}, size(excelCells, 1), 1);
uniqueModelCreateDate = repmat({true}, size(excelCells, 1), 1);
uniqueModelSaveDate = repmat({true}, size(excelCells, 1), 1);
uniqueDrawingCreateDate = repmat({true}, size(excelCells, 1), 1);
uniqueDrawingSaveDate = repmat({true}, size(excelCells, 1), 1);
unique{1} = 'Unique Dates';
uniqueModelCreateDate{1} = 'Unique Model Creation Date';
uniqueModelSaveDate{1} = 'Unique Model Last Save Date';
uniqueDrawingCreateDate{1} = 'Unique Drawing Creation Date';
uniqueDrawingSaveDate{1} = 'Unique Drawing Last Save Date';
for i = 2:numel(unique)
    for j = i+1:numel(unique)
        if isequal(excelCells{i, 9}, excelCells{j, 9})
            uniqueDrawingCreateDate{i} = false;
            uniqueDrawingCreateDate{j} = false;
            unique{i} = false;
            unique{j} = false;
        end
        if isequal(excelCells{i, 10}, excelCells{j, 10})
            uniqueDrawingSaveDate{i} = false;
            uniqueDrawingSaveDate{j} = false;
            unique{i} = false;
            unique{j} = false;
        end
        if isequal(excelCells{i, 11}, excelCells{j, 11})
            uniqueModelCreateDate{i} = false;
            uniqueModelCreateDate{j} = false;
            unique{i} = false;
            unique{j} = false;
        end
        if isequal(excelCells{i, 12}, excelCells{j, 12})
            uniqueModelSaveDate{i} = false;
            uniqueModelSaveDate{j} = false;
            unique{i} = false;
            unique{j} = false;
        end
    end
end

% closes the Marking Log
fprintf(logFile, '\nLog End\n');
fclose(logFile);

% creates a excel file in submissionFolder called "Marking Score <date>"
% adds duplicate value conditional formatting
writecell([excelCells, uniqueDrawingCreateDate, uniqueDrawingSaveDate, uniqueModelCreateDate, uniqueModelSaveDate, unique], excelFile);
Excel = actxserver('excel.application');
WB = Excel.Workbooks.Open(excelFile);
conditionI = WB.Worksheets.Item(1).Range('I:I').FormatConditions.AddUniqueValues;
conditionI.DupeUnique = 'xlDuplicate';
conditionI.Interior.Color = 1000;
conditionJ = WB.Worksheets.Item(1).Range('J:J').FormatConditions.AddUniqueValues;
conditionJ.DupeUnique = 'xlDuplicate';
conditionJ.Interior.Color = 1000;
conditionK = WB.Worksheets.Item(1).Range('K:K').FormatConditions.AddUniqueValues;
conditionK.DupeUnique = 'xlDuplicate';
conditionK.Interior.Color = 1000;
conditionL = WB.Worksheets.Item(1).Range('L:L').FormatConditions.AddUniqueValues;
conditionL.DupeUnique = 'xlDuplicate';
conditionL.Interior.Color = 1000;
WB.Save();
WB.Close();
Excel.Quit();

% creates the marking report and puts it in submissionFolder
createClassReport(submissionFolder, sheetScores, markingGUI.settings, poorPerformers);


    function markSingle(stuFolder)
        tic(); % Start timer
        gradeoutof = markingGUI.settings(6);
        grade = 0;
        [~, fname, ~] = fileparts(stuFolder);
        studentName = extractBefore(fname, '_');
        score = 0;
        scoreoutof = keyTemplate.roottemplatecell.weight;
        dateDrawingWasCreated = datetime(0, 0, 0, 0, 0, 0, 0);
        dateDrawingWasLastSaved = datetime(0, 0, 0, 0, 0, 0, 0);
        dateSolidModelWasCreated = datetime(0, 0, 0, 0, 0, 0,0);
        dateSolidModelWasLastSaved = datetime(0, 0, 0, 0, 0, 0,0);
        
        % Mark a single student drawing folder
        markingGUI.logOutput(sprintf('Checking folder "%s"', studentFolderStruct.name), 0);
        fprintf(logFile, 'Marking "%s" --\t\t\t-- ', stuFolder);
        % Look for the Excell Extract file
        drwfile = fullfile(stuFolder, 'ExcelExtract.xlsx');
        
        
        if ~exist(drwfile, 'file')
            fprintf(logFile, 'EMPTY\n');
            markingGUI.logOutput('Folder had no Excel File, Student either did not hand in a drawing or VBA failed', 1);
            excelCells = [excelCells; {studentName,                                score,                      scoreoutof,                                    grade,                                         gradeoutof{1}, ...
                                       false,                                      'No .xlsx',                 toc(),                                         dateDrawingWasCreated,                         dateDrawingWasLastSaved, ...
                                       dateSolidModelWasCreated,                   dateSolidModelWasLastSaved, size(dir([stuFolder '/Student/*.slddrw' ]),1), size(dir([stuFolder '/Student/*.sldprt' ]),1), size(dir([stuFolder '/Student/*.sldasm' ]),1), ...
                                       size(dir([stuFolder '/Student/*.pdf' ]),1)  'Invalid',                  'Invalid',                                     'Invalid',                                     'Invalid' ...
                                      }];
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
            
            dateDrawingWasCreated = studentDrawing.cdate;
            dateDrawingWasLastSaved = studentDrawing.lsdate;
            try
                dateSolidModelWasCreated = studentDrawing.childsheets(1).childviews(1).childsolidmodel.cmodel;
                dateSolidModelWasLastSaved = studentDrawing.childsheets(1).childviews(1).childsolidmodel.lsmodel;
                solidModelVolume = studentDrawing.childsheets(1).childviews(1).childsolidmodel.volume;
                solidModelSurfaceArea = studentDrawing.childsheets(1).childviews(1).childsolidmodel.surfacearea;
                solidModelMass = studentDrawing.childsheets(1).childviews(1).childsolidmodel.mass;
                solidModelDensity = studentDrawing.childsheets(1).childviews(1).childsolidmodel.density;
            catch
                dateSolidModelWasCreated = 'Invalid';
                dateSolidModelWasLastSaved = 'Invalid';
                solidModelVolume = 'Invalid';
                solidModelSurfaceArea = 'Invalid';
                solidModelMass = 'Invalid';
                solidModelDensity = 'Invalid';
            end
            
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
                sheetScores(k,studentCount) = 100*((studentReport.sreportcells.children(k).recentScore)/studentReport.sreportcells.children(k).weight);
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
            %for a sheet in the report
            if (studentReport.sreportcells.getScore()/studentReport.sreportcells.weight) < 0.5
                poorPerformers{1, badCount} = studentDrawing.author;
                poorPerformers{2, badCount} = studentReport.sreportcells.getScore()/studentReport.sreportcells.weight;
                badCount = badCount + 1;
            end
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
            'file to mark all drawings'], studentFolderStruct.name, size(dir([stuFolder '/Student/*.slddrw' ]),1)), 1)
            success = 'Needs Manual review';
            crashed_on = ['Multiple drawing files in student submission, only one drawing file'...
                ' was marked. Possible unmarked files'];
        end
        % get # of drawing files number of part files and number of
        % assembly and pdf files
        
        excelCells = [excelCells; {studentName,                                score,                      scoreoutof,                                    grade,                                         gradeoutof{1}, ...
                                   success,                                    crashed_on,                 toc(),                                         dateDrawingWasCreated,                         dateDrawingWasLastSaved, ...
                                   dateSolidModelWasCreated,                   dateSolidModelWasLastSaved, size(dir([stuFolder '/Student/*.slddrw' ]),1), size(dir([stuFolder '/Student/*.sldprt' ]),1), size(dir([stuFolder '/Student/*.sldasm' ]),1), ...
                                   size(dir([stuFolder '/Student/*.pdf' ]),1), solidModelVolume,           solidModelSurfaceArea,                         solidModelMass,                                solidModelDensity ...
                                  }];
        
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
    end
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
    function bool = isdate(dates)
        bool = false;
        dates = split(dates);
        dates = dates{1};
        dates = strrep(dates, ',', '');
        switch dates
            case 'January'
                bool = true;
            case 'February'
                bool = true;
            case 'May'
                bool = true;
            case 'April'
                bool = true;
            case 'June'
                bool = true;
            case 'July'
                bool = true;
            case 'August'
                bool = true;
            case 'September'
                bool = true;
            case 'October'
                bool = true;
            case 'November'
                bool = true;
            case 'December'
                bool = true;
            case 'Monday'
                bool = true;
            case 'Tuesday'
                bool = true;
            case 'Wednesday'
                bool = true;
            case 'Thursday'
                bool = true;
            case 'Friday'
                bool = true;
            case 'Saturday'
                bool = true;
            case 'Sunday'
                bool = true;
        end
    end
end

