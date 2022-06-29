All "comparision" functions work the same way.
They take in a <key, student> pair of object handles and return a score from 0 to 100
which represent how well two things match together.

Most of them do some simple analysis to determine this score.

compareMatrix is a function which creates a matrix for every pairwise comparision given a comparasion function
and two vectors of key objects and student objects.

Pairwise peaks is a greedy algorithm that tries to return the best set of matches.

normalizeScore performs a simple normalization using the sigmoid function centered at 50 with height 100 (and width 12)