function [C,T]=hungarianMax(A)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[C, T] = hungarian(-A);
T = -T;

end

