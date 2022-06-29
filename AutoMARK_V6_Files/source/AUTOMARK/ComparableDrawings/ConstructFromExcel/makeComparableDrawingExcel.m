function createdDrawing = makeComparableDrawingExcel(filename)
%
% DOESN'T WORK, DO NOT USE
%
%
%
%
%
%
%
%
%
%
%
%makeComparableDrawingExcel Creates a comparable drawing from excel
% Takes in a filename (as a string) as the input and creates a comparable
% drawing object from it!
% This is THE function which hooks up Solidworks files to Automark!

debugprint(sprintf("Making a new drawing from %s", filename), 1);
% Read in the Excel Sheet into a Cell Array and Construct a new Comparable
% Drawing for the data
excelAsCell = readcell(filename);
createdDrawing = comparableDrawing();

% Fills the drawing header out, this always is going to be at the top
fillDrawingHeaders(createdDrawing, excelAsCell);

% Keep track of where we are
lineNumber = 3;

% Sheet Loop
debugprint(sprintf("It has %d sheets", createdDrawing.numSheets), 2);
for sheetNum = 1:createdDrawing.numSheets
    newSheet = comparableSheet();
    createdDrawing.addSheet(newSheet);
    
    debugprint(sprintf("Looking at the %d th sheet", sheetNum),2);
    
    % Fills out the drawing sheets header
    fillSheetHeaders(newSheet, excelAsCell, lineNumber);
    lineNumber = lineNumber + 2;
    
    % To stop a out of bounds error just do a quick check.
    if size(excelAsCell, 1) < lineNumber + 2
        break
    end
    
    % Check for a BOM or Other table immediately after
    % Eventually might want to make this smarter, in that the VBA can
    % figure out when students add multiple tables and whatnot.
    if excelAsCell{lineNumber + 2,col} == "Col Width"
        % Do BOM Handling
        newBOM = comparableBOM();
        newSheet.addBOM(newBOM);
        debugprint("Found a bom on this sheet!", 2);
        fillBOMHeaders(newBOM, excelAsCell, lineNumber);
        
        % Grab a section of the cell array and dump it into the BOM
        beginCol = 2;
        beginRow = lineNumber + 3;
        
        endCol = beginCol + newBOM.numcolumns;
        endRow = beginRow + newBOM.numrows;
        
        % Parenthesis indexing to maintain the cells instead of creating a
        % Comma seperated list.
        newBOM.table = excelAsCell(beginRow:endRow, beginCol:endCol);
        
        lineNumber = endRow + 1;
    end
    
    % View Loops
    for viewNum = 1:newSheet.numViews
        
    
    end
end
end

