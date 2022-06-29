classdef comparableViewModel < comparingBase
    %COMPARABLEViewModel This is the class represention of a Solid Model.
    % Dispite its name, this has nothing to do with Marking Solid Models.
    % This is something that comes from views, the reason I pull it in is
    % to help identify which view is which or which sheet is which!
    
    properties
        %% All internal properties
        
        % Model Properties, Might be useful, try not to use too many
        % since it complicates the API
        % These might not even get filled in with some versions which I
        % decide to make since if they are pointless for marking why
        % bother.
        
        %name = "";
        path = "";
        
        title = "";
        subject = "";
        author = "";
        keywords = "";
        comment = "";
        savedby = "";
        
        % Dates should be saved as MATLAB dates!
        % these are created with
        % t = datetime(Year,Month,Day,Hour,Minute,Second)
        % default is New Years 2019
        cmodel = datetime(2019,1,1,0,0,0);   % Creation
        lsmodel = datetime(2019,1,1,0,0,0);  % Last Saved
        
        x = 0;
        y = 0;
        z = 0;
        volume = 0;
        surfacearea = 0;
        mass = 0;
        density = 0;
        LXX = 0;
        LYY = 0;
        LZZ = 0;
        LXY = 0;
        LZX = 0;
        LYZ = 0;
        
        % Custom properties go in a map
        customproperties = containers.Map('KeyType','char','ValueType','any');
        
        %% Relations, used for iteration
        parent = [];
    end
    
    methods
        function obj = comparableViewModel()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Solid Model";
        end
    end
end