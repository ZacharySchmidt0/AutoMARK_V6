classdef dynamicArray < handle
    %DYNAMICVECTORS Similar to C++ style vectors
    % MATLAB has really slow vectors and it really kills performace due to
    % N^2
    % This implements a C++ style dynamic vector
    
    %   Results: Appending is indeed linear, but it take approximately
    %   10,000 appends before it is faster than MATLAB
    %   therefore this is pointless.
    
    properties (Access = private)
        capacity = 0;
        internalStorage = [];
        pastEnd = 1;
    end
    
    methods (Access = public)
        % Normal Methods are here
        
        function obj = dynamicArray()
            % Trivial Construction
        end
        
        function val = front(obj)
            if (obj.pastEnd <= 1)
                error("Front called on empty vector")
            else
                val = obj.internalStorage(1);
            end
        end
        
        function val = back(obj)
            if (obj.pastEnd <= 1)
                error("Back called on empty vector")
            else
                val = obj.internalStorage(obj.pastEnd-1);
            end
        end
        
        function append(obj, newItem)
            if (obj.capacity >= obj.pastEnd) % Typical Case, First Branch
                obj.internalStorage(obj.pastEnd) = newItem;
            elseif (obj.length >= 1)         % Sometimes we need to expand
                obj.expand();
                obj.internalStorage(obj.pastEnd) = newItem;
            else                             % The very first item
                obj.internalStorage = [newItem];
            end
            obj.pastEnd = obj.pastEnd + 1;
        end
        
        function clear(obj)
            obj.pastEnd = 1;
        end
        
        function val = size(obj)
            val = [1, obj.length()];
        end
        
        function val = length(obj)
            val = obj.pastEnd - 1;
        end
    end
    
    methods (Access = private)
        % Internal Space changing
        function expand(obj)
            newSize = int32(obj.capacity * 5 / 4) + 2;
            obj.resize(newSize);
        end
        
        function resize(obj, newSize)
            % Must have capacity of at least 1 before expanding!
            % Copy the first element into the newSize, forcing it to
            % resize.
            if (obj.capacity > 0)
                obj.internalStorage(newSize) = obj.internalStorage(1);
            end
        end
    end
    
    methods (Access = public)
        % Overloaded Operators
        function ret = subsindex(obj, i)
            if max(i) >= obj.pastEnd
                error("Index exceeds array bounds.")
            end
            ret = obj.internalStorage(i);
        end
    end
end

