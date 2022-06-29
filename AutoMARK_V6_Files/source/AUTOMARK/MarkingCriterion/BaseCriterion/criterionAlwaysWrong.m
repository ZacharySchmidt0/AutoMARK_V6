classdef criterionAlwaysWrong < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionAlwaysWrong(recommendedweight)
            % Construct an instance of this criterion
            obj.recommendedweight = recommendedweight;
            obj.description = "Always wrong, This criterion allows students to have some leway when assigned a positive weight.";
        end
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Always wrong
            multiplier = -1;
            studentReport.addComment('Giving leway by reducing deductions');
        end
    end
end

