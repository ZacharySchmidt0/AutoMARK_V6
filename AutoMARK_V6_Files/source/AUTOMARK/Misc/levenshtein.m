function levenDistance = levenshtein(sourceString, targetString)
%LEVENSHTEIN Computes the levenshtein distance between two strings.

% Need them as char arrays
sourceString = char(sourceString);
targetString = char(targetString);

m = length(sourceString);
n = length(targetString);

% Make an array
memoTable = zeros(m + 1, n + 1);

% Transform to nothing
for i = 1:m
    memoTable(i + 1, 1) = i;
end
   
% Transform by inserting
for j = 1:n
    memoTable(1, j + 1) = j;
end

for j = 1:n
    for i = 1:m
        if lower(sourceString(i)) == lower(targetString(j))
            cost = 0;
        else
            cost = 1;
        end
        
        choices = [
            memoTable(i, j + 1) + 1 % Insertion
            memoTable(i + 1, j) + 1 % Deletion
            memoTable(i, j) + cost  % Subsitution
            ];
        
        memoTable( i + 1, j + 1) = min(choices);
    end
end

levenDistance = memoTable(end);
end
