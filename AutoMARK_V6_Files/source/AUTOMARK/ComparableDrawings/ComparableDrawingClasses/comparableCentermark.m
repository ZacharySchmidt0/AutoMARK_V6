classdef comparableCentermark < comparingBase
    %comparableCentermark This is the class represention of a Centermark.
    % Exactly as it seems
    % Centermarks are interesting because they appear in groups
    
    properties
        % All internal properties
        
        %name = "";
        isdangling = false;
        
        % Group information
        groupcount = 0;
        groupindex = 1;         % This is 1 based!
        
        % Position information
        cmx = 0;    % Relative to view origin!
        cmy = 0;
        
        isdeleted = false;
        isdetached = false;
        isgrouped = true;
        
        extendedup = 0;
        extendedleft = 0;
        extendeddown = 0;
        extendedright = 0;
        
        gap = 0;
        connectionlines = 0;        % Zero or one, is a boolean packed into a double
        style = 0;
        showlines = true;
        size = 0;
        rotationangle = 0;
        docsettings = true;
        
        % Relations, used for iteration
        parent = [];
        
        % Group is everyone in the group, including us.
        group = [];
    end
    
    methods
        function obj = comparableCentermark()
            %COMPARABLESHEET Construct an instance of this class.
            % Construction is trivial and all property assignment is done
            % post construction. Same as the rest of them.
            obj@comparingBase();
            obj.commonTypeName = "Centermark";
        end
        
% OLD
%         function pos(obj)
%             % Computes the startx, starty, startz
%             obj.startx = obj.centerx__ + obj.crelx__;
%             obj.starty = obj.centery__ + obj.crely__;
%             obj.startz = obj.centerz__ + obj.crelz__;
%         end
    end
end