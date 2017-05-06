function [Bh] = beta_h(V)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

Bh = 1./(1+exp(-0.1*(V+35)));
end

