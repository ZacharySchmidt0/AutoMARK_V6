# AutoMark

Most recent revisions made by Zachary Schmidt and Jason Kim under the 
supervision of Dr. David Nobes in the Summer of 2022.

Introduction
    AutoMark is a project whose purpose is to automate the marking
    of MEC E 265 SolidWorks assignments. It was developed over several years
    by David Nobes and University of Alberta Engineering Co-op students.
    In its current state, AutoMark can mark hundreds of submissions in a
    matter of hours, greatly reducing the time required by TAs to manually
    grade assignments.

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