% For some reason the current parsing keeps breaking, It seems to have to
% do with the sprintf method.

disp(sprintf("%s is a string and %d is an int", string(missing), 32));
