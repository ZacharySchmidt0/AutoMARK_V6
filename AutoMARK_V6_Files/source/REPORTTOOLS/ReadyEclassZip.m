function ReadyEclassZip(eclassfullpath, eclassstudentdir)
%READYECLASSZIP Take a zip file from EClass, and unzip it for Automark.
% This is how we assume the eclass zip file to be made
%
% eclass.zip
%       |
%       |- Student123123 - {Stuff}
%       |
%       |- Student213122 - {Stuff}
%       |
%       |- ...

if nargin < 1
    [eclasszip, eclasszippath] = uigetfile("*.zip", "Please select the eclass zip file");
    eclassfullpath = strcat(eclasszippath, eclasszip);
end

if nargin < 2
    eclassstudentdir = uigetdir('',"Please select the output location for the eclass folder");
end

% First do the top level unzipping
% For this we make a temp folder, and place the files in it
mkdir(eclassstudentdir, 'TEMPFILES');
tempFolder = fullfile(eclassstudentdir, 'TEMPFILES', filesep);   % Temp folder

stufiles = unzip(eclassfullpath, tempFolder);              % Unpack into it
allstudirectories = dir(tempFolder);                       % Check the names of the folders we just unpacked

% Skip "\. and \.."
for stu = 3:numel(allstudirectories)
    [~, ~, ext] = fileparts(allstudirectories(stu).name);
    % if student submitted a zip file
    if(strcmp(ext, '.zip'))
        filenames = unzip(fullfile(allstudirectories(stu).folder, allstudirectories(stu).name),...
            fullfile(allstudirectories(stu).folder));
        newStudentDir = fullfile(allstudirectories(stu).folder, allstudirectories(stu).name(1:end-4));
        for ind = 1:numel(filenames)
            currentFile = filenames{ind};
            index = strfind(currentFile, '\');
            % already there
            if(~strcmp(currentFile(index(end-1)+1:index(end)-1), allstudirectories(stu).name(1:end-4)))
                movefile(currentFile, newStudentDir);
            end
        end
        delete(fullfile(allstudirectories(stu).folder, allstudirectories(stu).name));
        replaceStruct = dir(fullfile(allstudirectories(stu).folder));
        % need to get rid of old zip files for next process
        for ind = 3:numel(replaceStruct)
            if strcmp(replaceStruct(ind).name, allstudirectories(stu).name(1:end-4))
                allstudirectories(stu) = replaceStruct(ind);
                break;
            end
        end
    end
    makeStudentFolder(allstudirectories(stu));
end

% Delete Temp Directory
rmdir(tempFolder);

    function makeStudentFolder(studentStruct)
        
        if ~studentStruct.isdir
            % Not a directory
            return
        end
        
        mkdir(eclassstudentdir, studentStruct.name);
        studentfolder = fullfile(eclassstudentdir, studentStruct.name, filesep); % This is the student folder
        studenttempfolder = fullfile(studentStruct.folder, studentStruct.name);  % This is the temp folder 
        
        % Make the various folders that are supposed to be there
        % mkdir(studentfolder, 'Student');    % <--- This is where everything gets placed from the temp folder
        mkdir(studentfolder, 'Sheets');
        mkdir(studentfolder, 'ReportImages');
        mkdir(studentfolder, 'EclassExport');
        mkdir(studentfolder, 'MatlabVariables');
        mkdir(studentfolder, 'KeySheets');
        
        % This is the student's "Student" folder
        studentstudentfolder = fullfile(studentfolder, 'Student', filesep);
        
        % Take the tempfolder, and just move and rename it to the 'Student'
        % Folder
        movefile(studenttempfolder, studentstudentfolder, 'f');
        
        % Now find all zip files inside of the studentstudentfolder
        allzips = dir(fullfile(studentstudentfolder, '**', '*.zip'));
        
        % Unzip them in place
        
        for i = 1:numel(allzips)
            unzipinplace(allzips(i))
        end
        x = dir(studentstudentfolder);
        
        for i = 3:numel(x)
            if(isfolder(fullfile(x(i).folder, x(i).name)))
                tempDir = dir(fullfile(x(i).folder, x(i).name));
                for j = 3:numel(tempDir)
                    movefile(fullfile(tempDir(j).folder, tempDir(j).name), studentstudentfolder);
                end
            end
            try
                rmdir(fullfile(x(i).folder, x(i).name));
            catch
            end
        end
        
        function unzipinplace(zipstruct)
           
            [~, ~, fext] = fileparts(zipstruct.name);
            % Validate input
            assert(~zipstruct.isdir);
            assert(strcmp(fext, '.zip'));
            
            try
                unzip(fullfile(zipstruct.folder, zipstruct.name), zipstruct.folder);    % Unzip it in place
                delete(fullfile(zipstruct.folder, zipstruct.name))                      % Delete the .zip                
            catch 
                fprintf('STUDENT ZIPFILE "%s" WAS INVALID!, Check out the temp directory to see what happened\n', fullfile(zipstruct.folder, zipstruct.name));
                doRemoveTemp = false;
            end
        end
    end

% OLD, Incorrect
% % Now do this for each student file created.
%     function makeStudentFolder(zipfilefullpath)
%         % Makes a student folder for a student
%         % Takes in the full path to a zip file
%         
%         [fpath, fname, ext] = fileparts(zipfilefullpath);
%         assert(strcmp(ext, '.zip'));
%         
%         % Make the stuFolder
%         stuFolder = fullfile(fpath, fname, 'Student', filesep);
%         mkdir(fullfile(fpath, fname, filesep), 'Student');
%         
%         % Make all the others as well
%         mkdir(fullfile(fpath, fname, filesep), 'Sheets');
%         mkdir(fullfile(fpath, fname, filesep), 'ReportImages');
%         mkdir(fullfile(fpath, fname, filesep), 'EclassExport');
%         mkdir(fullfile(fpath, fname, filesep), 'MatlabVariables');
%         
%         % Move the file
%         movedFile = fullfile(stuFolder, strcat(fname, '.zip'));
%         movefile(zipfilefullpath, movedFile);
%         
%         % Now recursively unzip that file into the folder
%         recursiveFlatten(movedFile);
%         
%         function recursiveFlatten(zipfilepath)
%             % Recursively unzips a zip file in place
%             
%             [fpath_ , fname_, ext_] = fileparts(zipfilepath);
%             
%             newFiles = unzip(zipfilepath, fpath_);
%             for i = 1:numel(newFiles)
%                 fchild = newFiles{i};
%                 
%                 [~, ~, extension] = fileparts(fchild);
%                 
%                 if strcmp(extension, '.zip')
%                     recursiveFlatten(fchild)
%                 end
%             end
%             delete(zipfilepath)
%         end
%     end
end

