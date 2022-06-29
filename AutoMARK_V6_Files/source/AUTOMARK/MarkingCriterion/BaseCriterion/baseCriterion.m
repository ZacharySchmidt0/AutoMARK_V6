classdef baseCriterion < handle & matlab.mixin.Copyable
    %BASECRITERION Summary of this class goes here
    
    % All criterion work inherit from this
    
    properties
        tolerancetip = "There is nothing to tolerance in this!"; % Used for GUI in future
        
        % Put fields in this struct with respect to tolerancing.
        tolerance = struct;
        
        description = "This is the base class description, Something has implemented this class incorrectly if you are seeing this as this is meant to be overrided!";
        % When being added to a cell, this is the default weight this
        % criterion will appear with!
        recommendedweight = 0;
       
        % Should it be added disabled?
        adddisabled = false;
    end
    
    
    methods
        function obj = baseCriterion()
            % Does nothing, Don't bother calling it from the child
        end
        
        
        function multiplier = evaluateOn(obj, linker, keyFeature, studentReport, relevantSheetHandler, doAnnotations)
            % Return true or false depending on if something was correct!
            %
            % Parameters:
            %
            % linker -> Pass in the linker so we can get the corresponding
            % student's feature, this is super repetative,
            %
            % keyFeature -> We pass in the key feature instead of having it
            % ingrained in the criterion so that we can have multiple features
            % share a criterion object! (Mabye not useful but not harmful).
            %
            % studentReport markingReport -> Need it to be able to add comments
            %
            % relevantSheetHandler (if any) -> Use highlighting functions
            % on!
            %
            % doAnnotations -> Disables annotating things
            %
            % Return values:
            %
            % multipler -> A double which multiplies the weight, is a
            % measure of "wrongness"
            %
            % multiplier of 0 -> It was correct
            % multiplier of 1 -> It was wrong
            % multiplier of 2 -> It was wrong 2 twice
            %
            % Its only purpose for existance is that some criterion are
            % weird, like "extra" criterion!
            multiplier = 0;
        end
        
        function gfxobjects = showTolerance(obj, keyFeature, relevantSheetHandler, criterionColours)
            % Function which deals with the tolerancing display on the
            % marking GUI.
            % By default its nothing
            %
            % If you want to implement one, it works like this
            % gfxobjects -> ALL of the things you just drew ( use the
            % "H" drawing functions in highlighting 2, they return the
            % handle to the object they just drew.
            %
            % It must be a gobjects array, lookup what those are in matlab
            % documentation.
            %
            % You can use obj.tolerance to get your own tolerance
            % properties.
            %
            % keyFeature is the feature you need to show the tolerances
            % for, Use it to get the principle locations and whatnot.
            %
            % relevantSheethandler is needed to specify where to draw.
            %
            gfxobjects = gobjects(0);
        end
        
        function onClickRespond(obj, keyFeature, clickLocation)
            % Respond to clicks on the UI figure, very useful for tolerance
            % boxes and what not.
            % By default do nothing.
            
            % Note: clickLocation is a column vector of points [x, y] which
            % were clicked on while alt was held.
            % disp(clickLocation);
            %
            % So it might be something like [x1, y1 ; x2, y2; x3,y3];
            % You won't be called with 0 points, but I'd recommend
            % implementing something safely regardless!
        end
    end
end

