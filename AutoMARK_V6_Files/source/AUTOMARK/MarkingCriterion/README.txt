This is where the marking/comparison with the key actually takes place.

Generally, for each feature, there is one function for each criterion which
compares the keyFeature with the studentFeature and returns 0 if that criterion
is correct and 1 if that criterion is incorrect. The appropriate markup function
is called if a criterion is incorrect.

Note the comparison between floating point numbers always includes a very small
tolerance. This prevents incorrectly taking marks off since 1.0E-15 does not
technically equal 0. A small tolerance assures that insignificant differences like
this are ignored. 