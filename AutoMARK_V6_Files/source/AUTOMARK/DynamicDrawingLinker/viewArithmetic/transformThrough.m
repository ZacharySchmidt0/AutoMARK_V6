function [endingVector, wasMirrored, hasPolar, wasRelated] = transformThrough(startingView, endingView, startingVector)
% The transformer figures out what happens when you go from one view to
% another.
% It will tell you what would happen to linear dimensions and datums.

% Various Matrixes
projectionFlat = [1 0 0; 0 1 0; 0 0 0];
mirrorXY       = [0 1 0; 1 0 0; 0 0 1];
mirrorFlat = projectionFlat * mirrorXY;

% Right
rRot = [0 0 -1; 0 1 0; 1 0 0];

% Left
lRot = inv(rRot);

% Up
uRot = [1 0 0; 0 0 -1; 0 1 0];

% Down
dRot = inv(uRot);

% Adding a Z axis
if length(startingVector) == 2
    startingVector(3) = 0;
end

% Making it a column vector
if isrow(startingVector)
    startingVector = transpose(startingVector);
end

% Begin with identity
endingVector = startingVector;


% Do some logic to figure out how the two views are related.

[transFormsTo, wasRelated] = relatedViews(startingView, endingView);

% If it actually was related, perform all the transforms
if wasRelated
    
    for i = 1:length(transFormsTo)
        
        if transFormsTo(i) == "L"
            endingVector = lRot * endingVector;
        elseif transFormsTo(i) == "R"
            endingVector = rRot * endingVector;
        elseif transFormsTo(i) == "U"
            endingVector = uRot * endingVector;
        elseif transFormsTo(i) == "D"
            endingVector = dRot * endingVector;
        else
            % Was I or broken, -> Isn't actually related
            wasRelated = false;
            break
        end
    end
end

% Check to see what happened when you transformed
% If you ended up turning around OR you end up turned around when flipped
% along the XY plane then you DO mirror.
% epsilon for small floating point errors
if dot(projectionFlat * startingVector, mirrorFlat * endingVector) < -0.0000001 || dot(projectionFlat * startingVector, projectionFlat * endingVector) < -0.0000001
    wasMirrored = true;
else
    wasMirrored = false;
end

% If you end up having a polar component then you likely don't exist!
if abs(endingVector(3)) > 0.0000001
    hasPolar = true;
else
    hasPolar = false;
end

end

