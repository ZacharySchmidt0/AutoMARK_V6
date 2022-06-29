classdef comparableBalloon < comparingBase
    %COMPARABLEBalloon This is the class represention of a Balloon.
    % Exactly as it seems
    
    properties
        % All internal properties
        
        %name = "";
        isdangling = false;
        
        text = "";
        textupper = "";         % The one used for BOM Balloons!
        textlower = "";
        
        isbomballoon = false;
        isstackedballoon = false;
        
        % Lots of position information
        centerx = 0;            % Where the center of the balloon circle is (if balloon)
        centery = 0;
        attachx = 0;            % Where the attachment point is
        attachy = 0;
        annx = 0;               % Where the text is
        anny = 0;
        
        leaderpoints = 0;       % Number of leader points
        
        point1x = 0;
        point1y = 0;
        
        point2x = 0;
        point2y = 0;
        
        point3x = 0;
        point3y = 0;
        
        arrowlength = 0;
        arrowheadlength = 0;
        arrowheadwidth = 0;
        arrowheadstyle = 0;
        
        % Relations, used for iteration
        parent = [];
    end
    
    methods
        function obj = comparableBalloon()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Balloon/Note";
        end
    end
end