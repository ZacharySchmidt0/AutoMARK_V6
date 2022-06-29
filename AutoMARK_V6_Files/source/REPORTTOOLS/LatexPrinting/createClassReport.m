function createClassReport(rootStudentFolder, sheetScores, settingsArray, poorPerformers)

    count = 1;
    fileStruct = dir(fullfile(rootStudentFolder, '*.xlsx'));
    folderNameInd = strfind(rootStudentFolder, '\');
    folderName = rootStudentFolder(folderNameInd(end)+1:end);
    try
        while strcmp(fileStruct(count).name(1), '~')
            count = count + 1;
        end
    catch

    end

    [num, text, raw] = xlsread(fullfile(fileStruct(count).folder, fileStruct(count).name),1,'B:B');
    total = xlsread(fullfile(fileStruct(count).folder, fileStruct(count).name),1,'C2');
    [dateNum, dateText, dateRaw] = xlsread(fullfile(fileStruct(count).folder, fileStruct(count).name),1,'G:G');
    %make histogram for assignment
    try
        makeHistogram(num, total, folderName,rootStudentFolder);
        makeSheetHistograms(sheetScores,rootStudentFolder);
        %make Table of poor performers
        makeTable(poorPerformers,rootStudentFolder);
    catch
    end
    % FILE!
    [thisfolder, ~, ~] = fileparts(which(mfilename));
    disp(thisfolder);
    copyfile(fullfile(thisfolder, 'LetterHead.jpg'), fullfile(rootStudentFolder));
    latexTemplateFile = fileread(fullfile(thisfolder, 'classpdftemplate.tex'));

    % Open student .tex file for writing
    studentTexFile = fullfile(rootStudentFolder, 'report.tex');
    studentTexFileHandle = fopen(studentTexFile, 'w');

    % Create all our variables
    % Get the parts of the student folder
    
    sheetImages = '';
    imageDir = dir(fullfile(rootStudentFolder, '*.png'));
    for i = 1:numel(imageDir)
        if(~strcmp(imageDir(i).name, 'LetterHead.jpg'))
            line =  makeTexLineSingles(imageDir(i).name,'','studentSheetOverlay');
            sheetImages = [sheetImages,line];
        end
    end
    if length(settingsArray) >= 4
        latexTemplateFile = strrep(latexTemplateFile, '*INSTRUCTOR*', settingsArray{1});
        latexTemplateFile = strrep(latexTemplateFile, '*ASSIGNMENTNO*', settingsArray{2});
        latexTemplateFile = strrep(latexTemplateFile, '*CLASSNAME*', settingsArray{3});
        latexTemplateFile = strrep(latexTemplateFile, '*COURSENAME*', settingsArray{3});
        latexTemplateFile = strrep(latexTemplateFile, '*SEM*', settingsArray{4});
    end
    latexTemplateFile = strrep(latexTemplateFile, '%SHEETIMAGES%', sheetImages);
    fwrite(studentTexFileHandle, latexTemplateFile);

    % Copy the IncludeImages folder into the student directory. That way you
    % can have included images in your latex
   

    % Run pdf latex
    system(sprintf('pdflatex -interaction=nonstopmode -output-directory "%s" report.tex', rootStudentFolder), '-echo');
    % Move the file into eclass export
   

    % Close the student text file
    fclose(studentTexFileHandle);
    %delete report images 
    deleteExtras();
    function deleteExtras()
        delete(fullfile(rootStudentFolder, '*.png'));
        delete(fullfile(rootStudentFolder, '*.jpg'));
        delete(fullfile(rootStudentFolder, 'report.txt'));
        delete(fullfile(rootStudentFolder, 'report.tex'));
        delete(fullfile(rootStudentFolder, 'report.aux'));
    end
    function frequencyMap = mapFrequency(array)
        frequencyMap = containers.Map('KeyType','double','ValueType','any');
        for (j =0:100)
            frequencyMap(j) = 0;
        end
        for(j = 1:numel(array))
            if isKey(frequencyMap, array(j))
                frequencyMap(array(j)) = frequencyMap(array(j)) + 1;
            else
                frequencyMap(array(j)) = 1;
            end
        end
    end
    function singleline = makeTexLineSingles(name, inFolder, overlaycommand)
           % Make a tex line for a single drawing sheet.
           % Note that there are quotes around the file path, except for
           % the extension. Like "./Folder/Name 2".png
           singleline = sprintf('\\incgraph[overlay={\\%s}]{%s}\n', overlaycommand,strcat('"./', inFolder, '/', name, '"'));
    end
    
end
function makeHistogram(num, total,folderName,rootStudentFolder)
    h = histogram(round((num./total)*100), 'BinEdges', linspace(0,100,21));
    figures = ancestor(h, 'figure');
    figure(figures);
    xlabel('Mark')
    ylabel('Num Students')
    xticks(linspace(0,100,21));
    xticklabels({'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55', '60', '65', '70','75', '80', '85', '90', '95', '100'});
    title(sprintf('%sHistogram of Student Marks',folderName));

    saveas(figures,fullfile(rootStudentFolder, sprintf('%shistogram.png',folderName)));
    close(figures);
end
function makeSheetHistograms(sheetScores, rootStudentFolder)
    dims = size(sheetScores);
    %make histogram for each sheet 
    for(i = 1:dims(1))
        h = histogram(sheetScores(i, :), 'BinEdges', linspace(0,100,21));
        figures = ancestor(h, 'figure');
        figure(figures);
        xlabel('Mark')
        ylabel('Num Students')
        xticks(linspace(0,100,21));
        xticklabels({'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55', '60', '65', '70','75', '80', '85', '90', '95', '100'});
        title(sprintf('Sheet %d Student Marks',i));
       
        saveas(figures,fullfile(rootStudentFolder,sprintf('Sheet%dhistogram.png',i)));
        close(figures);
    end
end
function makeTable(poorPerformers, rootStudentFolder)
    table =  uitable('Data', [poorPerformers{2,:}]' * 100, 'ColumnName', 'Poor Performers Grades', 'RowName', {poorPerformers{1,:}});
    figures = ancestor(table, 'figure');
    figure(figures);
    table.Position = [0 0 figures.Position(3:4)];
    table.ColumnWidth = num2cell(ones(1,numel(table.Data)) * 400);
    saveas(figures,fullfile(rootStudentFolder,sprintf('poorPerformers.png')));
    close(figures);
end
