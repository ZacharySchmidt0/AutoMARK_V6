This folder contains a simple class, the class is meant to investigate if MATLAB collects garabage in a smart way.
By making a simple tree structure, which is representative of the actually structure used in AUTOMARK and manually 
changing some pointers to point to themselves. I am creating a situation where the garbage collector has to think hard
about what memory needs to be cleared where due to complex cycles.

The verdict is that the collected is smart enough and no changes to the current planned structure (as of 2019-05-27) will 
need to be made.