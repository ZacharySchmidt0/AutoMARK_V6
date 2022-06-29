classdef criterionDimensionBadText < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionDimensionBadText(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if text is equal (case insensitive) or is within acceptable edit distance. Note if value is wrong, then this will also almost certainly be wrong!";
            obj.tolerancetip = "Edit distance in the Levenshtein Metric, 0 is exact match";
            obj.tolerance.editdistance = 0;
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if Within one of several rectangles
            
            % Assume correct
            multiplier = 0;
            
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            
            studentFeature = linker.returnPair(keyFeature);
            
            keyText = makeFullDimensionText(keyFeature);
            studentText = makeFullDimensionText(studentFeature);
            
            if levenshtein(studentText, keyText) > obj.tolerance.editdistance
               multiplier = 1; 
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("Dimension ""%s"" had acceptable text", studentFeature.name));
                else
                    studentReport.addComment(sprintf("Dimension ""%s"" had acceptable bad text (got %s, expected %s)", studentFeature.name, studentText, keyText));
                   
                    % Small Text, says Bad Text
                    position = hprincipleLocation(studentFeature);
                    mPlotText(relevantSheetHandler, criterionColours.value, position, 'Incorrect Text',...
                        criterionColours.fontSize, 'CenterTop', criterionColours.fontName);
                end
            end
            
            function result = makeFullDimensionText(dim)
                
                % Prefix
                if ismissing(dim.textprefix)
                    tpref = "<MISSING>";
                else
                    tpref = dim.textprefix;
                end
                
                % Prefix definition
                if ismissing(dim.textprefixdef)
                    tprefd = "<MISSING>";
                else
                    tprefd = dim.textprefixdef;
                end
                
                % Suffix
                if ismissing(dim.textsuffix)
                    tsuff = "<MISSING>";
                else
                    tsuff = dim.textsuffix;
                end
                
                % Suffix Definition
                if ismissing(dim.textsuffixdef)
                    tsuffd = "<MISSING>";
                else
                    tsuffd = dim.textsuffixdef;
                end
                
                % Callout above
                if ismissing(dim.textcalloutabove)
                    tcabove = "<MISSING>";
                else
                    tcabove = dim.textcalloutabove;
                end
                
                % Callout above definition
                if ismissing(dim.textcalloutabovedef)
                    tcaboved = "<MISSING>";
                else
                    tcaboved = dim.textcalloutabovedef;
                end
                
                % Callout below
                if ismissing(dim.textcalloutbelow)
                    tcbelow = "<MISSING>";
                else
                    tcbelow = dim.textcalloutbelow;
                end
                
                % Callout Below definition
                if ismissing(dim.textcalloutbelowdef)
                    tcbelowd = "<MISSING>";
                else
                    tcbelowd = dim.textcalloutbelowdef;
                end
                
                % This marks everything
                %result = sprintf('%s-%s-%s-%s-%s-%s-%s-%s', tpref, tprefd, tsuff, tsuffd, tcabove, tcaboved, tcbelow, tcbelowd);
                
                % This marks just what appears
                result = sprintf('%s-%s-%s-%s', tpref, tsuff, tcabove, tcbelow);
            end
        end
    end
end

