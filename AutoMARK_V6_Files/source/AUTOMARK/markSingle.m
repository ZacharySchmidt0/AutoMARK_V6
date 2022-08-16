function markSingleSub(stuFolder, keyTemplate, markingGUI)
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