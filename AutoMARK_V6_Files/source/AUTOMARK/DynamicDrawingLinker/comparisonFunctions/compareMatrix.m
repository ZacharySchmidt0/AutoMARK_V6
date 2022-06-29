function comparisonMatrix = compareMatrix(keyVector, studentVector, comparisonFunction, optionalLinker)
%COMPAREMATRIX Given two vectors (a) and (b) and a comparasion function
% f(). Compute the matrix where you perform every pairwise comparison

% Matrix of values
comparisonMatrix = zeros(length(keyVector), length(studentVector));


% If statement brought out for speed as well
if nargin == 4
    % Iterate through ever element
    % iteration is done in column major order for speed
    for i = 1:size(comparisonMatrix, 2)
        for j = 1:size(comparisonMatrix, 1)
            % Compare the i,j'th elements
            comparisonMatrix(j, i) = comparisonFunction(keyVector(j), studentVector(i), optionalLinker);
        end
    end
else
    % Iterate through ever element
    % iteration is done in column major order for speed
    for i = 1:size(comparisonMatrix, 2)
        for j = 1:size(comparisonMatrix, 1)
            % Compare the i,j'th elements
            comparisonMatrix(j, i) = comparisonFunction(keyVector(j), studentVector(i));
        end
    end
end
end

