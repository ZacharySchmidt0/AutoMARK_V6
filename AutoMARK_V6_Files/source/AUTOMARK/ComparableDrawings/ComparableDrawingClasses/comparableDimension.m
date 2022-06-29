classdef comparableDimension < comparingBase
    %ComparableDimension Class representation of all types of dimensions
    % This actually is a fairly general object! So its important that it
    % has a few different properties in it to seperate them out!
    
    properties
        %% All internal properties
        
        %name = "";
        isdangling = false;
        
        % Position information
        annx = 0;
        anny = 0;
        
        type = 0; 
        arrowside = 0;
        arrowstyle = 0;
        isholecallout = false;
        
        primaryprecision = 0;
        primarytoleranceprecision = 0;
        alternateprecision = 0;
        alternatetoleranceprecision = 0;
        
        chamfertextstyle = 0;
        textprefix = "";
        textprefixdef = "";
        textsuffix = "";
        textsuffixdef = "";
        textcalloutabove = "";
        textcalloutabovedef = "";
        textcalloutbelow = "";
        textcalloutbelowdef = "";
        
        % First dimension
        dimension1value = 0;
        dimension1type = 0;
        dimension1driven = 0;
        dimension1readonly = false;
        
        dimension1tolerancetype = 0;
        dimension1toleranceparenthesis = false;
        dimension1tolerancefittype = 0;
        dimension1tolerancefitstyle = 0;
        
        dimension1tolerancemax = 0;
        dimension1tolerancemin = 0;
        
        % Second dimension (if it has, otherwise is the same as dim1)
        dimension2value = 0;
        dimension2type = 0;
        dimension2driven = 0;
        dimension2readonly = false;
        
        dimension2tolerancetype = 0;
        dimension2toleranceparenthesis = false;
        dimension2tolerancefittype = 0;
        dimension2tolerancefitstyle = 0;
        
        dimension2tolerancemax = 0;
        dimension2tolerancemin = 0;
        
        % Arrows
        arrow1x = 0;
        arrow1y = 0;
        
        arrow2x = 0;
        arrow2y = 0;
        
%%         OLD AND DEPRECATED
%         name = "";
%         dimtype = 0;     % swDimensionType_e Enumeration
%         dimvaltype = 0;  % swDimensionParamType_e Enumeration
%         lengthvalue = 0; % Most set one, chamfers set both
%         anglevalue = 0;
%         
%         
%         % Display things
%         colorref = 8421504;
%         linetype = 0;
%         linestyle = 0;
%         lineweight = 0;
%         
%         % Position things
%         % Be clever about this in criterion
%         % Since start and end might be flipped
%         startx = 0;
%         starty = 0;
%         startz = 0;
%         endx = 0;
%         endy = 0;
%         endz = 0;
%         annox = 0;
%         annoy = 0;
%         annoz = 0;
%         
%         % Various properties
%         drivenstate = 1;
%         readonly = false;
%         
%         % Tolerancing
%         toltype = 0;
%         tolfit = -1;
%         toldisplaystyle = -1;
%         tolmin = 0;
%         tolmax = 0;
%         
%         % Text information
%         textall = "";
%         textprefix = "";
%         textsuffix = "";
%         textcalloutabove = "";
%         textcalloutbelow = "";
        
        %% Relations, used for iteration
        parent = [];
    end
    
    methods
        function obj = comparableDimension()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Dimension";
        end
    end
end