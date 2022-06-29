function [maxIndexs, averageScore] = pairwisePeaks(pairedPeaks, minscoretolink)
global NEARMISSDETECTION
% Suppose you are passed an n by m matrix of numbers.
%   1   2   3   3
%   3   4   2   1
%   3   3   3   4
% Its your goal to choose k = min(n,m) numbers from this list
% Such that you maximize the sum of there values. 
%
% You can't just choose the numbers arbitrarily though. 
% The numbers must have a unique row and column.
%
% I believe this is called the maximum weight bipartite matching problem
% Which is solvable in polynomial time.
%
% But because the data is decidedly not random, this is just the greedy
% algorithm

% K is the number of elements we choose
k = min(size(pairedPeaks));
averageScore = 0;

if isempty(pairedPeaks)
    % Null set perfectly links
    averageScore = 100;
end

% By default use 2.4 as our cuttoff
if nargin < 2
    minscoretolink = 2.4;
end

% Find problematic sets given a coupled set.
% Purely for debug purposes, just ignore this if you aren't trying to make
% the linker better.
%
% If you are making the linker better. What this does is tell you the
% highest score not on the main diagonal. Useful when you are seeing what
% happens when you link the drawing to itself.
if ~isempty(NEARMISSDETECTION) && ( size(pairedPeaks, 1) == size(pairedPeaks, 2) ) && ~isempty(pairedPeaks)
    offmain = pairedPeaks .* ~eye(size(pairedPeaks, 1));

    highest = max(max(offmain));
    debugprint(sprintf("Off main diagonal had a peak of %g", highest), 1);
end

% First sort entire set, finding the peak indexes
[matchScores, peakIndexs] = sort(reshape(pairedPeaks, 1, []), 'descend');

% The indexes of the maximums
maxIndexs = zeros(k, 2);

% i is the current number we check
% j is how many indexes have been found already
i = 1;
j = 0;

% Keep looping till we have all k numbers, or until the link score is
% really bad
while j < k && matchScores(i) > minscoretolink
    % Unflattens the i'th index
    [row, col] = ind2sub(size(pairedPeaks), peakIndexs(i));
    
    % If there are no matches to previous rows and columns
    if ~any(maxIndexs == [row, col], 'all')
        
        debugprint(sprintf("Settled with score %g", matchScores(i)), 1);
        averageScore = averageScore + pairedPeaks(row, col)/max(size(pairedPeaks));
        j = j + 1;
        
        % Add these to the max indexs
        maxIndexs(j, :) = [row, col];
    end
    
    i = i + 1;
end

% If we did this, we will get zeros
if j < k && matchScores(i) < 2.5
    maxIndexs = maxIndexs(1:j, :);
end
    
end

