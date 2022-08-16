classdef criterionSheetViewTypes < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionSheetViewTypes(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Correct if the Template matches";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Correct if sheet.templatein matches
            
            % Assume correct
            multiplier = 0;
            doAnnotations = 1;
            % You can assert that this actually does link to something, The
            % way marking works guarentees it!
            studentFeature = linker.returnPair(keyFeature);
            keyMap = obj.makeMap(keyFeature);
            stuMap = obj.makeMap(studentFeature);
            keySet = cell2mat(keys(keyMap));
            foundError(1) = false;
            errorIndex = 1;
            for i = 1:length(keySet)
                if isKey(stuMap, keySet(i))
                    if ~(stuMap(keySet(i)) == keyMap(keySet(i)))
                        multiplier = 1;
                       
                        savedKey(errorIndex) = keySet(i);
                        foundError(errorIndex) = true;
                        errorIndex = errorIndex + 1;
                    end
                else
                    if ~foundError
                       
                        savedKey(errorIndex) = keySet(i);
                        foundError(errorIndex) = false;
                        errorIndex = errorIndex + 1;
                    end
                    multiplier = 1;
                end
            end
            
            if doAnnotations
                if multiplier == 0
                    studentReport.addComment(sprintf("View types of Sheet ""%s"" was found to match", studentFeature.name));
                    switch criterionColours.feedbackSetting
                        case 1
                             mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, studentFeature.ymax - 0.005],...
                            'Correct View types', criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                        case 2
                            if obj.recommendedweight > 3
                                mPlotText(relevantSheetHandler, criterionColours.correct, [studentFeature.xmin, studentFeature.ymax - 0.005],...
                            'Correct View types', criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                            end
                    end
                else
                    studentReport.addComment(sprintf("View types of Sheet ""%s"" did not match key", studentFeature.name));
                    savedKey = savedKey(1:end);
                
                    for i = 1:(errorIndex - 1)
                        if ~foundError(i)
                            mPlotText(relevantSheetHandler, criterionColours.value,...
                                [studentFeature.xmax - 0.005, studentFeature.ymax - 0.005*i]...
                                , sprintf("No view of type %s found on sheet",...
                                typeToString(savedKey(i))), criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                        else
                            mPlotText(relevantSheetHandler, criterionColours.value,...
                                [studentFeature.xmax - 0.005, studentFeature.ymax - 0.005*i]...
                                , sprintf("%d %s views expected only %d found",...
                                keyMap(savedKey(i)), typeToString(savedKey(i)), stuMap(savedKey(i)))...
                                ,criterionColours.fontSize, 'RightTop',criterionColours.fontName);
                        end
                    end
                end
            end
        end
        function keyMap = makeMap(obj, feature)
            keyMap =containers.Map('KeyType','double','ValueType','any');
            for i = 1:max(feature.numviews)
                if i<=feature.numviews
                    if ~isKey(keyMap, feature.childviews(i).viewtype)
                         keyMap(feature.childviews(i).viewtype) = 1;
                    else
                         keyMap(feature.childviews(i).viewtype) = keyMap(feature.childviews(i).viewtype) + 1;
                    end
                end
            end
        end
        function gfxobjects = showTolerance(obj, keyFeature, relevantSheetHandler, criterionColours)
            % Function which deals with the tolerancing display on the
            % marking GUI
            keyMap = obj.makeMap(keyFeature);
            keySet = cell2mat(keys(keyMap));
            gfxobjects = hPlotText(relevantSheetHandler,criterionColours.value,...
                            [keyFeature.xmin + 0.04, keyFeature.ymin + 0.02], obj.allText(keyMap, keySet), 8);
           
         
        end
        function goodText = allText(obj, keyMap, keySet)
                goodText = "";
                
                for i = 1:length(keySet)
                    goodText = goodText + sprintf('Expecting %d %s type views\n', keyMap(keySet(i)), typeToString(keySet(i)));
                end
        end
        
    end
end

