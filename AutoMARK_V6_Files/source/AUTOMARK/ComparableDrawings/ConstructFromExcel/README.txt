These functions parse the Excel file and create/populate the drawing object.

They read the header to find the type of object that will be created,
then move across a row, matching the cell to an attribute name and
fill in that attribute name with the value.
