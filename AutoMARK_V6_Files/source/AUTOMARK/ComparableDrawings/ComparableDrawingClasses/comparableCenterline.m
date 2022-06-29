classdef comparableCenterline < comparingBase
    %comparableCenterline This is the class represention of a CenterLine.
    % Exactly as it seems
    
    properties
        % All internal properties
        
        %name = "";
        isdangling = false;
        
        % Display properties
        colorref = 0;
        linetype = 0;
        linestyle = 0;
        lineweight = 0;
        
        % Position information
        startx = 0;
        starty = 0;
        endx = 0;
        endy = 0;
        
        % Relations, used for iteration
        parent = [];
    end
    
    methods
        function obj = comparableCenterline()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Centerline";
        end
    end
end