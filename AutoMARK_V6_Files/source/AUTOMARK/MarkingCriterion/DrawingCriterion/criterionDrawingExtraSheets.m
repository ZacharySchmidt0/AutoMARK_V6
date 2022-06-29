classdef criterionDrawingExtraSheets < baseCriterion
    %CRITERIONSHEETORDER Criterion which evaluates sheet order.
    
    methods
        function obj = criterionDrawingExtraSheets(recommendedweight)
            %CRITERIONSHEETORDER Construct an instance of this class
            %   Sets recommended weight.
            obj.recommendedweight = recommendedweight;
            obj.description = "Checks for the existance of extra sheets on the drawing";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations, criterionColours)
            % Correct if all sheets, which were properly linked
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            % An extra sheet is any sheet on the student drawing which
            % doesn't belong!
            
            for i = 1:studentFeature.numsheets
                
                studentSheet = studentFeature.childsheets(i);
                
                keySheet = linker.returnPair(studentSheet);
                
                if isempty(keySheet)
                    if doAnnotations
                        % Add a comment
                        studentReport.addComment(sprintf("Found a sheet %s which couldn't be recognized in the key!", studentSheet.name));
                        
                        % Now highlight this!
                        sheetHandler = studentReport.sheetToHandler(studentSheet);
                        
                        [center] = hprincipleLocation(studentSheet);
                        [corner1, corner2] = hrectangleLocation(studentSheet);
                        
                        
                        mPlotText(sheetHandler, criterionColours.unrecognized, center, "UNRECOGNIZED SHEET",...
                            criterionColours.fontSize, 'Center',criterionColours.fontName); 
                        mPlotRectangle(sheetHandler, criterionColours.unrecognized, corner1, corner2);
                    end
                    multiplier = multiplier + 1;
                end
            end
            
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment("No Extra Drawing Sheets were found!");
                else
                    studentReport.addComment("Extra Drawing Sheets were found!");
                end
            end
        end
    end
end

