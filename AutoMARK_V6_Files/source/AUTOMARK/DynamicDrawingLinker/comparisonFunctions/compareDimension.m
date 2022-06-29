function comparescore = compareDimension(keyDimension, studentDimension, linker)
%COMPARE Compares two datums and assigns a score for similarity
% Dimensions can also cross link, this means that some very fancy mathematics
% happens in order to link them together which involves 3D rotations
comparescore = 100;


% Marks Lost Per / Marks Lost total
%   Handling Varies depending on Dimensions
%
%   For ALL Dimensions
%   View not correct -> 30 points
%   Types not correct -> Some leway with matrix of reductions
%   Value Not correct  -> Oddball leniency (more lenient for smaller
%   numbers).
%   Value Not correct  -> 10 points for difference above epsilon (0.0001)

%   Lots of special handling for arrow position, Comes from matrix of
%   handling


keyView = keyDimension.parent;
studentView = studentDimension.parent;

% Ideally this be a thing
studentViewPair = linker.returnPair(studentView);

keyViewDiagonal = norm([keyView.xmax - keyView.xmin, keyView.ymax - keyView.ymin]);
studentViewDiagonal = norm([studentView.xmax - studentView.xmin, studentView.ymax - studentView.ymin]);

keySheetWidth = keyView.parent.width;
studentSheetWidth = studentView.parent.width;


% Where is the Dimension relative to the view!
keyAnnVec = [keyDimension.annx, keyDimension.anny];
studentAnnVec = [studentDimension.annx, studentDimension.anny];

keyArrow1Vec = [keyDimension.arrow1x, keyDimension.arrow1y];
keyArrow2Vec = [keyDimension.arrow2x, keyDimension.arrow2y];

studentArrow1Vec = [studentDimension.arrow1x, studentDimension.arrow1y];
studentArrow2Vec = [studentDimension.arrow2x, studentDimension.arrow2y];

keyViewVec = [keyView.xmin, keyView.ymin];
studentViewVec = [studentView.xmin, studentView.ymin];


% Comparision starts here
viewLoss = 0;
if keyView ~= studentViewPair % Wrong view
    viewLoss = 30;
end

% No longer used
valtypeLoss = 0;
% 1 is Anglular, 0 is linear, these things are never equivalent
% This is redundant, The Type Checking will do this
% if keyDimension.dimension1type ~= studentDimension.dimension1type
%    valtypeLoss = 110;
% end

% Assumption -> Key doesn't have 0 length dimensions!
if keyDimension.dimension1value ~= 0
    if keyDimension.dimension1type == 0 % Linear Dimension
        % This is almost certainly in mm
        % Relatively more lenient for smaller values
        valLoss = min(70, 80/0.15 * abs((keyDimension.dimension1value - studentDimension.dimension1value))/(abs(keyDimension.dimension1value) + 10));
    else
        % Likely an angular dimension
        % 80 at 30 degrees
        valLoss = min(80, 80/0.15 * abs((keyDimension.dimension1value - studentDimension.dimension1value)/0.523599));
    end
    
    % Any difference whatsoever is 10, this makes it a stepped change
    if abs(keyDimension.dimension1value - studentDimension.dimension1value) > 0.01 
        valLoss = valLoss + 10;
    end
else
    debugprint("The key has zero-valued dimensions, These aren't supposed to exist!", 1);
    if studentDimension.dimension1value ~= 0
        valLoss = 80;
    else
        valLoss = 0;
    end
end

% Chamfers are weird, check both values
if keyDimension.type == 10 && studentDimension.type == 10
   valLoss = min(90, 80/10 * abs(keyDimension.dimension1value - studentDimension.dimension1value) + 90 * abs((keyDimension.dimension2value - studentDimension.dimension2value))/(abs(keyDimension.dimension2value) + 10));
end


% Position Difference
% No longer used
annPossLoss = 0;
% annPossLoss = min(15, 20/0.15*abs(norm(keyAnnVec/keySheetWidth - studentAnnVec/studentSheetWidth)));

comparescore = comparescore - viewLoss - valtypeLoss - valLoss - annPossLoss;

% All the different types of dimensions
% Listed, but not used
dimUnknown = 0;         % Used
dimOrdinate = 1;        % Weird
dimLinear = 2;          % Used
dimAngular = 3;         % Used
dimArcLength = 4;       % Weird
dimRadial = 5;          % Used
dimDiameter = 6;        % Used
dimHorOrdinate = 7;     % Weird
dimVertOrdinate = 8;    % Weird
dimZAxis = 9;           % Weird
dimChamfer = 10;        % Used
dimHorLinear = 11;      % Weird
dimVertLinear = 12;     % Weird
dimScalar = 13;         % Weird

% Copied from the Excel File
typeLossMatrix = [0	50	50	50	50	50	50	50	50	50	50	50	50	50;
    50	0	100	100	100	100	100	100	100	100	0	0	100	100;
    50	100	0	100	100	100	50	100	100	100	100	0	0	100;
    50	100	100	0	100	100	100	100	100	100	100	100	100	100;
    50	100	100	100	0	100	100	100	100	100	100	100	100	100;
    50	100	100	100	100	0	100	100	100	100	100	100	100	100;
    50	100	50	100	100	100	0	100	100	100	100	50	50	100;
    50	100	100	100	100	100	100	0	100	100	100	100	100	100;
    50	100	100	100	100	100	100	100	0	100	100	100	100	100;
    50	100	100	100	100	100	100	100	100	0	100	100	100	100;
    50	0	100	100	100	100	100	100	100	100	0	100	100	100;
    50	0	0	100	100	100	50	100	100	100	100	0	0	100;
    50	100	0	100	100	100	50	100	100	100	100	0	0	100;
    50	100	100	100	100	100	100	100	100	100	100	100	100	0];

% Pasted into matlab, then copied from variables
functionHandlingMatrix = ["A","A","A","A","A","A","A","A","A","A","A","A","A","A";"A","B","X","X","X","X","X","X","X","X","B","B","X","X";"A","X","B","X","X","X","E","X","X","X","X","B","B","X";"A","X","X","C","X","X","X","X","X","X","X","X","X","X";"A","X","X","X","C","X","X","X","X","X","X","X","X","X";"A","X","X","X","X","C","X","X","X","X","X","X","X","X";"A","X","E","X","X","X","D","X","X","X","X","E","E","X";"A","X","X","X","X","X","X","B","X","X","X","X","X","X";"A","X","X","X","X","X","X","X","B","X","X","X","X","X";"A","X","X","X","X","X","X","X","X","A","X","X","X","X";"A","B","X","X","X","X","X","X","X","X","C","X","X","X";"A","B","B","X","X","X","E","X","X","X","X","B","B","X";"A","X","B","X","X","X","E","X","X","X","X","B","B","X";"A","X","X","X","X","X","X","X","X","X","X","X","X","A"];

% Plus one as matlab is 1 indexed, but the types begin at 0
typeLoss = typeLossMatrix(keyDimension.type + 1, studentDimension.type + 1);

% Only Function "B" (Linear Rotations) allows this!
if studentViewPair ~= keyView
    wrongViewLoss = 110;
else
    wrongViewLoss = 0;
end
        
% Position Losses are one of 6 different types!
switch functionHandlingMatrix(keyDimension.type + 1, studentDimension.type + 1)
    case "A"
        posLoss = APosition();
    case "B"
        posLoss = BPosition();
        wrongViewLoss = 0;
    case "C"
        posLoss = CPosition();
    case "D"
        posLoss = DPosition();
    case "E"
        posLoss = EPosition();
    otherwise % "X"
        posLoss = 10;
end

comparescore = comparescore - typeLoss - posLoss - wrongViewLoss;

% Renormalize
comparescore = normalizeScore(comparescore);

    function posLoss = APosition()  %  Relative Annotation Position
        
        keyAnnPosRel = (keyAnnVec - keyViewVec)/keySheetWidth;
        studentAnnPosRel = (studentAnnVec - studentViewVec)/studentSheetWidth;
        
        posLoss = min(40, 40/0.15 * abs(norm(keyAnnPosRel - studentAnnPosRel)));
        
       
        
    end
    function posLoss = BPosition()  % Linear Rotations
        % Complicated Mess, sorry!
        
        % The arrows create a line
        keyArrowVector = (keyArrow2Vec - keyArrow1Vec);
        studentArrowVector = (studentArrow2Vec - studentArrow1Vec);
        
        rotateMatrix = [0 1; -1 0];
        
        % Figure out what happened to the dimensions if it wasn't on the
        % correct view!
        [fixedStudentArrowPosed, ~, hasPolar, wasRelated] = transformThrough(studentViewPair, keyView, studentArrowVector);
        
        % Mirroring Happens Perpendicularly, its just how the math works
        [~, wasMirrored, ~, ~] = transformThrough(studentViewPair, keyView,  studentArrowVector * rotateMatrix);
        
        % Fixed student is rotated through the different positions
        fixedStudent = [fixedStudentArrowPosed(1), fixedStudentArrowPosed(2)];
        
        % Angle between is the angle
        angleBetween = acos(abs(dot(keyArrowVector, fixedStudent)/(norm(keyArrowVector) * norm(fixedStudent))));

        
        % Huge loss for being angled
        angleLoss = min(110, 200*angleBetween/0.174533);
        
        % Any change whatsoever will make it at least 10 loss
        if angleBetween > 0.001
            angleLoss = angleLoss + 10;
        end
        
        % If we couldn't be related then their are huge problems
        if ~wasRelated || hasPolar
            angleLoss = 110;
        end
        
        % Get the distances!
        [keyPerpDist, keyMidpointDist] = perpDistance(keyArrow1Vec, keyArrow2Vec, keyViewVec);
        [studentPerpDist, studentMidpointDist] = perpDistance(studentArrow1Vec, studentArrow2Vec, studentViewVec);
        
        % Normalize
        keyPerpDist = keyPerpDist / keyViewDiagonal;
        studentPerpDist = studentPerpDist / studentViewDiagonal;
        
        keyMidpointDist = keyMidpointDist / keyViewDiagonal;
        studentMidpointDist = studentMidpointDist / studentViewDiagonal;
        
        if wasMirrored
            studentPerpDist = (1/sqrt(2)) - studentPerpDist;
        end
        
        % You can have a 30 loss for perp, not very much
        % 50% at 25% difference, this is pretty generous actually.
        perpLoss = min(30, 50/0.25 * abs(keyPerpDist - studentPerpDist));
        
        % Same
        paraLoss = min(30, 50/0.25 * abs(keyMidpointDist - studentMidpointDist));
        
        posLoss = angleLoss + perpLoss + paraLoss;
    end

    function posLoss = CPosition()  % Arrow Handling
        
        keyArrow1RelPos = (keyArrow1Vec - keyViewVec)/keySheetWidth;
        keyArrow2RelPos = (keyArrow2Vec - keyViewVec)/keySheetWidth;
        
        studentArrow1RelPos = (studentArrow1Vec - studentViewVec)/studentSheetWidth;
        studentArrow2RelPos = (studentArrow2Vec - studentViewVec)/studentSheetWidth;
        
        
        % If they have 0 arrow 2s
        if all(keyArrow2Vec == [0 0])
           
            % All the weight is on arrow 1
            posLoss = min(40, 40/0.15 * norm(keyArrow1RelPos - studentArrow1RelPos));
            
        else
            
            % The arrows are interchangable, so use the minimum distances
            posLos1 = min(norm(keyArrow1RelPos - studentArrow2RelPos), norm(keyArrow1RelPos - studentArrow1RelPos));
            posLos2 = min(norm(keyArrow2RelPos - studentArrow2RelPos), norm(keyArrow2RelPos - studentArrow1RelPos));
            
            posLoss= min(40, 20/0.15 * (posLos1 + posLos2)); 
        end
    end

    function posLoss = DPosition()  % Arrow Midpoint Handling
        
        keyArrowMidRel = (keyArrow1Vec + keyArrow2Vec - 2*keyViewVec)/ (2 * keySheetWidth);
        studentArrowMidRel = (studentArrow1Vec + studentArrow2Vec - 2 * studentViewVec) / (2*studentSheetWidth);
        
        posLoss = min(40, 40/0.15 * norm(keyArrowMidRel - studentArrowMidRel));
        
    end
    function posLoss = EPosition()  % Weak Position Handling
        
        keyAnnPosRel = (keyAnnVec - keyViewVec)/keySheetWidth;
        studentAnnPosRel = (studentAnnVec - studentViewVec)/studentSheetWidth;
        
        posLoss = min(10, 10/0.15 * abs(norm(keyAnnPosRel - studentAnnPosRel)));
    end
end