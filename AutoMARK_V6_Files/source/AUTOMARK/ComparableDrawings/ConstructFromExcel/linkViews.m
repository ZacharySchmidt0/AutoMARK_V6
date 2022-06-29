function linkViews(currentDrawing)
%LINKVIEWS Replaces dependent views with the real dependents after the
% fact. Since they are just strings beforehand

% DEPRECATED -> NOT NEEDED so it is no longer called

for sheetNum = 1:currentDrawing.numsheets
    currentSheet = currentDrawing.childsheets(sheetNum);
    
    for viewNum = 1:currentSheet.numviews
        currentView = currentSheet.childviews(viewNum);
        
        for depNum = 1:currentView.numdependentviews
            for sibViewNum = 1:currentSheet.numviews
                sibView = currentSheet.childviews(sibViewNum);
            
                if strcmp(sibView.name, currentView.dependents(depNum))
                    
                    currentView.childdependents = [currentView.childdependents sibView];
                    
                end
            end
        end
    end
end

