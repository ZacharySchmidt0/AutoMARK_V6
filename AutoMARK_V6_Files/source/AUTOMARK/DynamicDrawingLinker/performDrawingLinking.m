function performDrawingLinking(linker, keyDrawing, studentDrawing)
%PERFORMDRAWINGLINKING Links together a key and Student Drawing
% This function is essentially the constructor inside the drawing linker,
% but its been placed outside to split the code  up a little.

% The first link is just linking the drawings together
linker.addPair(keyDrawing, studentDrawing);


% Now compare the sheets and link together the best matches!
sheetMatrix = compareMatrix(keyDrawing.childsheets, studentDrawing.childsheets, @compareSheets);

% These are the best matches
% Sheets have 2.0 as their minimum link score, this is because we really
% try to force them to link together.
[sheetMatchIndexs, ~] = pairwisePeaks(sheetMatrix, 2.0);

% Now link together all of them.
for sheetrow = 1:size(sheetMatchIndexs, 1)
    
    % The row has the key and the student index
    keySheet = keyDrawing.childsheets(sheetMatchIndexs(sheetrow, 1));
    studentSheet = studentDrawing.childsheets(sheetMatchIndexs(sheetrow, 2));
    
    % Link them
    linker.addPair(keySheet, studentSheet);
    
    % Link together any tables on the sheets
    bomMatrix = compareMatrix(keySheet.childboms, studentSheet.childboms, @compareBOM);
    [bomMatchIndexs, ~] = pairwisePeaks(bomMatrix);
    
    for bomRow = 1:size(bomMatchIndexs, 1)
        
        keyBOM = keySheet.childboms(bomMatchIndexs(bomRow, 1));
        studentBOM = studentSheet.childboms(bomMatchIndexs(bomRow, 2));
        
        linker.addPair(keyBOM, studentBOM);
    end
    
    % Link together the views on the sheets that just got linked
    viewMatrix = compareMatrix(keySheet.childviews, studentSheet.childviews, @compareViews);
    [viewMatchIndexs, ~] = pairwisePeaks(viewMatrix);
    
    for viewRow = 1:size(viewMatchIndexs, 1)
        
        keyView = keySheet.childviews(viewMatchIndexs(viewRow, 1));
        studentView = studentSheet.childviews(viewMatchIndexs(viewRow, 2));
        
        % Link Views
        linker.addPair(keyView, studentView);
        % Link View solid models
        linker.addPair(keyView.childsolidmodel, studentView.childsolidmodel);
        
        % Centerlines, Centermarks and are done on a per view basis
        % instead of on the entire sheet. Its essentially nonsense for a
        % centerline / centermark to be on the wrong view.
        
        % Centerlines
        centerlineMatrix = compareMatrix(keyView.childcenterlines, studentView.childcenterlines, @compareCenterline);
        [centerLineMatchIndexs, ~] = pairwisePeaks(centerlineMatrix);
        
        for centerlineRow = 1:size(centerLineMatchIndexs, 1)
            keyCenterline = keyView.childcenterlines(centerLineMatchIndexs(centerlineRow, 1));
            studentCenterline = studentView.childcenterlines(centerLineMatchIndexs(centerlineRow, 2));
            
            linker.addPair(keyCenterline, studentCenterline);
        end
        
        % Centermarks
        centermarkMatrix = compareMatrix(keyView.childcentermarks, studentView.childcentermarks, @compareCentermark);
        [centermarkMatchIndexs, ~] = pairwisePeaks(centermarkMatrix);
        
        for centermarkRow = 1:size(centermarkMatchIndexs, 1)
            keycentermark = keyView.childcentermarks(centermarkMatchIndexs(centermarkRow, 1));
            studentcentermark = studentView.childcentermarks(centermarkMatchIndexs(centermarkRow, 2));
            
            linker.addPair(keycentermark, studentcentermark);
        end
        
        % Balloons
        balloonMatrix = compareMatrix(keyView.childballoons, studentView.childballoons, @compareBalloon);
        [balloonMatchIndexs, ~] = pairwisePeaks(balloonMatrix);
        
        for balloonRow = 1:size(balloonMatchIndexs, 1)
            keyballoon = keyView.childballoons(balloonMatchIndexs(balloonRow, 1));
            studentballoon = studentView.childballoons(balloonMatchIndexs(balloonRow, 2));
            
            linker.addPair(keyballoon, studentballoon);
        end
        
    end
    
    % Now do Dimensions, Datums and Balloons
    % These are special since they can link across views, Of course this
    % HIGHLY perfers that views be linked beforehand, but its not
    % nessesary.
    
    % First Datums, then Dimensions and lastly balloons
    
    % Datums -> Note it pulls from the sheet not the view
    datumMatrix = compareMatrix(keySheet.childdatums, studentSheet.childdatums, @compareDatum, linker);
    [datumMatchIndexs, ~] = pairwisePeaks(datumMatrix);
    
    for datumRow = 1:size(datumMatchIndexs, 1)
        keydatum = keySheet.childdatums(datumMatchIndexs(datumRow, 1));
        studentdatum = studentSheet.childdatums(datumMatchIndexs(datumRow, 2));
        
        linker.addPair(keydatum, studentdatum);
    end
    
    
    % Dimension Linking
    dimensionMatrix = compareMatrix(keySheet.childdims, studentSheet.childdims, @compareDimension, linker);
    [dimensionMatchIndexs, ~] = pairwisePeaks(dimensionMatrix);
    
    for dimensionRow = 1:size(dimensionMatchIndexs, 1)
        keydimension = keySheet.childdims(dimensionMatchIndexs(dimensionRow, 1));
        studentdimension = studentSheet.childdims(dimensionMatchIndexs(dimensionRow, 2));
        
        linker.addPair(keydimension, studentdimension);
    end
    
    % Balloons (Only the ones purely on the sheet)
    % Only the first 16 are pulled at most, This is because the remainder
    % of the notes come from the titleblock and whatnot and are completely
    % useless.
    % Matching Already dumps any notes that have length of less than or equal to 2.
    balloonMatrix = compareMatrix(keySheet.childballoons(1:min(16, keySheet.numballoons)), studentSheet.childballoons(1:min(16, studentSheet.numballoons)), @compareBalloon);
    [balloonMatchIndexs, ~] = pairwisePeaks(balloonMatrix);
    
    for balloonRow = 1:size(balloonMatchIndexs, 1)
        keyballoon = keySheet.childballoons(balloonMatchIndexs(balloonRow, 1));
        studentballoon = studentSheet.childballoons(balloonMatchIndexs(balloonRow, 2));
        
        linker.addPair(keyballoon, studentballoon);
    end
end
end

