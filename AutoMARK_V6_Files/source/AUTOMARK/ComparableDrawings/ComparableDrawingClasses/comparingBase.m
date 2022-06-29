classdef comparingBase < handle
    %COMPARINGBASE Base class from which all comparable objects are spawned
    % This is the base class which all comparable objects inherit from
    % currently this only asserts they all are handle classes, but
    % this may eventually have more properties later.
    
    properties
        name = "";
        commonTypeName = "[ERROR]";
    end
    
    methods
        function obj = comparingBase()
            % Constructor does nothing, but is called by its derived
            % classes, you could add versioning or UUID's or some other
            % globally maintained properties and there setup here.
        end
    end
end

