classdef templateCell < handle
    %TemplateCell TemplateCells are simple node objects that go in a
    %template's tree structure.
    
    properties
        % Each templateCell has a weight
        weight = 0;
        
        % But you can check things like is this a sheet and whatnot, needed
        % to pass in the features
        onFeature = [];
        
        % Criterions don't have weights, the template Cells do
        criterions = cell(0);
        criterionweights = [];
        criteriondisabled = []; % Are they disabled
        
        % Sub template cells
        children = templateCell.empty;
    end
    
    methods
        function obj = templateCell()
            % Does nothing!
        end
        
        function addChild(obj, childTemplateCells)
            % Maintain order! DEPRECATED
            %assert(numel(childTemplateCells) == numel(childWeights));
            
            obj.children = [obj.children childTemplateCells];
            
            %obj.childweights = [obj.childweights childWeights];
        end
        
        function addCriterion(obj, newcriterions, newcriterionweights)
            
            % Maintain order!
            assert(numel(newcriterions) == numel(newcriterionweights));
            
            obj.criterions = [obj.criterions num2cell(newcriterions)];
            obj.criterionweights = [obj.criterionweights newcriterionweights];
            obj.criteriondisabled = [obj.criteriondisabled newcriterions.adddisabled];
        end
    end
end

