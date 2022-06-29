classdef markingTemplate < handle
    %MARKINGTEMPLATE Marking Templates are constructed from a key drawing!
    % They contain all the criterion you are marking for!
    
    % This is a tree-like structure, but not really.
    
    properties
        % Various other properties which allow telemetry
        createdDate = datetime();
        editDate = datetime();
        
        % Root of the tree structure
        roottemplatecell = templateCell.empty;
        
        % Drawing
        drawing = [];
    end
    
    methods
        function obj = markingTemplate()
            %MARKINGTEMPLATE Construct an instance of this class
            % Does nothing
        end
    end    
end

