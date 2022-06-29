classdef comparableView < comparingBase
    %comparableView This is the class represention of a view
    % This owns a few different things, it will be where a lot of
    % the math takes place!
    
    properties
        %% All internal properties
        %name = ""                   % View Name
        xmin = 0;                   % Location Info
        xmax = 0;
        ymin = 0;
        ymax = 0;
        x = 0;
        y = 0;
        
        viewtype = 0;               % Named, Projected, Etc
        scale1 = 1;                 % View Scale (if independent)
        scale2 = 1;
        orientation = "";           % Top Down Left Right etc
        baseview = "";              % If it has a parent (by name)!
        numdependentviews = 0;      % Number of views dependent on this view
        displaystyle = 0;         % Hidden lines, Shaded, WireFrame, etc.
        tangentlines = 0;          % Visible or Removed
        alignment = 0;             % Parent, Child, None, or Both.
        
        wasmirrored = false;       % If a section view is mirrored
        sectionlabel = "";         % If its a section view, what is its label
        
        numdims = 0;               % Keep this consistant!
        numcenterlines = 0;
        numcentermarks = 0;
        numdatums = 0;
        numballoons = 0;           % This is special <----|
        %                                                 |
        % Balloons aren't actually just balloons, they are infact notes
        % and the new VBA script (v6+) pulls in ALL notes.
        % Balloons are an annotation that might exist on the sheet only or
        % on the view and the sheet!
        
        %% Relations, used for iteration
        parent = [];
        dependents = []; % By name, not a handle
        childdependents = []; % Is a handle
        childsolidmodel = [];
        childdims = [];
        childcenterlines = [];
        childcentermarks = [];
        childdatums = [];
        childballoons = [];
    end
    
    methods
        function obj = comparableView()
            %comparableView Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "View";
        end
        
        %% The following is a strictly owned property
        % The upper sheet does not see this

        function addSolidModel(obj, newSolidModel)
            % There is only one possible solid model
            % So it doesn't do anything fancy
            obj.childsolidmodel = newSolidModel;
            newSolidModel.parent = obj;
        end
        
        %% The following properties get added to ourselves and we are the
        % parent!
        
         function addDimension(obj, newDim)
            % Add dimensions
            obj.childdims = [obj.childdims, newDim];
            [newDim.parent] = deal(obj);
            
            % Add them to our parent
            obj.parent.addDimension(newDim);
        end
        
        function addCenterline(obj, newCenterline)
            % Add centerlines
            obj.childcenterlines = [obj.childcenterlines, newCenterline];
            [newCenterline.parent] = deal(obj);
            
            % Add them to our parent
            obj.parent.addCenterline(newCenterline);
        end
        
        function addCentermark(obj, newCenterMark)
            % Add centermark
            obj.childcentermarks = [obj.childcentermarks, newCenterMark];
            [newCenterMark.parent] = deal(obj);
            
            % Add them to our parent
            obj.parent.addCentermark(newCenterMark);
        end
        
        function addDatum(obj, newDatum)
            % Adds datum feature
            obj.childdatums = [obj.childdatums, newDatum];
            [newDatum.parent] = deal(obj);
            
            % Add them to our parent
            obj.parent.addDatum(newDatum);
        end 
        
        function addBalloon(obj, newBallon)
            % Adds datum feature
            obj.childballoons = [obj.childballoons, newBallon];
            [newBallon.parent] = deal(obj);
            
            % Add them to our parent
            obj.parent.addBalloon(newBallon);
        end 
    end
end