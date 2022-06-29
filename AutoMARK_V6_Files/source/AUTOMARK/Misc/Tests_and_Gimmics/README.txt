This folder contains some general purpose files which I decided to created in case I wanted to use
powerful features which are supported in other languages but not in MATLAB, such as Python iterators
and dynamicly resizable arrays (similar to C++ Vectors) which have O(n) append times.

MATLAB is indeed slow with its concatination being O(n^2) but it turns out the crossover point at which
the dynamic array class I have written is at 10,000 appends.

That being said its entirely because MATLAB is ridiculously slow with its appends and it runs a little over
800 times slower than a C++ based vector.

That being said, that is still more than fast enough since even at that rate you can do several thousand appends
in the least efficent manner possible in a few tens of milliseconds.

The current (2019-05-27) verdict is that I really shouldn't bother for speed. Even an incredibly Naive AUTOMARK 
will be quite quick.
