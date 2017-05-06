function [An] = alfa_n(V)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
An = (0.01*(V+55))./(1-exp(-0.1*(V+55)));
end

