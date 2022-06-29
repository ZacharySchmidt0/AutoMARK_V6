% Build a test PDF using the ExampleStudent and ExampleKey Folders in
% source.
% Must be run whilst in the Consolidated Project Directory, just like
% AUTOMARK.

% Not needed anymore
% Change path to HERE
%if(~isdeployed())
%  cd(fileparts(which(mfilename)));
%end

[thisfolder, ~, ~] = fileparts(which(mfilename));

% Need this in path
addpath(genpath(fullfile(thisfolder, 'source')));

% We modify the paths, so that they are position independent!
path_to_student_variables = fullfile(thisfolder, "source\REPORTTOOLS\LatexPrinting\ExampleStudent_12345678_assignsub\MatlabVariables\Student Variables 2019-08-28-09-57-51.mat");
path_to_student_folder = fullfile(thisfolder, "source\REPORTTOOLS\LatexPrinting\ExampleStudent_12345678_assignsub");
path_to_key_folder = fullfile(thisfolder, "source\REPORTTOOLS\LatexPrinting\ExampleKey\");
path_to_student_pdf = fullfile(thisfolder, "source\REPORTTOOLS\LatexPrinting\ExampleStudent_12345678_assignsub\EclassExport\ExampleStudent Report.pdf");

% Load in the student variables
load(path_to_student_variables);

% Close the figure
close(studentReport.sfigure);

% Get the key Drawing
keyDrawing = studentLinker.returnPair(studentDrawing);

% Hot patch the path (since this computer didn't create the key template).
keyDrawing.studentReportFolder = path_to_key_folder;

% Now we can actually run CreateStudentPDF
% Create the PDF
createStudentPDF(path_to_student_folder, studentReport, studentLinker);

% Move it out of the student "EclassExport" to up here
movefile(path_to_student_pdf, ".\ExampleStudent Report.pdf", 'f');

