classdef rangeIterator < basicIterator
    % Range iterator, Something similar to pythons ranges.
    
    properties (Access = private)
        current = 0;
        endpoint = 0;
    end
    
    methods
        function obj = rangeIterator(endpoint)
            obj.endpoint = int32(endpoint);
            if obj.current < obj.endpoint
                obj.exhausted = false;
            end
        end
        
        function result = next(obj)
            result = obj.current;
            obj.current = obj.current + 1;
            if obj.current >= obj.endpoint
                obj.exhausted = true;
            end
        end
    end
end