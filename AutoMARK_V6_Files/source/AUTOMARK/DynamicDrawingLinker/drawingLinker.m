classdef drawingLinker < handle
    %DRAWINGLINKER This is class is responsible for linking together
    %drawings.
    % It does so by a number of methods depending on the feature type.
    
    properties
        celloflinks = cell(0);
    end
    
    properties (Access = 'private')
        lastChecked = cell(10,2);
        recentIndex = 1;
    end
    
    %% Public Functions
    methods
        function obj = drawingLinker(keyDrawing, studentDrawing)
            %DRAWINGLINKER Construct an instance of this class
            % You need to pass in both a key and a student drawing in order
            % to construct a linker. Unlike other components in this
            % program linkers are NOT trivially constructable!
            
            % All the actual code is inside this function
            performDrawingLinking(obj, keyDrawing, studentDrawing)
        end
        
        function pair = returnPair(obj, item)
            % Digs through the links to find a pair for anything entered.
            pair = [];
            
            % Small optimization due to access patterns when marking
            % criterion. We remember the last 10 things we have seen called,
            % these get dug through first.
            
            % If you debug this with hit and miss, you will see that this
            % actually hits almost all of the time!
            
            for i = 1:10
                if obj.lastChecked{i, 1} == item
                    % disp('Hit')
                    pair = obj.lastChecked{i, 2};
                    return
                end
            end
            % disp('Miss')
            
            for i = 1:numel(obj.celloflinks)
                if obj.celloflinks{i} == item
                    
                    % If this is in the second column (is a student item)
                    % its pair is one column before.
                    if i > size(obj.celloflinks, 1)
                        pair = obj.celloflinks{i - size(obj.celloflinks, 1)};
                    else
                        % This is in the first column, the pair is on the other
                        % side.
                        pair = obj.celloflinks{i + size(obj.celloflinks, 1)};
                    end
                    
                    obj.saveRecentPair(item, pair);
                    return
                end
            end
        end
        
        function addPair(obj, keyItem, studentItem)
            % Add a new pair to the links
            newRow = size(obj.celloflinks,1) + 1;
            
            obj.celloflinks{newRow, 1} = keyItem;
            obj.celloflinks{newRow, 2} = studentItem;
        end
    end
    
    %% Private functions
    methods (Access = private)
        
        function saveRecentPair(obj, item, pair)
            % Caching recent pairs is done in arbitrary order! ( either
            % could be key or student)
            
            obj.lastChecked{obj.recentIndex, 1} = item;
            obj.lastChecked{obj.recentIndex, 2} = pair;
            
            obj.recentIndex = obj.recentIndex + 1;
            if obj.recentIndex > 10
                obj.recentIndex = 1;
            end
        end
    end
end

