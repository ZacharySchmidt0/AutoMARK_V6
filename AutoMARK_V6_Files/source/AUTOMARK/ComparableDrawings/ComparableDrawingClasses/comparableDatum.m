classdef comparableDatum < comparingBase
    %COMPARABLEX This is the class represention of a <>.
    % Exactly as it seems
    
    properties
        %% All internal properties
        %name = "";
        isdangling = false;
        
        linestyle = 0;
        
        startx = 0;
        starty = 0;
        endx = 0;
        endy = 0;
        
        displaystyle = 1;
        filledtriangle = true;
        label = "";
        
        %% Relations, used for iteration
        parent = [];
    end
    
    methods
        function obj = comparableDatum()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Datum";
        end
    end
end