% returns properly rounded grade
function grade = createStudentPDF(studentFolder, studentReport, studentLinker, settingsArray, criterionColours)
    %CREATESTUDENTPDF Creates a PDF in the student Eclass Export Folder using
    %LATEX and magic.

    studentDrawing = studentReport.studentdrawing;

    % The template, and include images, must be in the same folder as THIS
    % FILE!
    [thisfolder, ~, ~] = fileparts(which(mfilename));
    disp(thisfolder);

    latexTemplateFile = fileread(fullfile(thisfolder, 'studentpdftemplate_V2.tex'));

    % Open student .tex file for writing
    studentTexFile = fullfile(studentFolder, 'report.tex');
    studentTexFileHandle = fopen(studentTexFile, 'w');

    % Create all our variables
    % Get the parts of the student folder
    [~, fname, ~] = fileparts(studentFolder);

    students_name = extractBefore(fname, '_');
    sheet_images = makeTexCommandsForImages();
    annotation_text = fileread(fullfile(studentFolder, 'ReportImages', 'Annotations.txt'));
    score = sprintf('%g', studentReport.sreportcells.getScore());
    score_out_of = sprintf('%g', studentReport.sreportcells.weight);
    grade = sprintf('%g',settingsRound(studentReport.sreportcells.getScore() * (str2double(settingsArray(6))/studentReport.sreportcells.weight)));
    % Perform all the string replacements on tokens.
    latexTemplateFile = strrep(latexTemplateFile, '*STUDENTNAME*', students_name);
    latexTemplateFile = strrep(latexTemplateFile, '%SHEETIMAGES%', sheet_images);
    latexTemplateFile = strrep(latexTemplateFile, '%ANNOTATIONTEXT%', annotation_text);
    latexTemplateFile = strrep(latexTemplateFile, '*SCORE*', score);
    latexTemplateFile = strrep(latexTemplateFile, '*SCOREOUTOF*', score_out_of);
    latexTemplateFile = strrep(latexTemplateFile, '*GRADE*', grade);
    latexTemplateFile = strrep(latexTemplateFile, '*CORRECTCOLOR*',sprintf('%d, %d, %d', criterionColours.correct));
    latexTemplateFile = strrep(latexTemplateFile, '*CHECKMARK*',sprintf(char(hex2dec('2713'))));
    latexTemplateFile = strrep(latexTemplateFile, '*VALUECOLOUR*',sprintf('%d, %d, %d', criterionColours.value));
    latexTemplateFile = strrep(latexTemplateFile, '*MISCCOLOUR*',sprintf('%d, %d, %d', criterionColours.misc));
    latexTemplateFile = strrep(latexTemplateFile, '*POSITIONCOLOUR*',sprintf('%d, %d, %d', criterionColours.position));
    latexTemplateFile = strrep(latexTemplateFile, '*UNRECOGNIZEDCOLOUR*',sprintf('%d, %d, %d', criterionColours.unrecognized));
    latexTemplateFile = strrep(latexTemplateFile, '*MISSINGCOLOUR*',sprintf('%d, %d, %d', criterionColours.missing));
    if strcmp(class(studentDrawing.cdate), 'datetime')
        latexTemplateFile = strrep(latexTemplateFile, '*DRAWINGCREATION*', datestr(studentDrawing.cdate));
    else
        latexTemplateFile = strrep(latexTemplateFile, '*DRAWINGCREATION*', studentDrawing.cdate);
    end
    if strcmp(class(studentDrawing.lsdate), 'datetime')
        latexTemplateFile = strrep(latexTemplateFile, '*DRAWINGLASTSAVE*', datestr(studentDrawing.lsdate));
    else
    latexTemplateFile = strrep(latexTemplateFile, '*DRAWINGLASTSAVE*', studentDrawing.lsdate);
    end
    if strcmp(class(studentDrawing.childsheets(1).childviews(1).childsolidmodel.cmodel), 'datetime')
        latexTemplateFile = strrep(latexTemplateFile, '*MODELCREATION*', datestr(studentDrawing.childsheets(1).childviews(1).childsolidmodel.cmodel));
    else
        latexTemplateFile = strrep(latexTemplateFile, '*MODELCREATION*', studentDrawing.childsheets(1).childviews(1).childsolidmodel.cmodel);
    end
    if strcmp(class(studentDrawing.childsheets(1).childviews(1).childsolidmodel.lsmodel), 'datetime')
        latexTemplateFile = strrep(latexTemplateFile, '*MODELLASTSAVE*', datestr(studentDrawing.childsheets(1).childviews(1).childsolidmodel.lsmodel));
    else
        latexTemplateFile = strrep(latexTemplateFile, '*MODELLASTSAVE*', studentDrawing.childsheets(1).childviews(1).childsolidmodel.lsmodel);
    end
    
    if length(settingsArray) >= 4
        latexTemplateFile = strrep(latexTemplateFile, '*INSTRUCTOR*', settingsArray(1));
        latexTemplateFile = strrep(latexTemplateFile, '*ASSIGNMENTNO*', settingsArray(2));
        latexTemplateFile = strrep(latexTemplateFile, '*COURSENAME*', settingsArray(3));
        latexTemplateFile = strrep(latexTemplateFile, '*SEM*', settingsArray(4));
    end
    if ~isempty(settingsArray(6))
        latexTemplateFile = strrep(latexTemplateFile, '*TOTALGRADE*', settingsArray(6));
    end
    % Write evething back into the student file, as binary
    fwrite(studentTexFileHandle, latexTemplateFile);

    % Copy the IncludeImages folder into the student directory. That way you
    % can have included images in your latex
    copyfile(fullfile(thisfolder, 'IncludeImages'), fullfile(studentFolder, 'IncludeImages'), 'f');
    % Run pdf latex
    system(sprintf('pdflatex -interaction=nonstopmode -output-directory "%s" report.tex', studentFolder), '-echo');
    % Move the file into eclass export
    movefile(fullfile(studentFolder, 'report.pdf'), fullfile(studentFolder, 'EclassExport', sprintf('%s Report.pdf',students_name)), 'f');

    % Close the student text file
    fclose(studentTexFileHandle);
    grade = str2double(grade);
    
    function grade = settingsRound(percentage)
        switch settingsArray{7}
            case '1'
                grade = round(percentage);
            case '2'
                grade = ceil(percentage);
            case '3'
                grade = floor(percentage);
        end
    end
    function latexlines = makeTexCommandsForImages()
        % Get the Key Drawing!
        keyDrawing = studentLinker.returnPair(studentDrawing);

        % Copy all key sheets from key sheet folder to student folder.
        if ~exist(fullfile(studentFolder, 'KeySheets'), 'dir')
           mkdir(studentFolder, 'KeySheets');
        end
        % This actually just copies the entire folder, basically the same
        % idea
        copyfile(fullfile(keyDrawing.studentReportFolder, 'Sheets', filesep), fullfile(studentFolder, 'KeySheets', filesep), 'f');

        % Order is
        % ...
        % Student Sheet
        % Student Sheet Marked Up
        % Key Sheet
        % ...
        % OR
        % Missing Sheet
        % Key Sheet
        % ... 
        % At the end 
        % Unrecognized sheets
        %

        markedlines = '';
        unrecognizedlines = '';

        for j = 1:numel(keyDrawing.childsheets)
            keySheet = keyDrawing.childsheets(j);
            studentSheet = studentLinker.returnPair(keySheet);

            if isempty(studentSheet)
               % Missing
               % Writing latex in matlab is hard, especially with the lack
               % of multi line comments.
               %
               % This latex saves the current page size variables, makes a
               % new page of the appropriate width, writes missing on it
               % and then finally restores the page size variables
               templines = sprintf('\\savedpagewidth = \\pdfpagewidth \\savedpageheight = \\pdfpageheight\n\\eject \\pdfpagewidth = %gin \\pdfpageheight = %gin\n {\\Huge MISSING PAGE: %s}\n\\eject \\pdfpagewidth = \\savedpagewidth \\pdfpageheight = \\savedpageheight\n', keySheet.width * 100/2.54, keySheet.height * 100/2.54, keySheet.name);
            else
               % Student sheet, student marked up
               templines = sprintf('%s%s', makeTexLineSingle(studentSheet, 'Sheets', 'studentSheetOverlay'), makeTexLineSingle(studentSheet, 'ReportImages', 'studentmarkedSheetOverlay'));
            end
            %   ################################################################################################
            %
            %   REMOVE LAST ARGUMENT TO STOP LEAKING KEYS |
            %                                    V
            %   ################################################################################################
            markedlines = [markedlines, templines, makeTexLineSingle(keySheet, 'KeySheets', 'keySheetOverlay')];
            %markedlines = [markedlines, templines]; %No KEY Drawing
        end

        for j = 1:numel(studentDrawing.childsheets)
            studentSheet = studentDrawing.childsheets(j);
            keySheet = studentLinker.returnPair(studentSheet);

            if isempty(keySheet)
                % Unrecognized, but this is already marked up.
                unrecognizedlines = [unrecognizedlines, makeTexLineSingle(studentSheet, 'ReportImages', 'studentmarkedSheetOverlay')];
            end
        end

        % Join them together, Note we do this at the end because its more
        % efficient and won't result in n^2 time with memcopies
        latexlines = sprintf('%s%s', markedlines, unrecognizedlines);

        function singleline = makeTexLineSingle(drawingSheet, inFolder, overlaycommand)
           % Make a tex line for a single drawing sheet.
           % Note that there are quotes around the file path, except for
           % the extension. Like "./Folder/Name 2".png
           singleline = sprintf('\\incgraph[overlay={\\%s}]{%s}\n', overlaycommand,strcat('"./', inFolder, '/', drawingSheet.name, '".png'));
        end
    end
end
function text = replaceIllegalTokens(text)
    text = strrep(text, '#', '\#');
    text = strrep(text, '$', '\$');
    text = strrep(text, '%', '\%');
    text = strrep(text, '&', '\&');
    text = strrep(text, '~', '\~');
    text = strrep(text, '_', '\_');
    text = strrep(text, '^', '\^');
end
