function newTemplate = makeTemplatefromKey(keyDrawing)
%MAKETEMPLATEFROMKEY Summary of this function goes here
% Builds and returns a template, this is the default one!

% By default its just an additive sum!

% Make the marking template
newTemplate = markingTemplate();
newTemplate.drawing = keyDrawing;

% Make a criterion set to use
markingCriterionSet = criterionSets();

% Recursively build the template
newTemplate.roottemplatecell = buildCell(keyDrawing);

    function returnedCell = buildCell(someFeature)
        returnedCell = templateCell();
        returnedCell.onFeature = someFeature;
        
        % Now do what you must depending on what exactly someFeature is
        switch class(someFeature)
            case "comparableDrawing"
                %% For drawings what we do is iterate through and add all
                % their sheets
                
                totalWeight = 0;
                
                % Go through every sheet and make a bunch of templates  
                newCell = templateCell.empty;
                
                for i = 1:someFeature.numsheets
                    newCell(i) = buildCell(someFeature.childsheets(i));
                    totalWeight = totalWeight + newCell(i).weight;
                end
                
                returnedCell.addChild(newCell);
                
                % Add a bunch of criterion at this point, add the weights
                % to total weight
                for i = 1:numel(markingCriterionSet.drawingCriterion)
                    newCrit = markingCriterionSet.drawingCriterion{i};
                    
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                    totalWeight = totalWeight + newCrit.recommendedweight;
                end
                
                returnedCell.weight = totalWeight;
              
            case "comparableSheet"
                %% For sheets what we do is iterate through and add all the
                % views, boms, and some of the balloons!
                
                totalWeight = 0;
                
                % For each View
                newCell = templateCell.empty;
                for i = 1:someFeature.numviews
                    newCell(i) = buildCell(someFeature.childviews(i));
                    totalWeight = totalWeight + newCell(i).weight;
                end
                returnedCell.addChild(newCell);
                
                % For each bom
                newCell = templateCell.empty;
                for i = 1:numel(someFeature.childboms)
                    newCell(i) = buildCell(someFeature.childboms(i));
                    totalWeight = totalWeight + newCell(i).weight;
                end
                returnedCell.addChild(newCell);
                
                % For upto the first 16 balloons (we don't bother with the
                % rest). Which have substantial length
                newCell = templateCell.empty;
                j = 1;
                for i = 1:min(someFeature.numballoons, 16)
                    
                    balloon = someFeature.childballoons(i);
                    
                    if class(balloon.text) == "missing"
                        continue;
                    end
                    
                    if strlength(string(balloon.text)) <= 2
                        continue;
                    end
                    
                    newCell(j) = buildCell(balloon);
                    totalWeight = totalWeight + newCell(i).weight;
                    j = j + 1;
                end
                returnedCell.addChild(newCell);
                
                % Now add a bunch of criterion
                for i = 1:numel(markingCriterionSet.sheetCriterion)
                    newCrit = markingCriterionSet.sheetCriterion{i};
                    
                    % set the sheet view types as disabled by default
                    if strcmp(class(newCrit), 'criterionSheetViewTypes')
                        newCrit.adddisabled = 1;
                    end
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                    totalWeight = totalWeight + newCrit.recommendedweight;
                end
                
                
                returnedCell.weight = totalWeight;
                
            case "comparableView"
                %% For each view we iterate through and add the dimensions
                % centerlines, centermarks, datums, and balloons!
                
                totalWeight = 0;
                
                 % For each Dimension
                newCell = templateCell.empty;
                for i = 1:someFeature.numdims
                    newCell(i) = buildCell(someFeature.childdims(i));
                    totalWeight = totalWeight + newCell(i).weight;
                end
                returnedCell.addChild(newCell);
                
                 % For each centerline
                newCell = templateCell.empty;
                
                for i = 1:someFeature.numcenterlines
                    newCell(i) = buildCell(someFeature.childcenterlines(i));
                    totalWeight = totalWeight + newCell(i).weight;
                end
                returnedCell.addChild(newCell);
                
                 % For each centermark
                 j = 0;
                newCell = templateCell.empty;
                for i = 1:someFeature.numcentermarks
                    % If the centermark is deleted, ignore it! Also if
                    % invisible
                    if someFeature.childcentermarks(i).isdeleted
                        continue
                    end
                    
                    j = j + 1;
                    newCell(j) = buildCell(someFeature.childcentermarks(i));
                    totalWeight = totalWeight + newCell(j).weight;
                end
                returnedCell.addChild(newCell);
                
                 % For each datum
                newCell = templateCell.empty;
                for i = 1:someFeature.numdatums
                    newCell(i) = buildCell(someFeature.childdatums(i));
                    totalWeight = totalWeight + newCell(i).weight;
                end
                returnedCell.addChild(newCell);
                
                 % For each balloon
                newCell = templateCell.empty;
                j = 0;
                for i = 1:someFeature.numballoons
                    
                    if class(someFeature.childballoons(i).text) == "missing"
                        continue;
                    end
                    
                    if strlength(string(someFeature.childballoons(i).text)) < 1
                        continue;
                    end
                    
                    % Only if there is actually some feature in it!
                    j = j + 1;
                    
                    newCell(j) = buildCell(someFeature.childballoons(i));
                    totalWeight = totalWeight + newCell(j).weight;
                end
                returnedCell.addChild(newCell);
                
                % Add a bunch of criterion
                
                for i = 1:numel(markingCriterionSet.viewCriterion)
                    newCrit = markingCriterionSet.viewCriterion{i};
                    
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                    totalWeight = totalWeight + newCrit.recommendedweight;
                end
                returnedCell.weight = totalWeight;
                
                
                returnedCell.weight = totalWeight;
            case "comparableBOM"
                
                % Add a bunch of criterion
                for i = 1:numel(markingCriterionSet.bomCriterion)
                    newCrit = markingCriterionSet.bomCriterion{i};
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                end
                returnedCell.weight = markingCriterionSet.defaultBOMWeight;
                
            case "comparableDimension"
                
                 % Add a bunch of criterion and add the weights
                for i = 1:numel(markingCriterionSet.dimensionCriterion)
                    newCrit = markingCriterionSet.dimensionCriterion{i};
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                end
                returnedCell.weight = markingCriterionSet.defaultDimensionWeight;
                
            case "comparableCenterline"
                
                % Add a bunch of criterion and add the weights
                for i = 1:numel(markingCriterionSet.centerlineCriterion)
                    newCrit = markingCriterionSet.centerlineCriterion{i};
                    
                    % Determine if tolerance box should be horizontal or
                    % vertical based on angle centlerine is at
                    angleFromHoriz = atan((someFeature.endy-someFeature.starty)/(someFeature.endx-someFeature.startx));
                    if angleFromHoriz < pi/4 && strcmp(class(newCrit), 'criterionCenterlinePostion')
                        % angle between centerline and horizontal is < 45
                        % deg, make tolerance box horziontal
                        newCrit.tolerance.rectangles(1) = -0.008;
                        newCrit.tolerance.rectangles(2) = -0.002;
                        newCrit.tolerance.rectangles(3) = 0.008;
                        newCrit.tolerance.rectangles(4) = 0.002;
                    end
                    
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                end
                returnedCell.weight = markingCriterionSet.defaultCenterlineWeight;
                
            case "comparableCentermark"
                
                % Add a bunch of criterion and add the weights
                for i = 1:numel(markingCriterionSet.centermarkCriterion)
                    newCrit = markingCriterionSet.centermarkCriterion{i};
                    
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                end
                returnedCell.weight = markingCriterionSet.defaultCentermarkWeight;
                
            case "comparableDatum"
                
                % Add a bunch of criterion and add the weights
                for i = 1:numel(markingCriterionSet.datumCriterion)
                    newCrit = markingCriterionSet.datumCriterion{i};
                    
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                end
                returnedCell.weight = markingCriterionSet.defaultDatumWeight;
                
            case "comparableBalloon"
                
                % Add a bunch of criterion and add the weights
                for i = 1:numel(markingCriterionSet.balloonCriterion)
                    newCrit = markingCriterionSet.balloonCriterion{i};
                    
                    returnedCell.addCriterion(copy(newCrit), newCrit.recommendedweight);
                end
                returnedCell.weight = markingCriterionSet.defaultBalloonWeight;
                
            otherwise
                debugprint("No templating for this feature was found, something is wrong with the template construction", 0);
        end
    end
end
