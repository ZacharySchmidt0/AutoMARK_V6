classdef criterionDrawingSheetOrder < baseCriterion
    %CRITERIONSHEETORDER Criterion which evaluates sheet order.
    
    methods
        function obj = criterionDrawingSheetOrder(recommendedweight)
            %CRITERIONSHEETORDER Construct an instance of this class
            %   Sets recommended weight.
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if sheets are in order, false otherwise. Missing sheets are assumed correct and Extra sheets are ignored";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations, criterionColours)
            % Correct if all sheets, which were properly linked, were in
            % order.
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            i = 1; % Student index
            j = 1; % Key index
            
            % Keep going
            while i <= studentFeature.numsheets && j <= keyFeature.numsheets
                
                sSheet = studentFeature.childsheets(i);
                kSheet = keyFeature.childsheets(j);
                
                sPair = linker.returnPair(sSheet);
                kPair = linker.returnPair(kSheet);
                
                % Misses are skipped
                if isempty(sPair)
                    i = i + 1;
                    continue
                end
                
                if isempty(kPair)
                    j = j + 1;
                    continue
                end
                
                if sPair ~= kSheet || kPair ~= sSheet
                    % Bad
                    multiplier = 1;
                    break
                else
                    % Good
                    i = i + 1;
                    j = j + 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment("Drawing Sheets were found to be in order!");
                else
                    studentReport.addComment("Drawing Sheets were not found to be in correct order!");
                end
            end
        end
    end
end

