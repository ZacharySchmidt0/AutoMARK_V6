function [transforms, success] = relatedViews(startView,endView)
% RELATEDVIEWS Returns the Transformations that happened to go from view1 to
% view2, if possible, using depth first search

    % Look upto 6 deep, this is way overkill
    [transforms, success] = keepSearching(startView, endView, startView, 6);

    function [chain, success] = keepSearching(currentView, searchFor, cameFrom, depth)
        success = false;
        chain = [];
        
        % Catch to stop us going too deep!
        if depth < 1
            return
        end
        depth = depth - 1;
        
        % If this is what we are looking for, then great!
        if currentView == searchFor
            success = true;
            return
        end
        
        % If this is empty, then go back!
        if isempty(currentView)
            return
        end
        
        viewstocheck = [];
        
        if ~(class(currentView.baseview) == "missing")
            viewstocheck = [viewstocheck string(currentView.baseview)];
        end
        
        viewstocheck = [viewstocheck currentView.dependents];
        
        % Now that we have a list of views to check, go through that
        
        for i = 1:length(viewstocheck)
           [checking, found] = viewFromString(currentView, viewstocheck(i));
           
           if ~found || checking == cameFrom
               % This means that we didn't have anything
               continue
           else
               % Try to dig through this, recursively
               [chain, success] = keepSearching(checking, searchFor, currentView, depth);
               
               % If this actually finds it, then thats great, and we do
               % something, otherwise chain and success will still be false
               % and empty
               if success
                   direction = rad2deg(atan2(checking.ymin - currentView.ymin, checking.xmin - currentView.xmin));
                   
                   if direction > -3 && direction < 3 
                       chain = ["R", chain]; % 0 degrees
                   elseif direction > 87 && direction < 93
                       chain = ["U", chain]; % 90 degrees
                   elseif direction < -87 && direction > -93
                       chain = ["D", chain]; % -90 degrees
                   elseif direction > 177 || direction < -177
                       chain = ["L", chain]; % +- 180 degrees
                   else
                       % Isometric -> Failed
                       chain = ["I", chain];
                   end
                   
                   return
               end
           end
        end
    end

    function [returnedView, found] = viewFromString(searchView, stringOfView)
        returnedView = [];
        found = false;
        
        for viewNum = 1:searchView.parent.numviews
            sibView = searchView.parent.childviews(viewNum);
            
            if strcmp(sibView.name, stringOfView)
                found = true;
                returnedView = sibView;
                return
            end
            
        end
    end
end

