classdef criterionColoursClass
    %CRITERIONSETS Colours of things
    
    properties 
        % default values otherwise values are read in from settings file
        missing = [255, 0, 0] % Red
        unrecognized = [255, 201, 38] % Orange
        position = [7, 176, 137] % Cyan
        value = [10, 90, 240] % Blue
        misc = [214, 41, 208] % Magenta
        correct = [0, 0, 0]
        fontName = 'Times New Roman';
        fontSize = 30;
        feedbackSetting = 1;
        tablePosition = 1;
    end
    methods
        % constructtor
        function obj = criterionColoursClass
            currentFolder = fileparts(which(mfilename));
            settingsFile = fullfile(currentFolder, 'criterionColoursSettings.txt');
            fid = fopen(settingsFile);
            tline = fgetl(fid);
            i = 1;
            while ischar(tline)
                  splitLine = split(tline);
                  if~(numel(splitLine) == 3)
                      splitLine = ["0" "0" "0"]';
                  end 
                  splitLine = str2double(splitLine);
                  switch i
                      case 1
                          obj.missing = splitLine';
                      case 2
                          obj.unrecognized = splitLine';
                      case 3
                          obj.position = splitLine';
                      case 4
                          obj.value = splitLine';
                      case 5
                          obj.misc = splitLine';
                      case 6
                          obj.fontName = tline;
                      case 7
                          obj.fontSize = str2double(tline);
                      case 8
                          obj.correct = splitLine';
                      case 9
                          obj.feedbackSetting = str2double(tline);
                      case 10
                          obj.tablePosition = str2double(tline);
                      otherwise
                          break;
                  end 
                  tline = fgetl(fid);
                  i = i +1;
            end
        end
        function updateSettings(obj)
            currentFolder = fileparts(which(mfilename));
            settingsFile = fullfile(currentFolder, 'criterionColoursSettings.txt');
            fid = fopen(settingsFile, 'w');
            fprintf(fid, "%d %d %d\n", obj.missing);
            fprintf(fid, "%d %d %d\n", obj.unrecognized);
            fprintf(fid,"%d %d %d\n", obj.position);
            fprintf(fid,"%d %d %d\n", obj.value);
            fprintf(fid, "%d %d %d\n",obj.misc);
            fprintf(fid, obj.fontName);
            fprintf(fid, "\n");
            fprintf(fid, "%d\n", obj.fontSize);
            fprintf(fid, "%d %d %d\n",obj.correct);
            fprintf(fid, "%d\n",obj.feedbackSetting);
            fprintf(fid, "%d",obj.tablePosition);
        end
    end
end

