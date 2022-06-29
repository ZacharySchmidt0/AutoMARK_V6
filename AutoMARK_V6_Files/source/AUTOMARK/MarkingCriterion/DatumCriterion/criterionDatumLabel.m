classdef criterionDatumLabel < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDatumLabel(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if label matches key!";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            if ~strcmp(studentFeature.label, keyFeature.label)
                multiplier = 1;
            end
        
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Datum ""%s"" was labeled correctly", studentFeature.name));
%                     switch criterionColours.feedbackSetting
%                         case 1
%                              mPlotText(relevantSheetHandler, criterionColours.correct, hprincipleLocation(studentFeature),strcat('Label', char(hex2dec('2713'))),...
%                         criterionColours.fontSize, 'LeftCenter',criterionColours.fontName);
%                         case 2
%                             if obj.recommendedweight > 3
%                               mPlotText(relevantSheetHandler, criterionColours.correct, hprincipleLocation(studentFeature),strcat('Label', char(hex2dec('2713'))),...
%                         criterionColours.fontSize, 'LeftCenter',criterionColours.fontName);
%                             end
%                     end
                else
                    studentReport.addComment(sprintf("Datum ""%s"" wasn't labeled correctly had %s, expected %s", studentFeature.name, studentFeature.label, keyFeature.label));
                    % Value wrong
                    mPlotText(relevantSheetHandler, criterionColours.value, hprincipleLocation(studentFeature), keyFeature.label,...
                        criterionColours.fontSize, 'LeftCenter',criterionColours.fontName);
                end
            end
        end
    end
end

