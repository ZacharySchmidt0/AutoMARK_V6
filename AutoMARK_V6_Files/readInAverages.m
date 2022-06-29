% this file plots a graph with one axis being automark score and the other
% being ta given grade simply call it with the letter that is the coloumn
% of the excel sheet that stores the ta grades. it will prompt u for a
% excel extract sheet and the location of the ta excel file
function assignAverages = readInAverages(letter)
    [autoMarkFile, folder] = uigetfile('*.xlsx', 'Select Automark excel output');
    autoMarkFile = fullfile(folder, autoMarkFile);
    [num, text, raw] = xlsread(autoMarkFile, 1, 'A:A');
    studentNames = text(2:end);
    autoMarkScores = xlsread(autoMarkFile, 1, 'B:B');
    autoMarkTotal = xlsread(autoMarkFile, 1, 'C2');
    originalScores = autoMarkScores;
    autoMarkScores = autoMarkScores ./ autoMarkTotal;
    autoMarkContainer = containers.Map();
    autoMarkScaledContainer = containers.Map();
    autoMarkScores = autoMarkScores * 100;
    for i = 1:length(studentNames)
        autoMarkContainer(studentNames{i}) = autoMarkScores(i);
    end
    
    [taFile, folder] = uigetfile('*.xlsx', 'Select the file with final marks');
    taFile = fullfile(folder, taFile);
    [~, firstNames] = xlsread(taFile,1,strcat('B:B'));
    firstNames = firstNames(2:end);
    [~, lastNames] = xlsread(taFile,1,strcat('C:C'));
    lastNames = lastNames(2:end);
    for i = 1:length(lastNames)
        names(i) = {[firstNames{i} ' ' lastNames{i}]};
    end
    finalMarkTotal = xlsread(taFile, 1, strcat(char(letter-1), '2'));
    scaleFactor = autoMarkTotal / finalMarkTotal;
    scaledScores = round(originalScores ./ scaleFactor);
    scaledPercent = ((scaledScores)./finalMarkTotal) * 100;
    for i = 1:length(studentNames)
        autoMarkScaledContainer(studentNames{i}) = scaledPercent(i);
    end
    [num, text, raw] = xlsread(taFile,1,strcat(letter, ':', letter));  
    num = num(:, 2);
    num = num(3:end);
    taContainer = containers.Map();
    for i = 1:length(names)
        taContainer(names{i}) = num(i);
    end
    keySet = keys(autoMarkContainer);
    for i = 1:length(keySet)
        dataPoints(i, :) = [autoMarkContainer(keySet{i}), taContainer(keySet{i})];
        scaleddataPoints(i, :) = [autoMarkScaledContainer(keySet{i}), taContainer(keySet{i})];
    end
    f1 = figure;
    f2 = figure;
    scatter(dataPoints(:,1), dataPoints(:,2), 'filled');
    hold on
    plot([0:1:100], [0:1:100]);
    title('Unscaled Plot of Marks');
    xlabel('AutoMark assigned grade');
    ylabel('TA assigned grade');
    hold off;
    figure(f1);
    scatter(scaleddataPoints(:,1), scaleddataPoints(:,2), 'filled');
    hold on
    plot([0:1:100], [0:1:100]);
    title('Scaled Plot of Marks');
    xlabel('AutoMark scaled and rounded grade');
    ylabel('TA assigned grade');
    hold off;
    
end