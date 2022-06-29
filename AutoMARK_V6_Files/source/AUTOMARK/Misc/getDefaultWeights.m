% this file returns the current automark settings
function [settings] = getSettingsArray(app)
            settingsArray = getSettings();
            settings(1:6)= {''};
            % change this number if you add more settings
            if length(settingsArray) >= 6
                settings(1:6) = cellstr(settingsArray(1:6));
            else
                settings(1:length(settingsArray)) = cellstr(settingsArray(1:end));
            end
            function settingsArray2 = getSettings()
                currentFolder = fileparts(which(mfilename));
                ind = strfind(currentFolder, '\');
                newFolder = currentFolder(1:ind(end-2)-1);
                newFolder = fullfile(newFolder,'source','AUTOMARK','MarkingCriterion','BaseCriterion');
                settingsFile = fullfile(newFolder, 'DefaultWeights.txt');
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
        