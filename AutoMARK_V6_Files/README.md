# AutoMark

Most recent revisions made by Zachary Schmidt and Jason Kim under the 
supervision of Dr. David Nobes in the Summer of 2022.

Introduction
    The purpose of AutoMark is to automate the marking
    of MEC E 265 SolidWorks assignments. It was developed over several years
    by David Nobes and University of Alberta Engineering Co-op students.
    In its current state, AutoMark can mark hundreds of submissions in a
    matter of hours, greatly reducing the time required by TAs to mark
    assignments, which they previously did by hand.

Required Installs
    - SolidWorks
    - Microsoft Excel
    - Matlab
    - Matlab Add-Ons:
        - Symbolic Math Toolbox
        - Statistics and Machine Learning Toolbox
        - Simulink
        - Image Processing Toolbox
        - Computer Vision Toolbox
    - MiKTeX

Marking Process Outline
    - First, the data from a SolidWorks drawing is acquired through the
      use of a VBScript Solidworks Macro (the .swp files). The macro is
      able to pull all of the useful data found on a SolidWorks drawing.
      This data is then written out to an Excel spreadsheet.

    - After running the macros on the answer key and student submissions,
      all of the data about the drawings is in Excel. Matlab can then very
      easily parse these Excel files and create objects representing a key
      or student's drawing.

    - For each feature (sheet, view, centerline, dimension, etc.) if there is
      a difference wider than the acceptable tolerance between the student and key,
      marks are deducted for that criterion. This comparison is done for every
      criterion of every feature on the drawing.

    - For each correct or incorrect element, a markup is performed on the PDF
      report that will be returned to the student. The markup is done using TeX, a 
      typesetting "language" that allows for very specific control of text/image
      formatting.

Layout of Files/Folders
  For future developers, it is useful to know what is contained in each folder
  when fixing bugs/implementing new features. The purpose of the functions
  in the most important folders (not all included here) will be described below.

  AUTOMARK
    executeMarkingOnFolder.m
      Runs through the Student Folder and calls executeMarking() to mark each
      student.
    executeMarking.m
      Marks a single student. For each feature, calls the .evaluateOn() 
      method that actually performs marking.
    markSingleSub.m
      Called when "Run Marking on 1 Student" button is pushed. Similar to 
      markSingle() with some minor tweaks.
    ComparableDrawings
      Subfolder ComparableDrawingClasses contains class definitions for each
      class/subclass of a drawing. These classes are how the data for a drawing
      is stored.
      Subfolder ConstructFromExcel has funtions that will populate the attributes
      of the drawing objects after parsing the ExcelExtract file.
    DynamicDrawingLinker
      The funtions in this folder try to match a feature in the key to a feature on
      the student's submission. The comparisonFuntions will compare each feature of some
      type (eg: a centerline) to the features of the same type on the submission.
      The functions will return a value representing how well the two features match.
      The feature on the submission with the highest score will be "linked" to the feature
      on the key. The marking done later will then compare these two linked features.
    MarkingCriterion
      This is where the actual marking takes place. Each folder represents a feature 
      and each .m file within the folders represents a criterion.
    MarkingReports
      Helps make the report that is returned to the student.
    MarkingTemplate
      Makes the key template (keytemplate.mat) from the ExcelExtract. Adds all
      of the crtierion to each feature.

  GUI
    AutoMacroGUI
    DrawingEngine
    Highlighting
    Highlighting2
    Highlighting3
    infoGUI
    MarkingGUI
    settingsGUI
    TemplateGUI

  ReportTools
    LatexPrinting
    PDFRead
