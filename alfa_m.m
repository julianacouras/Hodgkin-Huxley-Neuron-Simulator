function [Am] = alfa_m(V)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Am = (0.1*(V+40))./(1-exp(-0.1*(V+40)));
end

