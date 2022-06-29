function [isValid, madeChanges] = validateMarkingTemplate(keyTemplate)
% VALIDATEMARKINGTEMPLATE Trys to Validate a marking Template is actually a
% valid template.

isValid = false;
madeChanges = false;

% Simple check, test if its good
if verify()
   isValid = true;
   return
end

% If its not, Get them to select another
[fname, fpath] = uigetfile('*.xlsx', "Couldn't locate this template's images, please direct to the xlsx file used to create it");

% Hot patch the key template with this
keyTemplate.drawing.studentReportFolder = fullfile(fpath, filesep);

madeChanges = true;
    
% Simple check, test if its good
if verify()
   isValid = true;
   return
end

% If its still just give up and return false!

    function isGood = verify()
        isGood = false;
        
        % Check if each of the drawing sheets has its images
        for i = 1:numel(keyTemplate.drawing.childsheets)
           sheet = keyTemplate.drawing.childsheets(i);
           
           % If it doesn't then its not good
           if ~exist(fullfile(keyTemplate.drawing.studentReportFolder, 'Sheets', strcat(sheet.name, '.png')), 'file')
               return
           end
        end
        
        % If we passed then we are good
        isGood = true;
    end
end

