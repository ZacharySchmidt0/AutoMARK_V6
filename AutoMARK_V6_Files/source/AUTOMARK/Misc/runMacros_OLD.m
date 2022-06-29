% this file runs a chosen macro on the selected folder 
function swApp = runMacros(folderPath, macroPath, moduleName,app)
            studentDir = dir(folderPath);
            swApp = 0;
            moduleName = char(moduleName);
            if strcmp(moduleName, 'Export_DRW_and_SM_vEclass1')
                studentDir = studentDir([studentDir(:).isdir]);
                studentDir = studentDir(~ismember({studentDir(:).name},{'.','..'}));
            elseif length(studentDir) >= 3
                studentDir = dir(fullfile(studentDir(3).folder, '*.slddrw'));
            end
            moduleNameC = char(moduleName);
            if isfile(macroPath)
            else
                currentFolder = fileparts(which(mfilename));
                ind = strfind(currentFolder, '\');
                newFolder = currentFolder(1:ind(end-1)-1);
                macroPath = fullfile(newFolder, strcat(moduleName(1:end-1), '.swp'));
                app.macro = macroPath;
            end
            app.logOutput(sprintf('Attempting to open solidworks'));
            try
                % Creates com object
                swApp = actxserver('SldWorks.Application');
            catch
                app.logOutput(sprintf('Failed to open'), 1);
                return;
            end
            app.logOutput(sprintf('Opened Successfully'), 2);
            % can we see solidworks
            set(swApp, 'Visible', app.visible);
            for i = 1:length(studentDir)
                % get a list of all drawing files in student dir
                if strcmp(moduleName, 'Export_DRW_and_SM_vEclass1')
                    fileList = dir(fullfile(studentDir(i).folder, studentDir(i).name, 'Student', '*.slddrw'));
                else
                    fileList = dir(fullfile(studentDir(i).folder, '*.slddrw'));
                end
                if isempty(fileList)
                    app.logOutput(sprintf("Directory %s does not contain a drawing file", fullfile(studentDir(i).folder, studentDir(i).name, 'Student')),1);
                else
                    indicies = strfind(fileList(1).folder, '\');
                    app.logOutput(sprintf('Attempting to run macro "%s" on file "%s"', macroPath,...
                        strcat(fileList(1).folder(indicies(5):end),'\', fileList(1).name)));
                    % solidworks api methods can find these on solidworks
                    % api website
                    swDocSpec = swApp.invoke('GetOpenDocSpec',strcat(fileList(1).folder,'\', fileList(1).name));
                    swDocSpec.get('FileName');
                    swDocSpec.set('ReadOnly', 0);
                    swApp.invoke('OpenDoc7', swDocSpec);
                    success = swApp.invoke('RunMacro', macroPath, moduleName, 'main');
                    if success == 1
                        app.logOutput("Macro ran successfully", 2);
                    else
                        app.logOutput("Macro failed to run", 1);
                    end
                    swApp.invoke('CloseAllDocuments', 1);
                end
                if length(fileList)> 1
                    % warning
                    app.logOutput(sprintf(['Warning directory "%s" contains multiple'...
                        ' drawings only one was extracted'], fileList(1).folder), 1);
                end
                app.logOutput(sprintf("Processed %d folders out of %d total folders", i,length(studentDir)));
            end
            
end