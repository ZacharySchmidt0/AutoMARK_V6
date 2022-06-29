classdef simpleClass < handle
    %SIMPLECLASS A simple pointer holder
    % Investigating how MATLAB handles memory usage when you have classes
    % pointing around and if things get cleared correctly!
    
    properties
        child1 = simpleClass.empty();
        child2 = simpleClass.empty();
        parent = simpleClass.empty();
    end
    
    methods
        function obj = simpleClass()
            %SIMPLECLASS Construct an instance of this class
        end
        
        function total = fanOut(obj,n)
            
            total = 1;
            if n > 1
                obj.child1 = simpleClass();
                obj.child1.parent = obj;
                obj.child2 = simpleClass();
                obj.child2.parent = obj;
                
                total = total + obj.child1.fanOut(n-1);
                total = total + obj.child2.fanOut(n-1);
            end
        end
    end
end