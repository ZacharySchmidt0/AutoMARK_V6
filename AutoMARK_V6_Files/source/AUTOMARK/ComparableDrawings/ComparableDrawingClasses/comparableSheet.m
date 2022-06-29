classdef comparableSheet < comparingBase
    %COMPARABLESHEET This is the class represention of a drawing sheet.
    % Exactly as it seems, every sheet in a drawing will be translated into
    % a drawing sheet!
    
    properties
        %% All internal properties
        
        %name = "";
        xmin = 0;
        ymin = 0;
        xmax = 0;
        ymax = 0;
        x = 0;
        y = 0;
        
        % viewtype = "Sheet"; Irrelevant
        
        papersize = 0;
        templatein = 0;
        scale1 = 1;
        scale2 = 1;
        projangle = 0;
        
        width = 0;
        height = 0;
        
        numviews = 0;   
        numballoons = 0;    % Balloons on the SHEET, not on a view
        
        numtotaldims = 0;
        numtotalcenterlines = 0;
        numtotalcentermarks = 0;
        numtotaldatums = 0;
        numtotalballoons = 0;
        
        %% Relations, used for iteration
        parent = [];
        childboms = [];
        childviews = [];
        childdims = [];
        childcenterlines = [];
        childcentermarks = [];
        childdatums = [];
        childballoons = [];
    end
    
    methods
        function obj = comparableSheet()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Sheet";
        end
        
        %% These are the things which are our direct children, thus we need
        % to handle them appropriately as such.
        
        function addView(obj, newView)
            % Adds a new view to the sheet, also links the view up to us
            obj.childviews = [obj.childviews, newView];
            [newView.parent] = deal(obj);
        end
        
        function addBOM(obj, newBOM)
            % Adds a new BOM to the sheet, also links the BOM up to us
            obj.childboms = [obj.childboms, newBOM];
            [newBOM.parent] = deal(obj);
        end
        
        %% These are things which are owned by others, but we still have
        % them for iteration purposes.
        
        % Mainly for Extraneous errors
        
        function addDimension(obj, newDim)
            % Add dimensions
            obj.childdims = [obj.childdims, newDim];
        end
        
        function addCenterline(obj, newCenterline)
            % Add centerlines
            obj.childcenterlines = [obj.childcenterlines, newCenterline];
        end
        
        function addCentermark(obj, newCenterMark)
            % Add centermark
            obj.childcentermarks = [obj.childcentermarks, newCenterMark];
        end
        
        function addDatum(obj, newDatum)
            % Adds datum feature
            obj.childdatums = [obj.childdatums, newDatum];
        end
        
        % Poor balloons with no parent </3 :'( 
        function addBalloon(obj, newBalloon)
            % Adds a balloon
            obj.childballoons = [obj.childballoons, newBalloon];
        end
    end
end

