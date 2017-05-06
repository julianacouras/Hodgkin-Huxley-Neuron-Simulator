function [Ah] = alfa_h(V)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

Ah = 0.07*exp(-0.05*(V+65));
end

