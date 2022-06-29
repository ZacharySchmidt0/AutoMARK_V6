classdef reportCell < handle
    %Report Cells are a simple structure which are created after marking
    %things!
    
    properties
        % Each reportCell also has a weight
        weight = 0;
        evaluateResult = 0;
        
        % Criterions are just a text string of the class name
        criterions = [];
        deductionweights = [];
        
        % Sub report cells
        children = reportCell.empty;
        
        %
        recentScore = NaN;
    end
    
    methods
        function obj = reportCell()
            % Does nothing!
        end
        
        function addChild(obj, childReportCells)
            obj.children = [obj.children childReportCells];
            
            %obj.childweights = [obj.childweights childWeights];
        end
        
        function addDeduction(obj, deductioncriterion, deductionweight)
            % Maintain order!
            assert(numel(deductioncriterion) == numel(deductionweight));
            
            % If something is correct, its deduction weight should be 0!
            obj.criterions = [obj.criterions deductioncriterion];
            obj.deductionweights = [obj.deductionweights deductionweight];
        end
        
        function score = getScore(obj)
            % Recursively get the score, Subtractive Rubric Style
            
            % Our score is given by the following
            
            % child losses = sum over children ( weight - score )
            % loss = sum(deductionweights) + child losses
            % score = max(0, weight - loss)
            % score = min(obj.weight, score)
            
            % Score is always positive!
            if isnan(obj.recentScore)
                closs = 0;
                for i = 1:numel(obj.children)
                    closs = closs + obj.children(i).weight - obj.children(i).getScore();
                end
                
                loss = sum(obj.deductionweights) + closs;
                score = max(0, obj.weight - loss);
                score = min(obj.weight, score); % Can't score greater than weight
                obj.recentScore = score;
            else
                score = obj.recentScore;
            end
        end
    end
end

