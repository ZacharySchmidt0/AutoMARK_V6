classdef basicIterator < handle
    % Creating a new Iterator type from the ground up, MATLAB does not
    % seem to have any built in.
    % This likely wont get used as vectors are probably sufficient for
    % more or less everthing can be done in them instead.
    
    properties (Access = protected)
        exhausted = true;
    end
    
    methods (Access = public)
        function obj = basicIterator()
            % Construct the iterator
        end
        
        function result = next(obj)
            % Overload in order to implement functionality
            % what this should do is return the current item and move
            % us onto the next item.
            result = [];
        end
        
        function result = logical(obj)
            % Don't play with this
            result = ~obj.exhausted;
        end
        
    end
end

