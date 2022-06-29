Highlighting 2 is unlike highlighting. Its more focused on actually integrating with AUTOMARK.

Firstly, ALL Highlighting 2 functions start with h, h stands for handle in this case.

All highlighting functions share the same signiture:


gArray = hFunction(iHandler, colour, ... some number of arguments for position .... , ... some number of arguments for style ...);

Parameters: 
    iHandler is the image handler on which to draw (The axis is grabbed from the handler).
    Colour is a vector of 3 numbers [r g b] where 0 <= r,g,b <= 1
    The arguments for position are in Solidworks coordinates, not pixel and not axis coordinates.
    Arguments for style are things like lineWidth and arrow size.

Return:
    gArray is a graphics placeholder array. Created with gobjects!