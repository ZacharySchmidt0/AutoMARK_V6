% Is it even bad to append to the end of an array continuously in matlab?

% Do a test in intervals of 10.
testSet = 5:100:20000;
resultSetMatlab = zeros(size(testSet));
resultSetDynamic = resultSetMatlab;

% See how long it takes to run the following for each
for i = 1:length(testSet)
    n = testSet(i);
    myArray = [0];
    myDynamic = dynamicArray();
    
    tic() % Start timer
    % Append n times
    for j = 1:n
        myArray = [myArray, 0];
    end
    resultSetMatlab(i) = toc(); % Store Results;
    
    tic() % Start timer
    % Append n times
    for j = 1:n
        myDynamic.append(0);
    end
    resultSetDynamic(i) = toc(); % Store Results;
end

plot(testSet, resultSetMatlab, testSet, resultSetDynamic)