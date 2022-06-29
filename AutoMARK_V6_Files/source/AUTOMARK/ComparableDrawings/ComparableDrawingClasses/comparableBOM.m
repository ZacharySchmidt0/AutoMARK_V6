classdef comparableBOM < comparingBase
    %COMPARABLEX This is the class represention of a <>.
    % Exactly as it seems
    
    properties
        %% All internal properties
        %name = "";
        tabletype = 2;          % BOM is table 2
        % Other tables are more or less the same
        numrows = 0;
        numcolumns = 0;
        fonttype = "";
        width = 0;                  % Technically Redundant!
        height = 0;                 % Can be computed from position data
        fontSize = 0;
        xmin = 0;                   % Location Info
        xmax = 0;                   % GOTCHA: This isn't the same thing as the VBA script!
        ymin = 0;                   % The VBA script actually does very little to no processing
        ymax = 0;                   % So this must be COMPUTED by the parser
        
        table = cell(0);          % This is the literal table!
        rowheights = [];           % Heights of the rows
        colwidths = [];            % Widths of the Columns
        coltypes = [];             % Type of the columns
        colNames = cell(0);
        contents = containers.Map;
        %% Relations, used for iteration
        parent = [];
    end
    
    methods
        function obj = comparableBOM()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Bill of Materials Table";
        end
    end
end