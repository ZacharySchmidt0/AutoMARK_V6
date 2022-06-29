classdef markingReport < handle
    %MARKINGREPORT Marking reports are the objects that contain the marks
    % for a student! They are sort of like marking templates, but they are
    % built on the student instead.
    
    % They are kind of odd, since making a report creates a figure and a
    % bunch of axes!
    
    % Need this to make images work properly!
    properties
        studentdrawing = [];
        
        sfigure = [];
        saxes = [];
        saxeshandlers = [];
        sreportcells = [];      % This is a cell like structure telling you what has happened!
        
        annotatedStrings = "Marking Report";
        stringsIndex = 1; % Number of valid strings
    end
    
    methods
        function obj = markingReport(studentdrawing)
            %MARKINGREPORT Construct an instance of this class
            %  Creates a new figure an multiple axes to go along with it!
            obj.studentdrawing = studentdrawing;
            
            % Starts invisible
            obj.newFigure();
            
            % Plot all the sheets
            for i = 1:obj.studentdrawing.numsheets
                obj.newAxis(obj.studentdrawing.childsheets(i));
            end
            
            % Display them all
            for i = 1:numel(obj.saxeshandlers)
                obj.saxeshandlers(i).displayFully();
            end
            
            % Arrange them nicely
            obj.arrangeplots();
            
            % Now make the figure visible
            obj.sfigure.Visible = 'on';
            
        end
        
        function sHandler = sheetToHandler(obj, studentSheet)
            % Simple Helper function!
            % Crashes on invalid!
            for i = 1:numel(obj.saxeshandlers)
                if obj.saxeshandlers(i).sheet == studentSheet
                    sHandler = obj.saxeshandlers(i);
                end
            end
        end
        
        function addComment(obj,commenttext)
            %Addcomment Add a new comment to all the annotated strings.
            % Does some clever resizing!
            
            % Add one to the strings index
            obj.stringsIndex = obj.stringsIndex + 1;
            
            % If there is no space
            if numel(obj.annotatedStrings) < obj.stringsIndex
                % We allocate an extra 30 spots!
                obj.annotatedStrings(obj.stringsIndex + 30) = missing;
            end
            
            obj.annotatedStrings(obj.stringsIndex) = commenttext;
            
        end
    end
    
    methods (Access = 'private')
        function newFigure(obj)
            
            % Create a new figure
            obj.sfigure = figure();
            
            % Make it invisible
            obj.sfigure.Visible = 'off';
            
            % Remove the menubar and toolbar
            obj.sfigure.MenuBar = 'none';
            
            % Remove its name and put in the name of the drawing!
            obj.sfigure.NumberTitle = 'off';
            obj.sfigure.Name = strcat(obj.studentdrawing.name, " - ", obj.studentdrawing.lsby);
            
            % Its callback is our private function
            obj.sfigure.SizeChangedFcn = @obj.arrangeplots;
        end
        
        function newAxis(obj, studentsheet)
            
            % Creating a new axis on the figure
            ax = axes('Parent', obj.sfigure);
            
            % Manual Ticks
            ax.XTickMode = 'manual';
            ax.YTickMode = 'manual';
            
            % No Ticks
            ax.XTick = [];
            ax.YTick = [];
            
            % No Numbers
            ax.XTickLabel = [];
            ax.YTickLabel = [];
            
            ax.XLimMode = 'manual';
            ax.YLimMode = 'manual';
            
            
            
            % The aspect ratio I use is 11 by 17
            ax.XLim = [0 17];
            ax.YLim = [0 11];
            
            % Box it, Invisibly
            ax.Box = 'on';
            ax.Visible = 'off';
            
            ax.PlotBoxAspectRatioMode = 'manual';
            % 11 by 17 again
            ax.PlotBoxAspectRatio = [17 11 1];
            
            % White background, on the full box as much as possible, using
            % the figure created for the image
            imhandler = imageHandler(studentsheet, [0 0], [17 11], [1,1,1], ax);
            
            % Append them to our items
            obj.saxes = [obj.saxes ax];
            obj.saxeshandlers = [obj.saxeshandlers imhandler];
        end
        
        function arrangeplots(obj, ~, ~)
            % Arrange the boxes nicely, this is called on resizing
            % This packs the rectangles together.
            % This packs the axis into rectangles with an 11 by 17 area to fit together.
            % It distributes a 10% padding vertically and a 10% padding
            % horizontally.
            
            % Incase
            if numel(obj.saxes) < 1
                return
            end
            
            vpad = 0.05;
            hpad = 0.05;
            
            boxAspectRatio = [17 11];
            
            totalWidth = obj.sfigure.Position(3);
            totalHeight = obj.sfigure.Position(4);
            
            usableWidth = totalWidth*(1-hpad);
            usableHeight = totalHeight*(1-vpad);
            
            numBoxes = numel(obj.saxes);
            
            areaGotten = zeros(1, numBoxes);
            
            for numRows = 1:numBoxes
               
                % You need at least this many columns in order to fit
                % all of the plots
                numCols = ceil(numBoxes/numRows);
                
                % In the best case, we can use the entirety of this
                % bounding box
                
                xpixelsmax = usableWidth / numCols;
                ypixelsmax = usableHeight / numRows;
                
                % You take the min!
                boxratio = min ( xpixelsmax/boxAspectRatio(1) , ypixelsmax/boxAspectRatio(2) );
                
                areaGotten(numRows) = prod(boxratio .* boxAspectRatio);
            end

            % Find the maximum area you could get
            [~, numRows] = max(areaGotten);
            
            % This is number of columns you get with that number of rows
            numCols = ceil(numBoxes/numRows);
            
            % This is how much area each box has.
            singleBoxWidth = (1-hpad)/numCols;
            singleBoxHeight = (1-vpad)/numRows;
            
            % Now put all the plots properly (row by row)
            for i = 1:numRows
                
                % We are fully filled for the first columns, and the last
                % one might have a few missing.
                boxesInRow = min(numCols, numBoxes - (i - 1)*numCols);
                
                % There are n + 1 gaps, but the top and bottom are half
                % width so this is the formula
                % The one minus is so that the first row is the top.
                boxY = ( 1 - (i - 0.5)/(numRows) ) - singleBoxHeight/2;
                
                for j = 1:boxesInRow
                    boxX = (j - 0.5)/(boxesInRow) - singleBoxWidth/2;
                    
                    newBoxPosition = [boxX, boxY, singleBoxWidth, singleBoxHeight];
                    
                    % Simple math
                    whichAxes = (i - 1) * numCols + j;
                    
                    obj.saxes(whichAxes).Position = newBoxPosition;
                end
            end
        end
    end
end

