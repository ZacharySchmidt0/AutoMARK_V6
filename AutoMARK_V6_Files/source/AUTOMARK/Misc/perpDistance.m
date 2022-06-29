function [dis, midpointdis] = perpDistance(p1, p2, p3)
%PERPDISTANCE Computes perpendicular distance from a point to a line
% P1 and P2 define a line, and P3 is the perpendicular.

% Some vector v = p2 - p1
v = p2 - p1;

% Point on line where closest to p3
p4 = p1 + (dot(v, p3-p1)/dot(v,v)) * v;

dis = norm(p3 - p4);
midpointdis = norm(p4 - (p1+p2)/2);
end

