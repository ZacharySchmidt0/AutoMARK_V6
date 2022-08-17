This contains all of the class files for the comparable drawing objects. I am going through
and implementing an internal representation for the Solidworks drawings which will be used to
mark.

All of the classes (other than comparableDrawing) have an attribute called "parent" which
allows for moving up/down the class heirarchy.

* comparableTemplate.m
	This file is a template, not a programatic one but an acutal template to copy and paste
	to make new classes.
	Mainly exists because MATLAB's default template for classes is actually pretty bad.
	
* comparingBase.m
	This is the base class from which other ones are derived. Currently all it does more or less
	is pull in a handle so that all other classes are handle classes.	
	I call it constructor though in each of the derived classes even though the constructor does
	nothing incase I want the constructor to do something later.

* comparableDrawing.m
    This is the base drawing object, this is the parent of all the children and other drawing objects.
    It has the file level - properties in it. It's also what will get passed around to the templater and
    linker.

* comparableSheet.m
    Representation of a single sheet as far as marking is concerned!
    Sheets are fancy objects and they actually have pointers to everything
    contained within them. They have the most "child" properties of all the objects.
    
    Any dangling feautres would still show up here which is important as otherwise
    dangling features wouldn't fit anywhere.

* comparableBOM.m
    The representation of a BOM table. Attributes for rows/columns, size, location,
    headers, font, and style.

* comparableView.m
    Views are the individual views in the actual sheet. They don't contain any fancy
    alignment information and determining that must be done programatically.

* comparableViewModel.m
    View Model info is stored in the excel spreadsheet. This is likely a very good method for 
    determining which view is which! Since the objects might differ!

* comparableDimension.m
    Its the representation of a dimension, its actually overarches all types of dimensions you
    can put on the actually sheet!

* comparableBalloon.m
    The representation of a balloon/note. Attributes for text, location,
    leaderlines, and arrowheads.

* comparableDatum.m
    The representation of a datum line. Attributes for line start/end location and style.

* comparableCentermark.m
    The representation of a cecntermark. Attributes for location, grouping,
    extensions, and style.

* comparableCenterline.m
    The representation of a centerline. Attributes for start/end location and style.
