classdef criterionMissing < baseCriterion
    % Criterion which does X
    
    methods
        function obj = criterionMissing()
            % This isn't a normal criteiron, it does vastly different
            % things!
        end
    end
    methods (Static)
        function multiplier = evaluateOn(linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations,criterionColours)
            % Always 1
            multiplier = 1;
            
            % This never links to anything!
            if doAnnotations
                
                % These features need the parent location when being drawn.
                switch class(keyFeature)
                    case {'comparableDimension', 'comparableCentermark', 'comparableCenterline', 'comparableDatum'}
                        
                        keyParent = keyFeature.parent;
                        stuParent = linker.returnPair(keyParent);
                        
                    case {'comparableBalloon'}
                        
                        % Balloons might have a parent
                        if ~isempty(keyFeature.parent)  
                            stuParent = linker.returnPair(keyFeature.parent);
                        else
                            stuParent = [];
                        end
                        
                    otherwise
                        stuParent = [];
                end
                
                % All red
                mCreateFeature(relevantSheetHandler, criterionColours.missing, keyFeature, stuParent,criterionColours);
            end
            
            
            if doAnnotations
                studentReport.addComment(""); % Newline
                studentReport.addComment(sprintf("A feature %s of type %s was expected, but was missing on the student drawing!", keyFeature.name, keyFeature.commonTypeName));
            end
        end
    end
end

