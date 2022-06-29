% this file returns the current automark settings
function [settings] = getSettingsArray(app)
            settingsArray = getSettings();
            settings(1:7)= {''};
            % change this number if you add more settings
            if length(settingsArray) >= 7
                settings(1:7) = cellstr(settingsArray(1:7));
            else
                settings(1:length(settingsArray)) = cellstr(settingsArray(1:end));
            end
            function settingsArray2 = getSettings()
                currentFolder = fileparts(which(mfilename));
                ind = strfind(currentFolder, '\');
                newFolder = currentFolder(1:ind(end-2)-1);
                newFolder = fullfile(newFolder,'source', 'REPORTTOOLS', 'LATEXPRINTING');
                settingsFile = fullfile(newFolder, 'DefaultReportSettings.txt');
                fid = fopen(settingsFile);
                tline = fgetl(fid);
                i = 1;
                while ischar(tline)
                  settingsArray2(i) = string(tline);
                  tline = fgetl(fid);
                  i = i +1;
                end
            end
            
end
        