All "comparison" functions work the same way.
They take in a <key, student> pair of object handles and return a score from 0 to 100
which represents how well the student matches the key.

Most of them do some simple analysis to determine this score.

compareMatrix is a function which creates a matrix for every pairwise comparision given a comparison function
and two vectors of key objects and student objects.

Pairwise peaks is a greedy algorithm that tries to return the best set of matches.

normalizeScore performs a simple normalization using a logistic function centered at 50 with height 100
and logistic growth rate (steepness) of 1/12