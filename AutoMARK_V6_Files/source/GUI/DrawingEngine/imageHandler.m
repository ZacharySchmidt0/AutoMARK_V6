classdef imageHandler
    %IMAGEHANDLER Represents a 2D Sheet, You can plot it in some location
    % with high fidelity.
    
    properties
        onAxis; % Which axis the image is on
        sheet; % The actual sheet this handler is on!
        
        backGroundCol = [0 0 0];
        
        sheetImageFile = "";
        
        box_bottomleft = [0, 0];
        box_topright = [1, 1];
        
        image_height; % The box in which the image exists
        image_width;
        
        sheet_height; % The box in which the sheet lives
        sheet_width;
    end
    
    methods
        function obj = imageHandler(sheet, bottomLeft, topRight, backgroundColour, optionalaxis)
            %IMAGEHANDLER Construct an instance of this class
            % Sheet is the sheet that gets drawing
            % Bottom right and top left are a rectangle on which the sheet
            % gets put on.
            % BackGround colour is the colour of the backdrop
            
            if nargin < 5
                obj.onAxis = gca();
            else
                obj.onAxis = optionalaxis;
            end
            
            % Save sheet for lookup later!
            obj.sheet = sheet;
            
            % Needs to be this size to plot correctly
            obj.backGroundCol = backgroundColour;
            obj.box_bottomleft = bottomLeft;
            obj.box_topright = topRight;
            
            obj.sheet_height = sheet.height;
            obj.sheet_width = sheet.width;
            
            drw = sheet.parent;
            obj.sheetImageFile = strcat(fullfile(drw.studentReportFolder, "Sheets", filesep, sheet.name), '.png');
            
            % This is the data for the imagefile
            cData = imread(obj.sheetImageFile);
            
            obj.image_height = size(cData, 1);
            obj.image_width = size(cData, 2);
        end
        
        
        
        function displayFully(obj)
            % Display the back and image
            obj.displayBack();
            obj.displayImage();
        end
        
        function displayImage(obj)
            % Display the image
            % This object is relatively small, so it doesn't actually save
            % the image in here anywhere,
            % Instead it reloads when requested.
            [cData, ~, ~] = imread(obj.sheetImageFile);
            
            [xmin, ymin] = obj.imageToAxis(0.5, 0.5);
            [xmax, ymax] = obj.imageToAxis(obj.image_width - 0.5, obj.image_height - 0.5);
            
            image(obj.onAxis, 'XData', [xmin xmax], 'YData', [ymax ymin], 'CData', cData);
        end
        
        function displayBack(obj)
            % Display the back
            pos = [min([obj.box_bottomleft; obj.box_topright]), abs(obj.box_topright - obj.box_bottomleft)];
            rectangle(obj.onAxis, 'LineStyle', 'none', 'FaceColor', obj.backGroundCol, 'Position', pos);
        end
        
        % From the Sheet to the Image Coordinates
        function [x, y] = sheetToImage(obj, x, y)
            [x, y] = imageHandler.boxConvert(0, obj.sheet_width, 0, obj.sheet_height, 0, obj.image_width, 0, obj.image_height, x, y);
        end
        
        % From the Image to the Display Coordinates
        function [x, y] = imageToAxis(obj, x, y)
            [x, y] = imageHandler.boxConvert(0, obj.image_width, 0, obj.image_height, obj.box_bottomleft(1), obj.box_topright(1), obj.box_bottomleft(2), obj.box_topright(2), x, y);
        end
        
        % From the Sheet to the Display Cooridinates
        function [x, y] = sheetToAxis(obj, x, y)
            [x, y] = obj.sheetToImage(x, y);
            [x, y] = obj.imageToAxis(x, y);
        end
    end
    
    methods(Static)
        function [targetX, targetY] = boxConvert(sourceXmin, sourceXmax, sourceYmin, sourceYmax, targetXmin, targetXmax, targetYmin, targetYmax, sourceX, sourceY)
            % Centered Transform from original to end while maintianing
            % aspect ratio
            sourceWidth = sourceXmax - sourceXmin;
            sourceHeight = sourceYmax - sourceYmin;
            
            targetWidth = targetXmax - targetXmin;
            targetHeight = targetYmax - targetYmin;
            
            stwidthscale = targetWidth/sourceWidth;
            stheightscale = targetHeight/sourceHeight;
            
            % Minimum to maintain aspect ratio
            stscale = min(stwidthscale, stheightscale);
            
            % Translate the source to centered about the origin
            x = sourceX - sourceWidth/2 - sourceXmin;
            y = sourceY - sourceHeight/2 - sourceYmin;
            
            % Scale them both to the target size
            x = x * stscale;
            y = y * stscale;
            
            % Transform the target back to where it belongs.
            targetX = x + targetXmin + targetWidth/2;
            targetY = y + targetYmin + targetHeight/2;
        end
    end
end

