classdef comparableDrawing < comparingBase
    %COMPARABLEDRAWING The root of the tree class created for drawings.
    % ComparableDrawings are the internal representation of SolidWorks
    % drawings. The sheets, views, dimensions, etc are all children of this
    % class.
    
    properties
        %% All of the internal properties, and the defaults
        % Add additional for extending marking capabilities.
        %name = "";
        author = "";
        
        % Put the path to the Folder that contains the excel file
        studentReportFolder = '';
        
        % Dates should be saved as MATLAB dates
        % these are created with
        % t = datetime(Year,Month,Day,Hour,Minute,Second)
        % default is New Years 2019
        cdate = datetime(2019,1,1,0,0,0);   % Creation
        lsdate = datetime(2019,1,1,0,0,0);  % Last Saved
        
        lsby = "";
        numsheets = 0; % Keep this consistant with length(obj.childsheets)
        
        % Custom properties go in a map
        customproperties = containers.Map('KeyType','char','ValueType','any');
        
        %% Children, Incredibly important
        % used mainly for iteration purposes
        childsheets = [];
    end
    
    methods
        function obj = comparableDrawing()
            %COMPARABLEDRAWING Construct an instance of this class
            % Construction is trivial and all property assignment is done
            % post construction.
            obj@comparingBase();
            obj.commonTypeName = "Drawing";
        end
        
        %%
        function addSheet(obj, newSheet)
            % Use this method instead of manual adding as it will link the
            % sheet up to us as well.
            obj.childsheets = [obj.childsheets, newSheet];
            newSheet.parent = obj;
        end
    end
end

