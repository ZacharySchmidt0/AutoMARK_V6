function RepackEclassZip(dirname, zipfilefullpath,app)
%READYECLASSZIP Take a marked folder from automark, and zip it up for
%eclass

if nargin < 1
    dirname = uigetdir('',"Please select the location of the marked eclass folder");
end


if nargin < 2
    [zipfile, eclasszippath] = uiputfile("export.zip", "Save Eclass zip");
    zipfilefullpath = fullfile(eclasszippath, zipfile);
end

studentfolders = dir(dirname);
% Remove the first two, (\. and \..)
studentfolders = studentfolders(3:end);

studentzipfiles = cell(1, sum([studentfolders.isdir])); % Preallocate for speed
studentzipfileindex = 0; % Most recent nonfree
maxBytes = 400000000;
for i = 1:numel(studentfolders)
    repackstudent(studentfolders(i))
end

if studentzipfileindex > 0 % If at least a single file was found
    % Create the eclass zip
    zip(zipfilefullpath, studentzipfiles(1:studentzipfileindex));
    file = dir(zipfilefullpath);
    if file.bytes > maxBytes
       splitfile(zipfilefullpath,1, studentzipfileindex); 
    end
    % Once this is done, rename all those folders back
    
    for j = 1:studentzipfileindex
        movefile(studentzipfiles{j}, fullfile(studentzipfiles{j}, '..', 'EclassExport'));
    end
else
    disp("Nothing found to zip, aborting zip creation");
end

% This is the struct you get from using "dir"
    function repackstudent(dirstruct)
        if ~dirstruct.isdir % Ignore non-directories
            return
        end
        
        % See if the "EclassExport" Folder exists
        stuFolder = fullfile(dirstruct.folder, dirstruct.name);
        if ~exist(fullfile(stuFolder, 'EclassExport'), 'dir')
            return
        end
        
        fprintf('Packing student %s folder - ', dirstruct.name);
        
        exportFolder = dir(fullfile(stuFolder, 'EclassExport'));
        exportFolder = exportFolder(3:end); % Remove \. and \..
        
        % If its empty we cannot zip anything, thus ignore this student
        if isempty(exportFolder)
            fprintf('Found empty, nothing to export!\n');
            return
        end
        fprintf('Found files to export!\n');
        
        % Rename the eclass export folder to the correct name!
        movefile(fullfile(stuFolder, 'EclassExport', filesep), fullfile(stuFolder, dirstruct.name));
        
        % Add this to the list of files which will be zipped
        studentzipfileindex = studentzipfileindex + 1;
        studentzipfiles{studentzipfileindex} = fullfile(stuFolder, dirstruct.name);
    end
    function splitfile(zipFile, startind, endind)
        delete(zipFile);
        ind = strfind(zipFile, '.zip');
        zip2 = zipFile(1:ind-1);
        zip2(ind) = '1';
        zip2(ind+1:ind+4) = '.zip';
        app.logOutput(sprintf(['Zip file %s too large to export creating another'...
            ' zip named %s'], zipFile, zip2), 1);
        zip(zipFile, studentzipfiles{startind:floor((endind+startind)/2)});
        zip(zip2, studentzipfiles{floor((endind+startind)/2)+1:endind});
        file = dir(zipFile);
        if file.bytes > maxBytes
           splitfile(zipFile, startind, floor((endind+startind)/2)); 
        end
        file = dir(zip2);
        if file.bytes > maxBytes
           splitfile(zip2, floor((endind+startind)/2)+1, endind); 
        end
    end
end